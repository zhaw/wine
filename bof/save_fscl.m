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

n = size(features,1);
epochs = n*10;
chosen = randi(n, [1,epochs]);
lr = 0.02;
centroids = normrnd(128, 50, [6400, 128]);
freq_weight = ones(6400, 1);

for epoch = 1:epochs
    if mod(epoch, 1000) == 0
        epoch
    end
    chosen_feature = features(chosen(epoch),:);
    dist = pdist2(centroids, chosen_feature, 'euclidean');
    dist = dist.*freq_weight;
    [~,idx] = min(dist);
    freq_weight(idx) = freq_weight(idx)+1;
    centroids(idx,:) = centroids(idx,:)+lr*(chosen_feature-centroids(idx,:));
end

save kmeans_feature/fscl.mat centroids
