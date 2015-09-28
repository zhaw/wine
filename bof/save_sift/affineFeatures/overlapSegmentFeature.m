function overlap = overlapSegmentFeature(seg, feat)
%overlapSegmentFeature     Overlap between ROI and a segmentation mask
% If feature center is not inside the mask/object, overlap is set to zero.

subsample = 4;

[nrows ncols nobjects] = size(seg);
[x,y] = meshgrid(1:subsample:ncols, 1:subsample:nrows);
x = x(:); y = y(:);

seg = seg(1:subsample:nrows, 1:subsample:ncols, :);
areaObjects = sum(sum(seg==1,1),2);

[nrows ncols nc] = size(seg);
nb = size(feat,2);
%seg = double(seg);

xc = round((feat(1,:)+1)/subsample);
yc = round((feat(2,:)+1)/subsample);
xc = min(ncols,max(1,xc));
yc = min(nrows,max(1,yc));

S = sum(seg,3);
label = S(sub2ind([nrows ncols], yc, xc))>0;
seg = logical(seg);

overlap = zeros(nb,nobjects);
th = log(.5);
for c = 1:nb
    if label(c)==1
        Mi = [feat(3,c) feat(4,c); feat(4,c) feat(5,c)];
        xi = feat(1,c)+1;
        yi = feat(2,c)+1;

        %G = exp(-sum([x-xi y-yi] .* (Mi*[x-xi y-yi]')',2));
        G = -sum([x-xi y-yi] .* (Mi*[x-xi y-yi]')',2);

        %G = reshape(G, [nrows ncols]);
        G = G - max(G);
        %G = double(G>.5); G = G / sum(G);

        G = double(G>th);
        areaFeature = sum(G);
        G = G / areaFeature;

        yi = fix(max(1,min(yi/subsample, nrows)));
        xi = fix(max(1,min(xi/subsample, ncols)));

        for m = 1:nobjects
            if seg(yi, xi, m)==0 | areaFeature>areaObjects(m)
                overlap(c,m) = 0; % if the ROI center is not on top of the object then overlap is set to zero.
            else
                overlap(c,m) = sum(G(seg(:,:,m)));
            end
        end
    end
end
