addpath('vlfeat-0.9.20/toolbox');
vl_setup

mask_folder = 'pics/newtest_mask';
folderDatabase = 'pics/newtest';
savefolder='pics/newtest_dlcut';
try
    mkdir(savefolder);
catch
end
R=dir([folderDatabase '/' '*.jpg']);
for n = 1:length(R)
        filename=[folderDatabase '/' R(n).name];
        savename=[savefolder '/' R(n).name];
        img=imread(filename);

        try
            mask = imread([mask_folder '/' R(n).name(1:end-4) '.png']);
            se = strel('disk', 8, 8);
            mask = imerode(mask, se);
            mask = imdilate(mask, se);
            mask = bwconvhull(mask, 'objects');
            mask = uint8(mask);
            if length(size(img)) == 3
                for i = 1:3
                    img(:,:,i) = img(:,:,i).*mask;
                end
            else
                img = img.*mask;
            end
        catch e
            display(e)
            display(filename)
            mask = ones(size(img,1), size(img,2));
        end
        imwrite(img, savename);
        
end
