function feat = edgeROI(img)
%edgeROI    Use linked Canny edges to define regions of interest
%
%Requires Peter D. Kovesi's toolbox:    
%  MATLAB and Octave Functions for Computer Vision and Image Processing.
%  School of Computer Science & Software Engineering,
%  The University of Western Australia.   
%  Available from:   http://www.csse.uwa.edu.au/~pk/research/matlabfns/

% Extract edges using Canny edge detector:
edgeim = edge(mean(double(img),3), 'canny', [0.05 .1], 1);

% Link edges into segments:
[edgelist, labelededgeim] = edgelink(edgeim, 10);
    
% Fit line segments to the edgelists with the following parameters:
tol = 2;         % Line segments are fitted with maximum deviation from original edge of 2 pixels.
angtol = 0.05;   % Segments differing in angle by less than 0.05 radians
linkrad = 2;     % and end points within 2 pixels will be merged.
[seglist, nedgelist] = lineseg(edgelist, tol, angtol, linkrad);

% Transform edge list into regions
nb = size(seglist,1);
feat = zeros(5,nb);
for i = 1:nb
    x = (seglist(i,1) + seglist(i,3))/2;
    y = (seglist(i,2) + seglist(i,4))/2;
    v1 = [seglist(i,3)-seglist(i,1) seglist(i,4)-seglist(i,2)]/2;
    e1 = sqrt(sum(v1.^2));
    v1 = v1 / e1;
    v2 = [v1(2) -v1(1)];
    e2 = e1/20;
    V = [v1; v2];
    %V = [1 0; 0 1];
    S = V' * inv(diag([e1 e2])) * V / 100;
    
    feat(1,i) = x;
    feat(2,i) = y;
    feat(3,i) = S(1,1);
    feat(4,i) = S(1,2);
    feat(5,i) = S(2,2);
    i
end

if nargout == 0
    figure
    subplot(121)
    drawseg(seglist, gcf, 2); axis off
    subplot(122)
    displayROI(img, feat);
end


