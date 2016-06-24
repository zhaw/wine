function [valid_feature, feature_score_truth, feature_score_falsehood] = find_feature
% Decide which of 4096 features are good feature and hence should be kept.

data = load('true_false_match');
data = data.data;

feature_score_truth = zeros(1,4096);
feature_score_falsehood = zeros(1,4096);

truth_n = length(data{1});
falsehood_n = length(data{2});

for i = 1:truth_n
    i
    f1 = csvread(['pics/train_overfeat/' data{1}{i,2} '.csv']);
    f2 = csvread(['pics/test2_cutted_overfeat/' data{1}{i,1} '.csv']);
    feature_score_truth = feature_score_truth + abs(f1-f2);
end
feature_score_truth = feature_score_truth / truth_n;

for i = 1:falsehood_n
    i
    f1 = csvread(['pics/train_overfeat/' data{2}{i,2} '.csv']);
    f2 = csvread(['pics/test2_cutted_overfeat/' data{2}{i,1} '.csv']);
    feature_score_falsehood = feature_score_falsehood + abs(f1-f2);
end
feature_score_falsehood = feature_score_falsehood / falsehood_n;

valid_feature = find(feature_score_falsehood>feature_score_truth);
end
