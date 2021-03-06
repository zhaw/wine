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

c = c-1;

load pca/coeff;
load pca/mu;

features = (features-ones(c,1)*mu)*coeff(1:end,1:75);

addpath(genpath('vlfeat-0.9.20'));
vl_setup()

[centroids, idxs] = vl_kmeans(features', 6400, 'verbose', 'algorithm', 'LLOYD', 'MaxNumIterations', 25, 'NumTrees', 20);
% [idx, centroids] = kmeans(features, 1600, 'Display', 'iter', 'MaxIter', 15);

try
    mkdir('kmeans_feature');
catch
end
save kmeans_feature/pca_kmeans_feature6400.mat centroids
