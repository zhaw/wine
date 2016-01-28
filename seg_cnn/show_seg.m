files = dir('test2');
n = length(files);
for i = 3:n
    file_name = files(i).name;
    file_name = file_name(1:end-4);
    im1 = imread(['test2/' file_name '.jpg']);
    im2 = imread(['test2_mask/' file_name '.png']);
    subplot(1,3,1)
    imshow(im1);
    subplot(1,3,2)
    imshow(im2*255);
    subplot(1,3,3)
    im2 = repmat(im2,1,1,3);
    imshow(im2.*im1);
    pause
end