% function [feature] = extract_feature(im)
% Extract feature using caffe.

mkdir('cnn_feature_train');
mkdir('cnn_feature_test2_autocut');
addpath(genpath('~/caffe/matlab'));
caffe.set_mode_gpu();
caffe.set_device(0);
net_model = 'caffe_script/wine_pairwise_extract.prototxt';
net_weights = 'caffe_script/wine_pairwise_iter_1000000.caffemodel';
phase = 'test';
net = caffe.Net(net_model, net_weights, phase);

train_pics = dir('pics/train');
for i = 3:length(train_pics)
    i
    im = imread(['pics/train/' train_pics(i).name]);
    if ndims(im) == 2
        [n1, n2] = size(im);
        imrgb = zeros([n1,n2,3]);
        for j = 1:3
            imrgb(:,:,j) = im;
        end
        im = imrgb;
    end
    im = im(:, :, [3,2,1]);
    im = permute(im, [2,1,3]);
    im = im2single(im);
    im = imresize(im, [250,250], 'bilinear');
    batch = zeros(250, 250, 3, 1, 'single');
    batch(:,:,1:3,1) = im;
    input_data = {batch};
    score = net.forward(input_data);
    feature = score{1};
    save(['cnn_feature_train/' train_pics(i).name(1:end-4)], 'feature');
end

test_pics = dir('pics/test2_autocut');
for i = 3:length(test_pics)
    i
    im = imread(['pics/test2_autocut/' test_pics(i).name]);
    if ndims(im) == 2
        [n1, n2] = size(im);
        imrgb = zeros([n1,n2,3]);
        for j = 1:3
            imrgb(:,:,j) = im;
        end
        im = imrgb;
    end
    im = im(:, :, [3,2,1]);
    im = permute(im, [2,1,3]);
    im = im2single(im);
    im = imresize(im, [250,250], 'bilinear');
    batch = zeros(250, 250, 3, 1, 'single');
    batch(:,:,1:3,1) = im;
    input_data = {batch};
    score = net.forward(input_data);
    feature = score{1};
    save(['cnn_feature_test2_autocut/' test_pics(i).name(1:end-4)],'feature');
end
