sift_feature_train = 'sift_feature_train/';
sift_feature_test = 'sift_feature_test2_cutted/';
bof_feature_train = 'bof_train/';
bof_feature_test = 'bof_test2_cutted/';

try
    mkdir(sift_feature_train);
    mkdir(sift_feature_test);
    mkdir(bof_feature_train);
    mkdir(bof_feature_test);
catch
end

centroids = load('kmeans_feature/kmeans_feature.mat');
centroids = centroids.centroids;

r = dir(sift_feature_test);

for i = 3:length(r)
    i
    name = r(i).name;
    x = load([sift_feature_test r(i).name]);
    x = x.feature;
    f = zeros(1,800);
    [d,idxs] = pdist2(centroids,x','euclidean','Smallest',1);
    for idx = idxs
        f(idx) = f(idx)+1;
    end
    save([bof_feature_test name(1:end-4) '.mat'], 'f');
end

% 
% 
% r = dir(sift_feature_train);
% 
% for i = 3:length(r)
%     i
%     name = r(i).name;
%     x = load([sift_feature_train r(i).name]);
%     x = x.feature;
%     f = zeros(1,800);
%     [d,idxs] = pdist2(centroids,x','euclidean','Smallest',1);
%     for idx = idxs
%         f(idx) = f(idx)+1;
%     end
%     save([bof_feature_train name(1:end-4) '.mat'], 'f');
% end