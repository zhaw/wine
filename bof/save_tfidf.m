sift_feature_train = 'sift_feature_train/';
sift_feature_test = 'sift_feature_test2_cutted/';
tfidf_feature_train = 'tfidf_train6400/';
tfidf_feature_test = 'tfidf_test2_cutted6400/';

try
    mkdir(sift_feature_train);
    mkdir(sift_feature_test);
    mkdir(tfidf_feature_train);
    mkdir(tfidf_feature_test);
catch
end

centroids = load('kmeans_feature/kmeans_feature6400.mat');
centroids = centroids.centroids';
n = size(centroids, 1);

r = dir(sift_feature_train);

bof_feature = cell(1, length(r)-2);
total_appearence = zeros(1, 6400);

parfor i = 3:length(r)
    i
    name = r(i).name;
    x = load([sift_feature_train r(i).name]);
    x = x.feature;
    f = zeros(1,n);
    [d,idxs] = pdist2(centroids,x','euclidean','Smallest',1);
    f(idxs) = f(idxs)+1;
    bof_feature{i-2} = f;
end

for i = 3:length(r)
    i
    f = bof_feature{i-2};
    f(f>1) = 1;
    total_appearence = total_appearence+f;
end


idf = log((length(r)-2)./total_appearence);

for i = 3:length(r)
    i
    name = r(i).name;
    f = bof_feature{i-2};
    f = f.*idf;
    save([tfidf_feature_train name(1:end-4) '.mat'], 'f');
end
save('kmeans_feature/idf_terms.mat', 'idf');
