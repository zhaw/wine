
pics = dir('pics/newtest/*.jpg');

for i = 1:length(pics)
    im = imread(['pics/newtest/' pics(i).name]);
    try
        im = autocut(im);
    catch
        im = imread(['pics/newtest/' pics(i).name]);
    end
    imwrite(im, ['pics/newtest_cut/' pics(i).name]);
end
