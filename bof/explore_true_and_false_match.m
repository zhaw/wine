addpath(genpath('vlfeat-0.9.20'));

centroids = load('kmeans_feature/kmeans_feature.mat');
centroids = centroids.centroids;
x = load('true_false_match');
x = x.data;
truth = x{1};
falsehood = x{2};
tn = size(truth,1);
fn = size(falsehood,1);
t_hist = zeros(800,1);
f_hist = zeros(800,1);
t_scores = [];
f_scores = [];
t_score_nums = [];
f_score_nums = [];
t2_hist = zeros(800,800);
f2_hist = zeros(800,800);
for i = 1:tn
    i
    f2 = truth{i,1};
    f1 = truth{i,2};
    sift1 = load(['sift_feature_train/' f1]);
    sift2 = load(['sift_feature_test2_cutted/' f2]);
    sift1 = sift1.feature;
    sift2 = sift2.feature;
    [d1,idxs1] = pdist2(centroids,sift1','euclidean','Smallest',1);
    [d2,idxs2] = pdist2(centroids,sift2','euclidean','Smallest',1);
    bof1 = zeros(800,1);
    bof2 = zeros(800,1);
    for idx = idxs1
        bof1(idx) = bof1(idx) + 1;
    end
    for idx = idxs2
        bof2(idx) = bof2(idx) + 1;
    end
    bof = min(bof1,bof2);
    t_hist = t_hist+bof;
    [matches,scores] = vl_ubcmatch(sift1, sift2);
    feat1 = idxs1(matches(1,:));
    feat2 = idxs2(matches(2,:));
    t_scores = [t_scores, scores];
    t_score_nums = [t_score_nums, length(scores)];
    t2_hist(sub2ind([800,800],feat1,feat2)) = t2_hist(sub2ind([800,800],feat1,feat2))+1;
end

for i = 1:fn
    i
    f2 = falsehood{i,1};
    f1 = falsehood{i,2};
    sift1 = load(['sift_feature_train/' f1]);
    sift2 = load(['sift_feature_test2_cutted/' f2]);
    sift1 = sift1.feature;
    sift2 = sift2.feature;
    [d1,idxs1] = pdist2(centroids,sift1','euclidean','Smallest',1);
    [d2,idxs2] = pdist2(centroids,sift2','euclidean','Smallest',1);
    bof1 = zeros(800,1);
    bof2 = zeros(800,1);
    for idx = idxs1
        bof1(idx) = bof1(idx) + 1;
    end
    for idx = idxs2
        bof2(idx) = bof2(idx) + 1;
    end
    bof = min(bof1,bof2);
    f_hist = f_hist+bof;
    [matches,scores] = vl_ubcmatch(sift1, sift2);
    f_scores = [f_scores, scores];
    f_score_nums = [f_score_nums, length(scores)];
    feat1 = idxs1(matches(1,:));
    feat2 = idxs2(matches(2,:));
    f2_hist(sub2ind([800,800],feat1,feat2)) = f2_hist(sub2ind([800,800],feat1,feat2))+1;
end

t_h = diag(t2_hist);
f_h = diag(f2_hist);
subplot(3,2,1);
plot(1:800,t_h);
axis([0,800,0,750])
subplot(3,2,2);
plot(1:800,f_h);
axis([0,800,0,750])
subplot(3,2,3);
hist(t_scores);
axis([0,2.5e5,0,4e4])
subplot(3,2,4);
hist(f_scores);
axis([0,2.5e5,0,4e4])
subplot(3,2,5);
hist(t_score_nums);
axis([0,300,0,1200])
subplot(3,2,6);
hist(f_score_nums);
axis([0,300,0,1200])
