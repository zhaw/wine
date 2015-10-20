% To judge autocut precision.

addpath('utils/');

a = load('../file_brand_map.mat');
map = a.map;
result = load('result_autocut');
result = result.result;
for j = 1:1500
%     subplot(2,3,1)
%     im = imread(['pics/test2_cutted/' result{j,1} '.jpg']);
%     imshow(im);
    subplot(2,3,2)
    im = imread(['pics/test2/' result{j,1} '.jpg']);
    imshow(im)
    subplot(2,3,3)
    im = imread(['pics/test2_autocut/' result{j,1} '.jpg']);
    imshow(im)
    for k = 1:3
        subplot(2,3,k+3)
        im = imread(['pics/train/' result{j,k+1} '.jpg']);
        imshow(im)
    end
    pause
end
