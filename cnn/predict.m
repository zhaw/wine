addpath(genpath('~/caffe/matlab'));
caffe.set_mode_cpu();
caffe.set_device(0);
net_model = 'caffe_script/imagenet_deploy.prototxt';
net_weights = 'snapshot/imagenet_iter_140000.caffemodel';
phase = 'test';
net = caffe.Net(net_model, net_weights, phase);

pics_mean = caffe.io.read_mean('wine_mean.binaryproto');

test_pics = dir('pics/test2_autocut');
train_pics = dir('pics/train');
result = cell(length(test_pics)-2, 2001);
numbers = 1:16749;
numbers = numbers';

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
    im = single(im);
    im = imresize(im, [300,300], 'bilinear');
    im = im - pics_mean;
    batch = zeros(300, 300, 3, 1, 'single');
    batch(:,:,1:3,1) = im;
    input_data = {batch};
    score = net.forward(input_data);
    feature = score{1};
    ff = sort(feature);
    ff(end-5:end)
%    if ff(end) < 0.9
%        continue
%    end
    x = sortrows([numbers,-feature], 2);
    result{i-2, 1} = test_pics(i).name(1:end-4);
    for j = 1:2000
        result{i-2, j+1} = train_pics(x(j,1)+2).name(1:end-4);
    end
end
