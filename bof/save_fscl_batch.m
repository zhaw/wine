try

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

epochs = 500;
lr = 0.5;
centroids_old = normrnd(128, 50, [6400, 128]);
idxs_old = zeros(1,c-1);
freq_weight = zeros(6400, 1);

parfor i = 1:c-1
    [~, idx] = pdist2(centroids_old, features(i,:), 'euclidean', 'smallest', 1);
    idxs_old(i) = idx;
end

result = {};
for epoch = 1:epochs
    tic
    ['epoch ' num2str(epoch)]
    for i = 1:6400
        freq_weight(i) = sum(idxs_old==i);
    end
    freq_weight(freq_weight==0) = 1;
    freq_weight = power(freq_weight, 0.05);
    for i = 1:c-1
        dist = pdist2(centroids_old, features(i,:), 'euclidean');
        dist = dist .* freq_weight;
        [~, idx] = sort(dist);
        idxs_old(i) = idx(1);
    end
    for i = 1:6400
        samples = features(idxs_old==i, :);
        if size(samples, 1) == 0
            continue
        end
        centroids_old(i,:) = centroids_old(i,:) + lr*(mean(samples,1)-centroids_old(i,:));
    end
    result{epoch} = centroids_old;
    save kmeans_feature/fscl6400.mat centroids_old
    save kmeans_feature/fscl6400_history.mat result
    toc
end


catch e
    e
end
