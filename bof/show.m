for j = 1:1500
    result{j,1}
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