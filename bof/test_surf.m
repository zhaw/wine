sift_train = 'sift_feature_train/';
sift_test = 'sift_feature_test2_cutted/';

test_files = dir(sift_test);
train_files = dir(sift_train);
train_surf = cell(1, length(train_files)-2);
result = cell(length(test_files)-2, 2001);
for i = 3:length(train_files)
    im = imread(['pics/train/' train_files(i).name(1:end-4) '.jpg']);
    try
        im = rgb2gray(im);
    catch
    end
    regions = detectHarrisFeatures(im);
    [features, valid_points] = extractFeatures(im, regions, 'SURFSize', 128);
    train_surf{i-2} = features;
end
thres = 0.3;

tic
for i = 3:length(test_files)
    i
    name = test_files(i).name;
    im = imread(['pics/test2_cutted/' name(1:end-4) '.jpg']);
    try
        im = rgb2gray(im);
    catch
    end
    regions = detectHarrisFeatures(im);
    [features, valid_points] = extractFeatures(im, regions, 'SURFSize', 128);
    s = features;
    desc_num = size(s,2);
    vv = zeros(length(train_files)-2, 1);
    parfor j = 1:length(train_files)-2
        s1 = train_surf{j};
        if size(s1,2) < desc_num*thres
            vv(j) = 0;
        else
            matches = matchFeatures(s,s1);
            vv(j) = length(matches);
        end
    end
    vv = [(1:length(train_files)-2)', -vv];
    vv = sortrows(vv, 2);
    result{i-2, 1} = name(1:end-4);
    for k = 1:2000
        name = train_files(vv(k,1)+2).name;
        result{i-2, k+1} = name(1:end-4);
    end
end
time = toc;
time = time / length(test_files)-2;

addpath('..');
score = judge(result, 2000);
save('result/harris_surf_range_all_cutted','result');
save('time/harris_surf_time', 'time');
save('../scores/harris_surf', 'score');
