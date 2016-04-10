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
    ROOT = '/home/zhaow/Project/wine/';
    addpath([ROOT 'bof']);
    addpath(genpath([ROOT 'bof/vlfeat-0.9.20']));
    if auto_cut
        im = autocut(im);
    end
    im = im2single(im);
    im = imresize(im, [300,NaN]);
    im = rgb2gray(im);
    [f1, d1] = vl_sift(im);
    d1 = double(d1);
    d1 = d1';
    
    global centroids;
    if isequal(centroids, [])
        centroids = load([ROOT 'bof/kmeans_feature/kmeans_feature200.mat']);
        centroids = centroids.centroids';
    end
    vlad_feat = zeros(1,25600);
    [d,idxs] = pdist2(centroids, d1, 'euclidean', 'Smallest', 1);
    for j = 1:length(idxs)
        idx = idxs(j);
        vlad_feat(128*idx-127:128*idx) = vlad_feat(128*idx-127:128*idx)+d1(j,:)-centroids(idx,:);
    end
    vlad_feat = vlad_feat/norm(vlad_feat);

    sift_train = [ROOT 'bof/vlsift_train/'];
    vlad_train = [ROOT 'bof/vlad_train200/'];
    train_files = dir(sift_train);
    result = cell(1, topn);
    global train_vlad;
    global train_sift;
    if isequal(train_vlad,[]) || isequal(train_sift,[])
        train_vlad = zeros(length(train_files)-2, 25600);
        train_sift = cell(1, length(train_files)-2);
        for i = 3:length(train_files)
            x = load([vlad_train train_files(i).name]);
            x = x.f;
            train_vlad(i-2,:) = x;
            x = load([sift_train train_files(i).name]);
            x = x.feature;
            train_sift{i-2} = x;
        end
        train_vlad = gpuArray(train_vlad);
    end
    range = 50;
    v = zeros(length(train_files)-2, 2);
    v(:,1) = (1:length(train_files)-2)';
    v(:,2) = -gather(train_vlad*vlad_feat');
    v = sortrows(v,2);
    v = v(:,1);
    sorted_train_sift = train_sift(v);
    vv = zeros(range, 1);
    parfor j = 1:range
        s1 = sorted_train_sift{j};
        dtr = s1{2};
        ftr = s1{1};
        dtr = double(dtr);
        [matches, scores] = vl_ubcmatch(d1',dtr);
        vv(j) = length(scores);
    end
    vv = [(1:range)', -vv];
    vv = sortrows(vv, 2);
    current_best = 0;
    target = 0;
    for k = 1:50
        if -vv(k,2) < current_best
            break
        end
        dtr = sorted_train_sift{vv(k,1)}{2};
        ftr = sorted_train_sift{vv(k,1)}{1};
        d1 = double(d1);
        dtr = double(dtr);
        r = ransac(f1, d1', ftr, dtr);
        if r > current_best
            current_best = r;
            target = vv(k,1);
        end
    end
    for k = 1:topn
        name = train_files(v(target,1)+2).name;
        result{k} = name(1:end-4);
    end
    im = imread([ROOT 'bof/pics/train/' result{1} '.jpg']);
end
