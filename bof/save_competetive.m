sift_feature_train = 'sift_feature_train/';
sift_feature_test = 'sift_feature_test1/';
try
    mkdir(sift_feature_train);
    mkdir(sift_feature_test);
catch
end

r = dir(sift_feature_train);
c = 0;
for i = 3:length(r)
    x = load([sift_feature_train r(i).name]);
    x = x.feature;
    c = c + size(x,2);
end

features = zeros(c, 128);
c = 1;
for i = 3:length(r)
    i
    x = load([sift_feature_train r(i).name]);
    x = x.feature;
    left = c;
    right = c + size(x, 2) - 1;
    c = c + size(x, 2);
    features(left:right, :) = x';
end

features = features';

net = competlayer(200, .1);
net = configure(net, features);
net.trainParam.epochs = 50;
net = train(net, features);
centroids = net.IW{1};

try
    mkdir('kmeans_feature');
catch
end
save kmeans_feature/competetive200.mat centroids
