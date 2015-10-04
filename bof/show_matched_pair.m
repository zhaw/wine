function show_matched_pair( f2,f1 )
% Show the SIFT descriptor of two matched pictures.
%   f1: file name in the training set.
%   f2: file name in the test set.
% TBD

train_dir = 'pics/train/';
test_dir = 'pics/test2_cutted/';
im1 = imread([train_dir f1 '.jpg']);
im2 = imread([test_dir f2 '.jpg']);
im1_sift = load(['sift_feature_train/' f1 '.mat']);
im2_sift = load(['sift_feature_test2_cutted/' f2 '.mat']);
im1_sift = im1_sift.feature;
im2_sift = im2_sift.feature;


end

