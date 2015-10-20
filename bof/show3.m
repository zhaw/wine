% To compare two different methods.

addpath('utils/');

a = load('../file_brand_map.mat');
map = a.map;
r1 = load('result');
r1 = r1.result;
r2 = load('result_with_net15');
r2 = r2.result;

s = zeros(4,1);
s1 = 0; % 1 right 2 right
s2 = 0; % 1 right 2 wrong
s3 = 0; % 1 wrong 2 right
s4 = 0; % 1 wrong 2 wrong

for j = 1:936
    if r1{j,2} == r2{j,2}
        continue
    end
    subplot(1,3,1)
    im = imread(['pics/test2_cutted/' r1{j,1} '.jpg']);
    imshow(im);
    subplot(1,3,2)
    im = imread(['pics/train/' r1{j,2} '.jpg']);
    imshow(im)
    subplot(1,3,3)
    im = imread(['pics/train/' r2{j,2} '.jpg']);
    imshow(im)
    pause
end
