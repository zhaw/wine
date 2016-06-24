sift_feature_train = 'vlsift_newtrain_cut/';
sift_feature_test = 'vlsift_newtest_cut/';
bof_feature_train = 'vlad_newtrain_cut800/';
bof_feature_test = 'vlad_newtest_cut800/';

try
    mkdir(bof_feature_train);
    mkdir(bof_feature_test);
catch
end

centroids = load('kmeans_feature/kmeans_feature800.mat');
centroids = centroids.centroids';
n = size(centroids, 1);

r = dir(sift_feature_test);

for i = 3:length(r)
    i
    name = r(i).name;
    x = load([sift_feature_test r(i).name]);
    x = x.feature;
    x = x{2};
    x = x';
    x = double(x);
    f = zeros(1,n*128);
    [d,idxs] = pdist2(centroids,x,'euclidean','Smallest',1);
    length(idxs)
    for j = 1:length(idxs)
        idx = idxs(j);
        f(128*idx-127:128*idx) = f(128*idx-127:128*idx)+x(j,:)-centroids(idx,:);
    end
    f = f/norm(f);
    save([bof_feature_test name(1:end-4) '.mat'], 'f');
end



r = dir(sift_feature_train);

for i = 3:length(r)
    i
    name = r(i).name;
    x = load([sift_feature_train r(i).name]);
    x = x.feature;
    x = x{2};
    x = x';
    x = double(x);
    f = zeros(1,n*128);
    [d,idxs] = pdist2(centroids,x,'euclidean','Smallest',1);
    length(idxs)
    for j = 1:length(idxs)
        idx = idxs(j);
        f(128*idx-127:128*idx) = f(128*idx-127:128*idx)+x(j,:)-centroids(idx,:);
    end
    f = f/norm(f);
    save([bof_feature_train name(1:end-4) '.mat'], 'f');
end
