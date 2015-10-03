function [feat, type, img] = h_affine(filename, scalingDescriptor, removeRedund)
%h_affine (OLD)     Detects regions and extracts descriptors
% This is an old function. It is better to use 'features.m'
%
% Uses:
%  [feat, type, img] = h_affine(filename)
%  [feat, type, img] = h_affine(img)
%  [feat, type, img] = h_affine(img, scalingDescriptor, removeRedundancy)
%
% Format:
%   feat(1:2,:) = center region
%   feat(3:5, :) = covariance region
%   feat(6:133, :) = SIFT descriptor (dim = 128)

% Read image:
% if ischar(filename)==0
%    img = filename;
%    imwrite(img, sprintf('%s.ppm', tmpCode), 'ppm');
%    unix(sprintf('convert %s.ppm %s.ppm', tmpCode, tmpCode))
% else
%    img = imread(filename); 
%    unix(sprintf('convert %s %s.ppm', filename, tmpCode))
% end
% 
% % Default parameters:
% if nargin < 3
%    removeRedund = 1; 
% end
% 
% descriptor = 'sift';
% ROI = 'ha';
% scalingDescriptor = 1; % 'ha'
% removelargeregions = 1;
% 
% feat = features(double(img), ...
%     'descriptor', descriptor, 'ROI', ROI, 'removeredund', removeRedund, 'removelargeregions', removelargeregions);
% 
% type = []; % this is not used anymore. So, no need to return it.
% 
% return


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS IS THE OLD SCRIPT: %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set-up folders and temporary file names:
HOME_TDP  = '';
tmpFolder = fullfile([HOME_TDP  'affineFeatures/tmp']);
folder    = fullfile(HOME_TDP, 'affineFeatures');
tmpCode   = fullfile(tmpFolder, sprintf('tmp%d', (fix(rand*100000)+1)));

% Default parameters:
if nargin  < 2
   scalingDescriptor = 1; % 1 = no scaling
end
if nargin < 3
   removeRedund = 1; 
end
removeLargeRegions = 1;

% Read image:
%name = sprintf('tmpImg%d.ppm',(fix(rand*1000)+1));
if ischar(filename)==0
   img = filename;
   imwrite(img, sprintf('%s.ppm', tmpCode), 'ppm');
   unix(sprintf('convert %s.ppm %s.ppm', tmpCode, tmpCode))
else
   if nargout == 3; img = imread(filename); end
   unix(sprintf('convert %s %s.ppm', filename, tmpCode))
end

% 1) INTEREST REGION DETECTOR:
detector{1} = sprintf('/home/zw/Projects/wine/bof/save_sift/ln_files/h_affine.ln -hesaff -i %s.ppm -o %s.reg -thres 5', tmpCode, tmpCode);
% 2) MAXIMALY STABLE REGION:
detector{2} = sprintf('/home/zw/Projects/wine/bof/save_sift/ln_files/mser.ln -per 1 -ms 30 -mm 5 -t 2 -i %s.ppm -o %s.reg', tmpCode, tmpCode);
%detector{2} = sprintf('/home/luojf/mser.ln -t 2 -es 2 -i %s.ppm -o %s.reg', tmpCode, tmpCode);

% REGION DETECTOR:
feat = []; type = []; nb = 0;
for i = 1:length(detector)
   status = unix(detector{i});
   tmpCode
   [feati, nbi, dim] = loadFeatures(sprintf('%s.reg', tmpCode));
   feat = [feat feati];
   type = [type i*ones(1, nbi)];
   nb = nb + nbi;
end
%status = unix('./h_affine.ln -hesaff -i img.ppm -o img.ha -thres 5');
%status = unix('./h_affine.ln -heslap -i img.ppm -o img.ha -thres 50');

% 2) MAXIMALY STABLE REGION:
%status = unix('./mser.ln -per 1 -ms 30 -mm 5 -t 2 -i img.ppm -o img.mser');

% Load features and group them:
%[feat1, nb1, dim] = loadFeatures(sprintf('%s.reg', tmpCode));
%[feat2, nb2, dim] = loadFeatures(sprintf('%s.reg2', tmpCode));
%feat = [feat1 feat2];
%type = [ones(1,nb1) 2*ones(1,nb2)];
%nb = nb1 + nb2;

% 3) PROCESS REGIONS
% Remove redundant regions 
if removeRedund == 1
    j = removeRedundancy(feat, 1);
    feat = feat(:,j);
    type = type(j);
    disp(sprintf('Reduce overlapping: from %d to %d regions', nb, length(j)))
    nb = length(j);
end

% Scale the region of support of each feature
if scalingDescriptor ~= 1
    feat(3:5,:) = 1/scalingDescriptor^2 * feat(3:5,:);
end

% Remove large regions
if removeLargeRegions == 1
    % remove large regions to speed up computations.
    [orientation, scale, aspectRatio] = getROIproperties(feat);
    j = find(scale<40);
    feat = feat(:,j);
    type = type(j);
    disp(sprintf('Remove large regions: from %d to %d regions', nb, length(j)))
    nb = length(j);
end

writeFeatures(sprintf('%s.feat',tmpCode), feat, nb, dim);

% 4) COMPUTE DESCRIPTORS:
status = unix(sprintf('/home/zw/Projects/wine/bof/save_sift/ln_files/compute_descriptors.ln -sift -noangle -i %s.ppm -p1 %s.feat -o %s.feat.sift', tmpCode, tmpCode, tmpCode));

%status = unix('./compute_descriptors.ln -gloh -noangle -i img.ppm -p1 img.ha -o img.ha.gloh');

[feat, n, dim]=loadFeatures(sprintf('%s.feat.sift', tmpCode));
% If there has been scaling to compute the descriptors, remove the scaling.
if scalingDescriptor ~= 1
   feat(3:5,:) = scalingDescriptor^2 * feat(3:5,:);
end

unix(sprintf('rm -f %s.*', tmpCode));

