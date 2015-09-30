a = load('../file_brand_map.mat');
map = a.map;
result = load('result');
result = result.result;
right = 0;
for j = 1:1500
    map(result{j,1})
    map(result{j,2})
    if is_same_brand(map(result{j,1}), map(result{j,2}))
        right = right+1;
        continue
    end
    pause
    continue
    subplot(1,2,1)
    im = imread(['pics/test2_cutted/' result{j,1} '.png']);
    imshow(im);
    for k = 1:1
        subplot(1,2,k+1)
        im = imread(['pics/train/' result{j,k+1} '.jpg']);
        imshow(im);
    end
    pause
end
right