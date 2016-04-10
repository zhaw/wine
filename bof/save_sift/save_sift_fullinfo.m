tic
%%precomputeSIFT    Compute and save SIFT descriptors for all images in database
clear;close all;clc;
addpath('affineFeatures/')
scalingDescriptor = 1; % 1 = no scaling. %sqrt(2);

folderDatabase = '../pics/train';
savefolder='../sift_full_feature_train';
maskfolder='../test2_mask';
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
%        mask=imread([maskfolder '/' R(n).name(1:end-4) '.png']);

%         imwrite(img,saveimgname)
        % get SIFT descriptiors and locations
        % Feat(1:5,:) = location and region cov. matrix,
        % Feat(6:end,:) = SIFT descriptor

        [feat, type] = h_affine(imresize(img, 0.55), scalingDescriptor, 0);
        
        % display detected features
        % cla; displayROI(img, feat, type);
        % colormap(gray(256))
        % title([i n ndx]); drawnow
        
        % concatenated with previous ones:
        % ndx = ndx+1;

        feature = feat;

%        feature = [];
%        for i = 1:size(feat,2)
%            feat(1,i) = round(feat(1,i)/0.55);
%            feat(2,i) = round(feat(2,i)/0.55);
%            if mask(feat(2,i),feat(1,i))
%                feature = [feature,feat(:,i)];
%            end
%        end
        
        %Feat = [Feat feature];
%         class=[n*ones(1,size(feat,2));[1:1:size(feat,2)]];
        %classes = [classes class];
        
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
