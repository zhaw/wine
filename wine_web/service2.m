addpath('/home/zhaow/Projects/wine');
while 1
    fid = fopen('job');
    file = fgets(fid);
    fclose(fid);
    try
        if strcmp(file(1:5), 'nojob')
            continue
        end
    catch
        continue
    end
    im = imread(['media/query/' file]);
    if size(im,1) > 300
        im = imresize(im, [300, NaN]);
    end
    [~,im] = main(im, 1, 1);
    imwrite(im, ['media/result/' file '1'], 'JPEG');
    fid = fopen(['media/result/' file 'txt'], 'w');
    fprintf(fid, '1');
    fclose(fid);
end
