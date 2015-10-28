function [result] = main( im, topn, autocut, vargin )
%MAIN returns the top-n match to the input image.
%   MAIN(im) returns the top-5 match to the input image without autocut.
%   
%   parameters:
%       im:         RGB image.
%       topn:       returns topn matches.
%       autocut:    if use auto cut program.
%   output:
%       result:     List of file names.

    if nargin == 1
        topn = 5;
        autocut = 0;
    end
    
    global ROOT;
    ROOT = '/home/zhaow/Projects/wine/';
    addpath([ROOT 'bof']);
    if autocut
        im = autocut(im);
    end
    
    addpath(genpath([ROOT 'bof/save_sift']));
    [sift_feat, type] = h_affine(imresize(im, [300,NaN]), 1);
    sift_feat = sift_feat(6:end,:);
    
    global centroids;
    if isequal(centroids, [])
        centroids = load([ROOT 'bof/kmeans_feature/kmeans_feature.mat']);
        centroids = centroids.centroids;
    end
    bof_feat = zeros(1,800);
    [d,idxs] = pdist2(centroids, sift_feat', 'euclidean', 'Smallest', 1);
    for idx = idxs
        bof_feat(idx) = bof_feat(idx)+1;
    end

    addpath(genpath([ROOT 'bof/vlfeat-0.9.20']));
    sift_train = [ROOT 'bof/sift_feature_train/'];
    bof_train = [ROOT 'bof/bof_train/'];
    global net;
    if isequal(net, [])
        net = load([ROOT 'bof/net2']);
        net = net.net2;
    end
    train_files = dir(sift_train);
    result = cell(1, topn);
    global train_bof;
    global train_sift;
    if isequal(train_bof,[]) || isequal(train_sift,[])
        train_bof = zeros(length(train_files)-2, 800);
        train_sift = cell(1, length(train_files)-2);
        for i = 3:length(train_files)
            x = load([bof_train train_files(i).name]);
            x = x.f;
            train_bof(i-2,:) = x;
            x = load([sift_train train_files(i).name]);
            x = x.feature;
            train_sift{i-2} = x;
        end
    end
    range = 1000;
    thres = 0.3;
    v = zeros(length(train_files)-2, 1);
    parfor j = 3:length(train_files)
        f1 = train_bof(j-2,:);
        v(j-2) = dot(bof_feat, f1) / (norm(bof_feat)*norm(f1));
    end
    v = [(1:length(train_files)-2)', -v];
    v = sortrows(v,2);
    v = v(:,1);
    sorted_train_sift = train_sift(v);
    desc_num = size(sift_feat,2);
    vv = zeros(range, 1);
    parfor j = 1:range
        s1 = sorted_train_sift{j};
        if size(s1,2) < desc_num*thres
            vv(j) = 0;
        else
            [matches, ~] = vl_ubcmatch(sift_feat, s1, 2);
            feat1 = sift_feat(:, matches(1,:));
            feat2 = s1(:, matches(2,:));
            feat = [feat1;feat2];
            score = net(feat);
            vv(j) = sum(score)*1.5-0.5*length(score);
        end
    end
    vv = [(1:range)', -vv];
    vv = sortrows(vv, 2);
    for k = 1:topn
        name = train_files(v(vv(k,1),1)+2).name;
        result{k} = name(1:end-4);
    end
end
