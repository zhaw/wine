a = load('../file_brand_map.mat');
map = a.map;
right = 0;
for j = 1:1500
    result{j,1}
    if map(result{j,1}) == map(result{j,2})
        right = right+1;
        continue
    end
    subplot(3,5,1)
    im = imread(['pics/test2_cutted/' result{j,1} '.png']);
    imshow(im);
    for k = 1:14
        subplot(3,5,k+1)
        im = imread(['pics/train/' result{j,k+1} '.jpg']);
        imshow(im);
    end
    pause
end
right