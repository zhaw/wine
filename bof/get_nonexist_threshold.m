bof_train = 'bof_train/';
bof_test = 'bof_test2_autocut/';
sift_train = 'sift_feature_train/';
sift_test = 'sift_feature_test2_autocut/';
net = load('net2');
net = net.net2;

addpath(genpath('vlfeat-0.9.20'));

tfm = load('true_false_match');
tfm = tfm.data;
ts = [];
fs = [];
for i = 1:size(tfm{1},1)
    i
    s1 = load([sift_test tfm{1}{i,1}]);
    s1 = s1.feature;
    s2 = load([sift_train tfm{1}{i,2}]);
    s2 = s2.feature;
    [matches, ~] = vl_ubcmatch(s1,s2,2);
    feat1 = s1(:,matches(1,:));
    feat2 = s2(:,matches(2,:));
    feat = [feat1;feat2];
    net_score = net(feat);
    score = sum(net_score)*1.5-0.5*length(net_score);
    ts = [ts,score];
end
for i = 1:size(tfm{2},1)
    i
    s1 = load([sift_test tfm{2}{i,1}]);
    s1 = s1.feature;
    s2 = load([sift_train tfm{2}{i,2}]);
    s2 = s2.feature;
    [matches, ~] = vl_ubcmatch(s1,s2,2);
    feat1 = s1(:,matches(1,:));
    feat2 = s2(:,matches(2,:));
    feat = [feat1;feat2];
    net_score = net(feat);
    score = sum(net_score)*1.5-0.5*length(net_score);
    fs = [fs,score];
end
