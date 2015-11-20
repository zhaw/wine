function [score] = judge(result, topn)
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
score = right ./ (right+wrong);
score = score(2:end);
end
