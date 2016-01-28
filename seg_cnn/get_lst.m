files = dir('train_boundary/');
n = length(files);
fid = fopen('train.lst', 'w');
for i = 3:n
    try
        i
        file_name = files(i).name;
        file_name = file_name(1:end-4);
        b = load(['train_boundary/' file_name]);
        b = b.boundary_points;
        x = b(:,1);
        y = b(:,2);
        im = imread(['second_train/' file_name '.jpg']);
        s = size(im);
        bw = poly2mask(x,y,s(1),s(2));
        bw = uint8(bw);
        imwrite(bw, ['mask/' file_name '.png']);
        fprintf(fid, '%d\t%s\t%s\n', i, ['second_train/' file_name '.jpg'], ['mask/' file_name '.png']);
    catch
        file_name
    end
end
fclose(fid);