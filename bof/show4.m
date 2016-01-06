addpath('utils/');

r1 = load('pure_sift_range_all_cutted');
r1 = r1.result;
truth = load('../truth_for_judge');
truth = truth.truth;
c = 0;

for j = 1:936
    r = truth(result{j,1});
    if length(r) == 0
        c = c+1;
        continue
    end
    subplot(1,2,1)
    im = imread(['pics/test2_cutted/' r1{j,1} '.jpg']);
    imshow(im);
    subplot(1,2,2)
    im = imread(['pics/train/' r1{j,2} '.jpg']);
    imshow(im)
    pause
end
