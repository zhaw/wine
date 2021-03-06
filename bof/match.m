bof_train = 'bof_train6400/';
bof_test = 'bof_test2_cutted6400/';
sift_train = 'sift_feature_train/';
sift_test = 'sift_feature_test2_cutted/';
net = load('net2');
net = net.net2;
try
    mkdir(bof_train);
    mkdir(bof_test);
    mkdir(sift_train);
    mkdir(sift_test);
catch
end

addpath(genpath('vlfeat-0.9.20'));

test_files = dir(sift_test);
train_files = dir(sift_train);
train_bof = zeros(length(train_files)-2, 6400);
train_sift = cell(1, length(train_files)-2);
result = cell(length(test_files)-2, 15);
tic
for i = 3:length(train_files)
    x = load([bof_train train_files(i).name]);
    x = x.f;
    train_bof(i-2,:) = x;
    x = load([sift_train train_files(i).name]);
    x = x.feature;
    train_sift{i-2} = x;
end
range = 250;
thres = 0.3;

scores = [];

for i = 3:length(test_files)
    i
    name = test_files(i).name;
    x = load([bof_test name]);
    f = x.f;
    v = zeros(range,1);
    parfor j = 3:length(train_files)
        f1 = train_bof(j-2,:);
        v(j-2) = dot(f,f1)/(norm(f)*norm(f1));%sum(min(f,f1));%
    end
    v = [(1:length(train_files)-2)',-v];
    v = sortrows(v,2);
    v = v(:,1);
    sorted_train_sift = train_sift(v);
    s = load([sift_test name]);
    s = s.feature;
    desc_num = size(s,2);
    vv = zeros(range, 1);
    parfor j = 1:range
        s1 = sorted_train_sift{j};
        if size(s1,2) < desc_num*thres
            vv(j) = 0;
        else
            [matches, score] = vl_ubcmatch(s,s1,2);
            feat1 = s(:,matches(1,:));
            feat2 = s1(:,matches(2,:));
            feat = [feat1;feat2];
            score = net(feat);
            vv(j) = sum(score)*1.5-0.5*length(score);
        end
    end
    vv = [(1:range)', -vv];
    vv = sortrows(vv, 2);
    s1 = sorted_train_sift{vv(1,1)};
    [~, score] = vl_ubcmatch(s,s1,2);
    scores = [scores, score]; 
    result{i-2, 1} = name(1:end-4);
    for k = 1:14
        name = train_files(v(vv(k,1),1)+2).name;
        result{i-2, k+1} = name(1:end-4);
    end
end
toc
