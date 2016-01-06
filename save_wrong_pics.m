function save_wrong_pics(result, topn)
% Return the topn precision of a result.

topn = topn+1;
truth = load('truth_for_judge');
truth = truth.truth;
right = zeros(1, topn);
wrong = zeros(1, topn);
score = zeros(1, topn);
ok = zeros(1, size(result,1));

for i = 1:size(result,1)
    try
        r = truth(result{i,1});
        if length(r) == 0
            ok(i) = -1;
        end
    catch
        ok(i) = -1;
    end
end

right(1) = 0;
wrong(1) = numel(find(ok==0));

for topn = 2:topn
    topn
    to_judge = find(ok==0);
    round_right = 0;
    for i = to_judge
        his_truth = truth(result{i,1});
        for j = 1:length(his_truth)
            if strcmp(his_truth{j}, result{i, topn})
                round_right = round_right + 1;
                ok(i) = 1;
                break
            end
        end
    end
    right(topn) = right(topn-1) + round_right;
    wrong(topn) = wrong(topn-1) - round_right;
end

idxs = find(ok==0);
for idx = idxs
    name = result{idx,1};
    dir_name = name;
    mkdir(['bof/analyse/' dir_name]);
    copyfile(['bof/pics/test2_cutted/' name '.jpg'], ['bof/analyse/' dir_name '/test.jpg']);
    copyfile(['bof/sift_feature_test2_cutted/' name '.mat'], ['bof/analyse/' dir_name '/test_sift.mat']);
    copyfile(['bof/bof_test2_cutted6400/' name '.mat'], ['bof/analyse/' dir_name '/test_bof.mat']);
    name = result{idx,2};
    copyfile(['bof/pics/train/' name '.jpg'], ['bof/analyse/' dir_name '/wrong.jpg']);
    copyfile(['bof/sift_feature_train/' name '.mat'], ['bof/analyse/' dir_name '/wrong_sift.mat']);
    copyfile(['bof/bof_train6400/' name '.mat'], ['bof/analyse/' dir_name '/wrong_bof.mat']);
    his_truth = truth(result{idx,1});
    for j = 1:length(his_truth)
        name = his_truth{j};
        copyfile(['bof/pics/train/' name '.jpg'],...
            ['bof/analyse/' dir_name '/right' num2str(j) '.jpg']);
        copyfile(['bof/sift_feature_train/' name '.mat'],...
            ['bof/analyse/' dir_name '/right_sift' num2str(j) '.mat']);
        copyfile(['bof/bof_train6400/' name '.mat'],...
            ['bof/analyse/' dir_name '/right_bof' num2str(j) '.mat']);
    end
end
