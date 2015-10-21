% To judge matching precision.

result = load('result');
result = result.result;
for j = 1:length(result)
    subplot(1,2,1)
    im = imread(['pics/test2_cutted/' result{j,1}(1:end-4) '.jpg']);
    imshow(im);
    subplot(1,2,2)
    im = imread(['pics/train/' result{j,2}(1:end-4) '.jpg']);
    imshow(im);
    pause
end