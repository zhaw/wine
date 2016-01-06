% sift_feature_train = 'sift_feature_train/';
% try
%     mkdir(sift_feature_train);
% catch
% end
% 
% r = dir(sift_feature_train);
% c = 0;
% for i = 3:length(r)
%     x = load([sift_feature_train r(i).name]);
%     x = x.feature;
%     c = c + size(x,2);
% end
% 
% features = zeros(c, 128);
% c = 1;
% for i = 3:length(r)
%     i
%     x = load([sift_feature_train r(i).name]);
%     x = x.feature;
%     left = c;
%     right = c + size(x, 2) - 1;
%     c = c + size(x, 2);
%     features(left:right, :) = x';
% end
% 
% addpath(genpath('vlfeat-0.9.20'));
% vl_setup()
% 
% [centroids, idxs] = vl_kmeans(features', 12800, 'verbose', 'MaxNumIterations', 25);
% [idx, centroids] = kmeans(features, 1600, 'Display', 'iter', 'MaxIter', 15);

% try
%    mkdir('kmeans_feature');
% catch
% end
% save kmeans_feature/kmeans_feature12800.mat centroids

% addpath(genpath('vlfeat-0.9.20'));
centroids = load('kmeans_feature/pca_kmeans_feature6400.mat');
centroids = centroids.centroids;
centroids = centroids';
load pca/coeff;
load pca/mu;
n = size(centroids, 1);

sift_train = 'sift_feature_train/';
sift_test = 'sift_feature_test2_cutted/';

test_files = dir(sift_test);
train_files = dir(sift_train);
train_bof = zeros(length(train_files)-2, n);
result = cell(length(test_files)-2, 2001);
for i = 3:length(train_files)
    i
    x = load([sift_train train_files(i).name]);
    x = x.feature;
    x = x';
    x = (x-ones(size(x,1),1)*mu)*coeff(1:end,1:75);
    f = zeros(1, n);
    [d,idxs] = pdist2(centroids, x, 'euclidean', 'Smallest', 1);
    f(idxs) = f(idxs) + 1;
    train_bof(i-2,:) = f;
end

get_time = 0;
match_time = 0;
for i = 3:length(test_files)
    i
    tic
    name = test_files(i).name;
    x = load(['sift_feature_test2_cutted/' name]);
    x = x.feature;
    x = x';
    x = (x-ones(size(x,1),1)*mu)*coeff(1:end,1:75);
    f = zeros(1, n);
    [d,idxs] = pdist2(centroids, x, 'euclidean', 'Smallest', 1);
    f(idxs) = f(idxs) + 1;
    t = toc;
    get_time = get_time + t;
    tic
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
    t = toc;
    match_time = match_time + t;
end

save result/pca_bof_6400_result result

% time = get_time / (length(test_files)-2);
% save bof12800_get_time time
% time = match_time / (length(test_files)-2);
% save bof12800_match_time time

addpath('..');
score = judge(result, 2000);
save('../scores/pca_bof6400_cutted.mat', 'score');
