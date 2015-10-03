tic
addpath('../Seg_m/segment_guangyi');
R = dir('pics/test2');
mkdir('pics/test2_autocut');
for i = 3:length(R)
    R(i).name
    try
        im = autocut(['pics/test2/' R(i).name]);
    catch
        im = imread(['pics/test2/' R(i).name]);
    end
    imwrite(im, ['pics/test2_autocut/' R(i).name]);
end
toc