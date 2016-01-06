function [result, im] = main( im, topn, auto_cut, vargin )
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
        auto_cut = 0;
    end
    
    global ROOT;
    ROOT = '/home/zhaow/Projects/wine/';
    addpath([ROOT 'bof']);
    if auto_cut
        im = autocut(im);
    end
    
    addpath(genpath([ROOT 'bof/save_sift']));
    [sift_feat, type] = h_affine(imresize(im, [300,NaN]), 1, 1, [ROOT 'bof/save_sift/']);
    sift_feat = sift_feat(6:end,:);
    
    global centroids;
    if isequal(centroids, [])
        centroids = load([ROOT 'bof/kmeans_feature/kmeans_feature6400.mat']);
        centroids = centroids.centroids';
    end
    bof_feat = zeros(1,6400);
    [d,idxs] = pdist2(centroids, sift_feat', 'euclidean', 'Smallest', 1);
    bof_feat(idxs) = bof_feat(idxs)+1;

    addpath(genpath([ROOT 'bof/vlfeat-0.9.20']));
    sift_train = [ROOT 'bof/sift_feature_train/'];
    bof_train = [ROOT 'bof/bof_train6400/'];
    global net;
    if isequal(net, [])
        net = load([ROOT 'bof/net2']);
        net = net.net2;
    end
    train_files = dir(sift_train);
    result = cell(1, topn);
    global train_bof;
    global train_sift;
    global train_sift_length;
    if isequal(train_bof,[]) || isequal(train_sift,[])
        train_bof = zeros(length(train_files)-2, 6400);
        train_sift = cell(1, length(train_files)-2);
        train_sift_length = zeros(length(train_files)-2, 1);
        for i = 3:length(train_files)
            x = load([bof_train train_files(i).name]);
            x = x.f;
            train_bof(i-2,:) = x;
            x = load([sift_train train_files(i).name]);
            x = x.feature;
            train_sift{i-2} = x;
            train_sift_length(i-2) = size(x,2);
        end
    end
    range = 250;
    thres = 0.3;
    v = zeros(length(train_files)-2, 1);
    desc_num = size(sift_feat,2);
    parfor j = 3:length(train_files)
        if train_sift_length(j-2) < desc_num*thres
            v(j-2) = 0;
        else
            f1 = train_bof(j-2,:);
            v(j-2) = dot(bof_feat, f1) / (norm(bof_feat)*norm(f1));
        end
    end
    v = [(1:length(train_files)-2)', -v];
    v = sortrows(v,2);
    v = v(:,1);
    sorted_train_sift = train_sift(v);
    vv = zeros(range, 1);
    parfor j = 1:range
        s1 = sorted_train_sift{j};
        [matches, ~] = vl_ubcmatch(sift_feat, s1, 2);
        feat1 = sift_feat(:, matches(1,:));
        feat2 = s1(:, matches(2,:));
        feat = [feat1;feat2];
        score = net(feat);
        vv(j) = sum(score)*1.5-0.5*length(score);
    end
    vv = [(1:range)', -vv];
    vv = sortrows(vv, 2);
    for k = 1:topn
        name = train_files(v(vv(k,1),1)+2).name;
        result{k} = name(1:end-4);
    end
    im = imread([ROOT 'bof/pics/train/' result{1} '.jpg']);
end
