bof_train = 'bof_train/';
bof_test = 'bof_test2_autocut/';
sift_train = 'sift_feature_train/';
sift_test = 'sift_feature_test2_autocut/';
try
    mkdir(bof_train);
    mkdir(bof_test);
    mkdir(sift_train);
    mkdir(sift_test);
catch
end

addpath(genpath('vlfeat-0.9.20'));
vl_setup();

test_files = dir('pics/test2_autocut');
train_files = dir(sift_train);
train_bof = zeros(length(train_files)-2, 800);
train_sift = cell(1, length(train_files)-2);
result = cell(length(test_files)-2, 15);
for i = 3:length(train_files)
    x = load([sift_train train_files(i).name]);
    x = x.feature;
    train_sift{i-2} = x;
end
thres = 0.3;

for i = 3:length(test_files)
    i
    name = test_files(i).name;
    im = imread(['pics/test2_autocut/' name]);
    try
        im = rgb2gray(im);
    catch
    end
    im = im2single(im);
    [~,s] = vl_sift(im);
    s = double(s);
    desc_num = size(s,2);
    vv = zeros(length(train_files)-2, 1);
    parfor j = 1:length(train_files)-2
        s1 = train_sift{j};
        if size(s1,2) < desc_num*thres
            vv(j) = 0;
        else
            [matches, score] = vl_ubcmatch(s,s1,2);
            vv(j) = length(score);
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

addpath('..');
score = judge(result, 2000);
save vlsift_range_all result
save ../scores/vlsift score
