function [feat, img, type] = features(filename, varargin)
%features    Detects regions and extracts descriptors
%
% Compute sparse features on Harris-Affine and MSER regions:
%   feat = features(img, ...
%    'descriptor', 'sift', 'ROI', 'ha', 'removeredund', 1);
%
% Compute denser features on edges:
%   feat = features(img, ...
%    'descriptor', 'sift', 'ROI', 'dense', 'removeredund', 1);
%
% Compute features over fixed-scale regions on regular grid:
%   feat = features(img, ...
%    'descriptor', 'sift', 'ROI', 'grid', 'step', 8, 'regionsize', 16);
%
% Format:
%   feat(1:2,:)   = region center (image location)
%   feat(3:5,:)   = region shape (covariance ellipse)
%   feat(6:133,:) = SIFT descriptor (dim = 128)
%
% This script calls functions provided by the Oxford Visual Geometry Group:
%    http://www.robots.ox.ac.uk/~vgg/software/
% Files needed:  h_affine.ln, mser.ln, compute_descriptors.ln
%
% Edge features use functions provided by Peter Kovesi's toolbox:
%    http://www.csse.uwa.edu.au/~pk/research/matlabfns/

% Set-up folders and temporary file names:
HOME_TDP  = '/home/luojf/tdp-r1';  % TODO:  Set this to TDP installation path
tmpFolder = fullfile(HOME_TDP, 'affineFeatures/tmp');
folder    = fullfile(HOME_TDP, 'affineFeatures');
tmpCode   = fullfile(tmpFolder, sprintf('tmp%d', (fix(rand*100000)+1)));

% Parse input parameters:
variables = {'scale', 'descriptor', 'roi', 'subsample', 'scalingdescriptor', 'removeredund', 'removelargeregions', 'circularroi', 'scaling', 'edges', 'step', 'regionsize'};
defaults = {0.001, 'sift', 'ha', 1, 1, 0, 1, 0, 1, 1, 8, 16};
[scale, descriptor, ROI, subsample, scalingDescriptor, removeRedund, removeLargeRegions, circularROI, scaling, edges, step, regionsize] = ...
    parseparameters(varargin, variables, defaults)

% Read image:
if ischar(filename)==0
   img = filename;
   imwrite(uint8(img), sprintf('%s.ppm', tmpCode), 'ppm');
   unix(sprintf('convert %s.ppm %s.ppm', tmpCode, tmpCode));
else
   if nargout == 3; img = imread(filename); end
   unix(sprintf('convert %s %s.ppm', filename, tmpCode));
end

% Extract regions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(ROI, 'grid')
	disp('Extract features on a regular grid')
    [nrows ncols cc] = size(img);
    
    [x,y] = meshgrid(ceil(regionsize/2):step:ncols-floor(regionsize/2), ceil(regionsize/2):step:nrows-floor(regionsize/2));
    
    x = x(:); y = y(:);
    scale = 1/regionsize/256/2;
	covRegion = scale^.5*[1 0 1]; % cov = [a b; b c]
	nb = length(x); dim = 1;
	feat = [x y repmat(covRegion, [nb 1])]';

	% 3) Write regions in a format that will be read by "compute_descriptors.ln"
	writeFeatures(sprintf('%s.feat',tmpCode), feat, nb, dim);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(ROI, 'dense')
	disp('Extract dense features on edges')
	edges = edge(mean(double(img),3), 'canny', [0.0 .005]);
	z = zeros(size(edges));
	z(1:subsample:end, 1:subsample:end) = edges(1:subsample:end,1:subsample:end);
	edges = z;

	% remove boundary
	b = 8; % remove eight pixels
	edges(1:b,:) = 0; edges(:,1:b) = 0; edges(end-b+1:end,:) = 0; edges(:,end-b+1:end) = 0;

	% 2) Select regions
	[y, x] = find(edges); x = x(:); y = y(:);
	covRegion = scale*[1 0 1]; % cov = [a b; b c]
	nb = length(x); dim = 1;
	feat = [x y repmat(covRegion, [nb 1])]';

	% 3) Write regions in a format that will be read by "compute_descriptors.ln"
	writeFeatures(sprintf('%s.feat',tmpCode), feat, nb, dim);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(ROI, 'ha')
	disp('HARRIS-AFFINE AND MAXIMALLY STABLE REGIONS')
	% 1) INTEREST REGION DETECTOR:
    
	detector{1} = sprintf('/home/luojf/h_affine.ln -hesaff -i %s.ppm -o %s.reg -thres 100', tmpCode, tmpCode);
	% 2) MAXIMALY STABLE REGION:
	detector{2} = sprintf('/home/luojf/mser.ln -per 1 -ms 30 -mm 5 -t 2 -i %s.ppm -o %s.reg', tmpCode, tmpCode);
length(detector)
	% REGION DETECTOR:
	feat = []; type = []; nb = 0;
	for i = 1:length(detector)
	   status = unix(detector{i});
% 	   tmpCode
	   [feati, nbi, dim] = loadFeatures(sprintf('%s.reg', tmpCode));
	   feat = [feat feati];
	   type = [type i*ones(1, nbi)];
	   nb = nb + nbi;
    end
pwd
    % Edge regions
    if edges
        % You need to install Peter Kovesi toolbox available online
        featedges = edgeROI(img);
        feat = [feat featedges];
        nbe = size(featedges,2);
        type = [type (i+1)*ones(1, nbe)];
        nb = nb + nbe;
    end

	% Remove redundant regions 
	if removeRedund == 1
	    j = removeRedundancy(feat, 2);
	    feat = feat(:,j);
	    type = type(j);
	    disp(sprintf('Reduce overlapping: from %d to %d regions', nb, length(j)))
	    nb = length(j);
	end

	% Scale the region of support of each feature
	if scalingDescriptor ~= 1
	    feat(3:5,:) = 1/scalingDescriptor^2 * feat(3:5,:);
        end
    
	% Use circular regions (use radium = average min and max axis)
	if circularROI == 1
	    nb = size(feat,2);
	    for c1 = 1:nb
	        Si = [feat(3,c1) feat(4,c1); feat(4,c1) feat(5,c1)];
		d = sqrt(det(Si));
		feat(3,c1) = d; feat(4,c1) = 0; feat(5,c1) = d;
	    end
	end

	% Remove large regions
	if removeLargeRegions == 1
	    % remove large regions to speed up computations.
	    [orientation, scale, aspectRatio] = getROIproperties(feat);
	    j = find(scale<300);
	    feat = feat(:,j);
	    type = type(j);
	    disp(sprintf('Remove large regions: from %d to %d regions', nb, length(j)))
	    nb = length(j);
	end

	writeFeatures(sprintf('%s.feat',tmpCode), feat, nb, dim);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE DESCRIPTORS:
status = unix(sprintf('/home/luojf/compute_descriptors.ln -%s -noangle -i %s.ppm -p1 %s.feat -o %s.feat.%s', descriptor, tmpCode, tmpCode, tmpCode, descriptor));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[feat, n, dim]=loadFeatures(sprintf('%s.feat.%s', tmpCode, descriptor));

% If there has been scaling to compute the descriptors, remove the scaling (only for ROI = 'ha'.
if scalingDescriptor ~= 1
   feat(3:5,:) = scalingDescriptor^2 * feat(3:5,:);
end

unix(sprintf('rm -f %s.*', tmpCode));

%%%%%%%%%%%%%%%%%
function [varargout] = parseparameters(var, variables, defaults);

N = length(variables);
for i = 1:N
    j = strmatch(variables{i}, lower(var(1:2:end)));
    if length(j)>0
        varargout(i) = {var{j(1)*2}};
    else
        varargout(i) = {defaults{i}};
    end
end


