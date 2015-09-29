
for i =1 :10
    e = strcat('test',num2str(i),'.png');
    imrgb = imread(e);
    im = zgy_bottleimage_cut(e);
    figure(i);
    subplot(1,2,1);imshow(imrgb);
    subplot(1,2,2);imshow(im);
end
