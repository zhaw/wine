addpath('vlfeat-0.9.20/toolbox');
vl_setup

mask_folder = 'pics/newtest_mask';
folderDatabase = 'pics/newtest_cut';
savefolder='vlsift_newtest_cut';
try
    mkdir(savefolder);
catch
end
R=dir([folderDatabase '/' '*.jpg']);
for n = 1:length(R)
    n
        filename=[folderDatabase '/' R(n).name];
        savename=[savefolder '/' R(n).name(1:end-4) '.mat'];
        img=imread(filename);
        img=im2single(img);
        scale=500/max(size(img));
        img=imresize(img,scale);
        if size(img,3) > 1
            img=rgb2gray(img);
        end

        mask = ones(size(img));
        
        if 0 
            try
                mask = imread([mask_folder '/' R(n).name(1:end-4) '.png']);
                se = strel('disk', 8, 8);
                mask = imerode(mask, se);
                mask = imdilate(mask, se);
                mask = bwconvhull(mask, 'objects');
                mask = imresize(mask,[size(img, 1)*scale, size(img,2)*scale],'method','nearest');
            catch e
                display(e)
                display(filename)
                mask = ones(size(img));
            end
        end
        
        [f1,d1] = vl_sift(img);
        ok = ones(size(f1,2),1);
        for i = 1:size(f1,2)
            if 0 == mask(round(f1(2,i)), round(f1(1,i)))
                ok(i) = 0;
            end
        end
        feature = {f1(:,boolean(ok)), d1(:,boolean(ok))};
        save(savename,'feature');
end
