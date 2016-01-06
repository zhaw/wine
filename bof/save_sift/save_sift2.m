tic
%%precomputeSIFT    Compute and save SIFT descriptors for all images in database
clear;close all;clc;
addpath('affineFeatures/')
scalingDescriptor = 1; % 1 = no scaling. %sqrt(2);

folderDatabase = '../pics/test2_cutted';
savefolder='../sift_agg_feature_test2_cutted';
% saveimgfolder='database/DR_test_part2'
try
    mkdir(savefolder);
catch
end
% mkdir(saveimgfolder);
R=dir([folderDatabase '/' '*.jpg']);
% ndx = 0; 
Feat=[]; 
% classes=[];

tic
for n = 1:length(R)
    
%    for i = 1:3
    try
        filename=[folderDatabase '/' R(n).name]
        savename=[savefolder '/' R(n).name(1:end-4) '.mat']
%         saveimgname=[saveimgfolder '/' num2str(n+129) '.jpg']
        img=imread(filename);
%         imwrite(img,saveimgname)
        % get SIFT descriptiors and locations
        % Feat(1:5,:) = location and region cov. matrix,
        % Feat(6:end,:) = SIFT descriptor
        
        img = imresize(img, [400, NaN]);
        n1 = size(img,1);
        n2 = size(img,2);
        imgs  = cell(1,4);
        try
            imgs{1} = img(1:ceil(n1/2), 1:ceil(n2/2), :);
            imgs{2} = img(ceil(n1/2):end, 1:ceil(n2/2), :);
            imgs{3} = img(1:ceil(n1/2), ceil(n2/2):end, :);
            imgs{4} = img(ceil(n1/2):end, ceil(n2/2):end, :);
        catch
            imgs{1} = img(1:ceil(n1/2), 1:ceil(n2/2));
            imgs{2} = img(ceil(n1/2):end, 1:ceil(n2/2));
            imgs{3} = img(1:ceil(n1/2), ceil(n2/2):end);
            imgs{4} = img(ceil(n1/2):end, ceil(n2/2):end);
        end
        features = cell(1,4);
        parfor j = 1:4
            [feat, type] = h_affine(imgs{j}, scalingDescriptor);
            features{j} = feat(6:end,:);
        end
        feature = [features{1},features{2},features{3},features{4}];
        save(savename,'feature')%,'class')
        class=[];
        feature=[];
%    end
    catch e
        e
    end
end
% save database/DR_traindata Feat classes
time = toc;
time = time/length(R);
% save ../sift_get_time time

%%  resize data to n*100 
% load database/testdata1
% 
% position=find(classes(2,:)==1);
% a=position-1;b=classes(2,end);
% c=[a(2:end) 166054];
% num=classes(2,c);
% 
% feat=[];label=[];
% index=cumsum(num);k=1;
% for i=index
% feat=[feat Feat(:,k+2:i)];
% label=[label classes(1,k+2:i)];
% k=i;
% end
% features=feat(:,4:end);
% labels=label(4:end);
% 
% Targetlabel=zeros(length(labels),250);
% for j=1:length(labels)
%     Targetlabel(j,labels(j))=1;
%     VisualFeat(j,:)=features(:,j)'./max(features(:,j));
%     j
% end
% 
% save database/batchtestdata1 Targetlabel VisualFeat
    
toc
