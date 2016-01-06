centroids = load('kmeans_feature/kmeans_feature6400.mat');
centroids = centroids.centroids;
centroids = centroids';
n = size(centroids, 1);

sift_train = 'sift_feature_train/';
tfidf_train = 'tfidf_train6400/';
sift_test = 'sift_feature_test2_cutted/';

test_files = dir(sift_test);
train_files = dir(sift_train);
train_tfidf = zeros(length(train_files)-2, n);
idf_term = load('kmeans_feature/idf_terms.mat');
idf_term = idf_term.idf;

result = cell(length(test_files)-2, 2001);
parfor i = 3:length(train_files)
    i
    x = load([tfidf_train train_files(i).name]);
    x = x.f;
    train_tfidf(i-2,:) = x;
end

for i = 3:length(test_files)
    i
    name = test_files(i).name;
    x = load(['sift_feature_test2_cutted/' name]);
    x = x.feature;
    f = zeros(1, n);
    [d,idxs] = pdist2(centroids, x', 'euclidean', 'Smallest', 1);
    f(idxs) = f(idxs) + 1;
    f = f.*idf_term;
%    f = f/sum(f);
    v = zeros(length(train_files)-2,1);
    parfor j = 3:length(train_files)
        f1 = train_tfidf(j-2,:);
        v(j-2) = dot(f,f1)/(norm(f)*norm(f1));
        % v(j-2) = sum(min(f,f1));
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

save result/tfidf_6400_result result

addpath('..');
score = judge(result, 2000);
save('../scores/tfidf6400_cutted.mat', 'score');

exit(1)
