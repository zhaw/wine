folderDatabase = 'pics/test2_autocut/';
savefolder='vlsift_feature_test2_autocut/';
try
    mkdir(savefolder);
catch
end
R=dir([folderDatabase '*.jpg']);
addpath(genpath('vlfeat-0.9.20'));
vl_setup();

for n = 1:length(R)
    try
        filename=[folderDatabase R(n).name]
        savename=[savefolder R(n).name(1:end-4) '.mat']
        img=imread(filename);
        try
            img = rgb2gray(img);
        catch
        end
        img = im2single(img);
        [~, feature] = vl_sift(img);
        feature=feature';
        save(savename,'feature')
    catch e
        e
    end
end


folderDatabase = 'pics/train/';
savefolder='vlsift_feature_train/';
try
    mkdir(savefolder);
catch
end
R=dir([folderDatabase '*.jpg']);

for n = 1:length(R)
    try
        filename=[folderDatabase R(n).name]
        savename=[savefolder R(n).name(1:end-4) '.mat']
        img=imread(filename);
        try
            img = rgb2gray(img);
        catch
        end
        img = im2single(img);
        [~, feature] = vl_sift(img);
        feature=feature';
        save(savename,'feature')
    catch e
        e
    end
end
