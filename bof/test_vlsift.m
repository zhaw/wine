sift_train = 'vlsift_train/';
sift_test = 'vlsift_test2_autocut/';

addpath('vlfeat-0.9.20/toolbox');
vl_setup;

test_files = dir(sift_test);
train_files = dir(sift_train);
train_sift = cell(1, length(train_files)-2);
result = cell(length(test_files)-2, 2);
for i = 3:length(train_files)
    x = load([sift_train train_files(i).name]);
    x = x.feature;
    train_sift{i-2} = x;
end

for i = 3:length(test_files)
    i
    name = test_files(i).name;
    s = load([sift_test name]);
    s = s.feature;
    dte = s{2};
    fte = s{1};
    vv = zeros(length(train_files)-2, 1);
    parfor j = 1:length(train_files)-2
        dtr = train_sift{j}{2};
        ftr = train_sift{j}{1};
        if size(ftr,2) < 50
            vv(j) = 0;
        else
            [matches, scores] = vl_ubcmatch(dte,dtr);
            vv(j) = length(scores);
        end
    end
    vv = [(1:length(train_files)-2)', -vv];
    vv = sortrows(vv, 2);
    current_best = 0;
    target = 0;
    for k = 1:20000
        if -vv(k,2) < current_best
            break
        end
        dtr = train_sift{vv(k,1)}{2};
        ftr = train_sift{vv(k,1)}{1};
        r = ransac(fte,dte,ftr,dtr);
        if r > current_best
            current_best = r;
            target = vv(k,1);
        end
    end
    name
    result{i-2,1} = name(1:end-4);
    name = train_files(target+2).name;
    name
    result{i-2,2} = name(1:end-4);
end
save('result/vlsift_ransac_autocut','result');
