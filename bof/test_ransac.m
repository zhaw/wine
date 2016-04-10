bof_train = 'bof_train/';
bof_test = 'bof_test2_cutted/';
sift_train = 'sift_full_feature_train/';
sift_test = 'sift_full_feature_test2_autocut_cnn/';
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
train_sift = cell(1, length(train_files)-2);
result = cell(length(test_files)-2, 2);
for i = 3:length(train_files)
    x = load([sift_train train_files(i).name]);
    x = x.feature;
    train_sift{i-2} = x;
end

tic
for i = 3:length(test_files)
    i
    name = test_files(i).name;
    s = load([sift_test name]);
    s = s.feature;
    desc_num = size(s,2);
    vv = zeros(length(train_files)-2, 1);
    current_best = 4;
    for j = 1:length(train_files)-2
        s1 = train_sift{j};
        [matches, scores] = vl_ubcmatch(s1(6:end,:),s(6:end,:));
        numMatches = size(matches,2);
        if numMatches < current_best
            score = 0;
        else
            X1 = s1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
            X2 = s(1:2,matches(2,:)) ; X2(3,:) = 1 ;
            clear H score ok ;
            for t = 1:100
              % estimate homograpyh
              subset = vl_colsubset(1:numMatches, 4) ;
              A = [] ;
              for i = subset
                A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
              end
              [U,S,V] = svd(A) ;
              H{t} = reshape(V(:,9),3,3) ;

              % score homography
              X2_ = H{t} * X1 ;
              du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
              dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
              ok{t} = (du.*du + dv.*dv) < 6*6 ;
              score(t) = sum(ok{t}) ;
            end
            [score, best] = max(score) ;
            H = H{best} ;
            ok = ok{best} ;
        end
        vv(j) = score;
        if score > current_best
            current_best = score;
            current_best
            [train_files(j+2).name, name]
        end
    end
    vv = [(1:length(train_files)-2)', -vv];
    vv = sortrows(vv, 2);
    result{i-2, 1} = name(1:end-4);
    name
    train_files(vv(1,1)+2).name
    for k = 1:1
        name = train_files(vv(k,1)+2).name;
        result{i-2, k+1} = name(1:end-4);
    end
end
time = toc;
time = time / length(test_files)-2;

addpath('..');
score = judge(result, 2000);
save('result/ransac_autocut_cnn','result');
save('time/ransac_autocut_cnn_time', 'time');
save('../scores/ransac_autocut_cnn', 'score');
