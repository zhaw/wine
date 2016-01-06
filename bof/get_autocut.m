addpath('../Seg_m/segment_guangyi');
R = dir('pics/test2');
mkdir('pics/test2_autocut');
tic
for i = 3:length(R)
    R(i).name
    im = imread(['pics/test2/' R(i).name]);
    try
        im = autocut(im);
    catch
        im = imread(['pics/test2/' R(i).name]);
    end
%    imwrite(im, ['pics/test2_autocut/' R(i).name]);
end
time = toc;
time = time / (length(R)-2);
save autocut_get_time time
