x = load('true_false_match');
matches = x.data;
truth = matches{1};
falsehood = matches{2};
tn = size(truth,1);
fn = size(falsehood,1);
x = [];
y = [];

for i = 1:tn
    i
    f2 = truth{i,1};
    f1 = truth{i,2};
    sift1 = load(['sift_feature_train/' f1]);
    sift2 = load(['sift_feature_test2_cutted/' f2]);
    sift1 = sift1.feature;
    sift2 = sift2.feature;
    [matches,scores] = vl_ubcmatch(sift1, sift2);
    feat1 = sift1(:,matches(1,:));
    feat2 = sift2(:,matches(2,:));
    x = [x;feat1',feat2'];
    y = [y;ones(size(matches,2),1)];
end

for i = 1:fn
    i
    f2 = falsehood{i,1};
    f1 = falsehood{i,2};
    sift1 = load(['sift_feature_train/' f1]);
    sift2 = load(['sift_feature_test2_cutted/' f2]);
    sift1 = sift1.feature;
    sift2 = sift2.feature;
    [matches,scores] = vl_ubcmatch(sift1, sift2);
    feat1 = sift1(:,matches(1,:));
    feat2 = sift2(:,matches(2,:));
    x = [x;feat1',feat2'];
    y = [y;zeros(size(matches,2),1)];
end
data = {x,y};
save true_false_sift_pairs data