% To judge matching precision.

result = load('result');
result = result.result;
for i = 1:length(result)
    subplot(4,5,1)
    im = imread(['pics/test2_cutted/' result{i,1} '.jpg']);
    imshow(im);
    for j = 1:19
        subplot(4,5,j+1)
        im = imread(['pics/train/' result{i,j+1} '.jpg']);
        imshow(im);
    end
    pause
end
