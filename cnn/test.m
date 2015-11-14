function [score] = test(im1, im2)
% Extract feature using caffe.

im1 = imread('pics/test2_cutted/101.jpg');
addpath(genpath('~/caffe/matlab'));
caffe.set_mode_gpu();
caffe.set_device(0);
net_model = 'caffe_script/wine_pairwise_extract3.prototxt';
net_weights = 'caffe_script/wine_pairwise_iter_1000000.caffemodel';
phase = 'test';
net = caffe.Net(net_model, net_weights, phase);

td = dir('pics/train');
s = zeros(length(td)-2,1);
im1 = im1(:, :, [3,2,1]);
im1 = permute(im1, [2,1,3]);
im1 = im2single(im1);
im1 = imresize(im1, [250,250], 'bilinear');
for i = 3:length(td)
    i
    batch = zeros(250,250,6,1,'single');
    im2 = imread(['pics/train/' td(i).name]);
    if ndims(im2) == 2
        [n1, n2] = size(im2);
        imrgb = zeros([n1,n2,3]);
        for j = 1:3
            imrgb(:,:,j) = im2;
        end
        im2 = imrgb;
    end
    batch(:,:,1:3,1) = im1;
    im2 = im2(:, :, [3,2,1]);
    im2 = permute(im2, [2,1,3]);
    im2 = im2single(im2);
    im2 = imresize(im2, [250,250], 'bilinear');
    batch(:,:,4:6,1) = im2;
    input_data = {batch,1};
    score = net.forward(input_data);
    s(i-2) = score{1};
end
score = s;
end
