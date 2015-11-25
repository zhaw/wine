sift_feature_train = 'sift_feature_train/';
try
    mkdir(sift_feature_train);
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

addpath(genpath('vlfeat-0.9.20'));
vl_setup()

% [centroids, idxs] = vl_kmeans(features', 12800, 'verbose', 'MaxNumIterations', 25);
% [idx, centroids] = kmeans(features, 1600, 'Display', 'iter', 'MaxIter', 15);

% try
%    mkdir('kmeans_feature');
% catch
% end
% save kmeans_feature/kmeans_feature12800.mat centroids

addpath(genpath('vlfeat-0.9.20'));
centroids = load('kmeans_feature/kmeans_feature12800.mat');
centroids = centroids.centroids;
centroids = centroids';
n = size(centroids, 1);

sift_train = 'sift_feature_train/';
sift_test = 'sift_feature_test2_autocut/';

test_files = dir(sift_test);
train_files = dir(sift_train);
train_bof = zeros(length(train_files)-2, n);
result = cell(length(test_files)-2, 2001);
tic
parfor i = 3:length(train_files)
    i
    x = load([sift_train train_files(i).name]);
    x = x.feature;
    f = zeros(1, n);
    [d,idxs] = pdist2(centroids, x', 'euclidean', 'Smallest', 1);
    for idx = idxs
        f(idx) = f(idx) + 1;
    end
    train_bof(i-2,:) = f;
end

for i = 3:length(test_files)
    i
    name = test_files(i).name;
    x = load(['sift_feature_test2_autocut/' name]);
    x = x.feature;
    f = zeros(1, n);
    [d,idxs] = pdist2(centroids, x', 'euclidean', 'Smallest', 1);
    for idx = idxs
        f(idx) = f(idx) + 1;
    end
    v = zeros(length(train_files)-2,1);
    parfor j = 3:length(train_files)
        f1 = train_bof(j-2,:);
        v(j-2) = dot(f,f1)/(norm(f)*norm(f1));%sum(min(f,f1));%
    end
    v = [(1:length(train_files)-2)',-v];
    v = sortrows(v,2);
    v = v(:,1);
    result{i-2,1} = name(1:end-4);
    for k = 1:2000
        name = train_files(v(k,1)+2).name;
        result{i-2, k+1} = name(1:end-4);
    end
end

addpath('..');
score = judge(result, 2000);
save('../scores/bof12800_autocut.mat', 'score');
