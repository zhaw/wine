function [ ims ] = expand_image( im )

im = im2single(im);
if ndims(im) == 2
    [n1, n2] = size(im);
    im_origin = zeros(n1,n2,3,'single');
    im_origin(:,:,1) = im;
    im_origin(:,:,2) = im;
    im_origin(:,:,3) = im;
else
    [n1,n2,~] = size(im);
    im_origin = im;
end

% Shrink top.
p1 = [1,1;
    1,n1;
    n2,1;
    n2,n1];
p2 = [fix(n2/9),1;
    1,n1;
    n2-ceil(n2/9),1;
    n2,n1];
tform = maketform('projective',p1,p2);
im_shrink_top = imtransform(im_origin, tform);

p1 = [1,1;
    1,n1;
    n2,1;
    n2,n1];
p2 = [fix(n2/6),1;
    1,n1;
    n2-ceil(n2/6),1;
    n2,n1];
tform = maketform('projective',p1,p2);
im_shrink_top2 = imtransform(im_origin, tform);

% Shrink bottom.
p1 = [1,1;...
    1,n1;...
    n2,1;...
    n2,n1];
p2 = [1,1;...
    fix(n2/9),n1;...
    n2,1;...
    n2-fix(n2/9),n1];
tform = maketform('projective',p1,p2);
im_shrink_bottom = imtransform(im_origin, tform);

p1 = [1,1;...
    1,n1;...
    n2,1;...
    n2,n1];
p2 = [1,1;...
    fix(n2/6),n1;...
    n2,1;...
    n2-fix(n2/6),n1];
tform = maketform('projective',p1,p2);
im_shrink_bottom2 = imtransform(im_origin, tform);

% Cut left, right, top, bottom.
im_cut_left = im_origin(fix(n1/10):end,:,:);
im_cut_right = im_origin(1:end-fix(n1/10),:,:);
im_cut_top = im_origin(:,fix(n2/10):end,:);
im_cut_bottom = im_origin(:,1:n2-fix(n2/10),:);

% Blur.
gf = fspecial('gaussian', [5 5], 2);
im_gaussian = imfilter(im_origin, gf, 'replicate');

% Dim and Bright.
im_bright = im_origin*1.5;
im_dim = im_origin*0.7;

% Rotate.
im_rotate_left = imrotate(im_origin, 10);
im_rotate_right = imrotate(im_origin, -10);

ims = {im_origin, im_shrink_top, im_shrink_bottom,...
    im_shrink_top2, im_shrink_bottom2,...
    im_cut_left, im_cut_right, im_cut_top, im_cut_bottom,...
    im_gaussian, im_bright, im_dim, im_rotate_left, im_rotate_right};

for i = 1:14
    ims{i} = imresize(ims{i}, [300,300]);
end

end

