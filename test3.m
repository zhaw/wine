function test3
    warning off all
    vlad_dim = [800];
    ranges = [1000];
    n_ransac = [100];
    ransac_range = [100];
    files = dir('bof/pics/newtest');
    for vd = vlad_dim
        global centroids;
        centroids = [];
        global train_vlad;
        train_vlad = [];
        for r = ranges
            for n = n_ransac
                for rr = ransac_range
                    ROOT = '/home/zhaow/Projects/wine/';
                    centroids = load([ROOT 'bof/kmeans_feature/kmeans_feature' num2str(vd) '.mat']);
                    centroids = centroids.centroids';
                    sift_train = [ROOT 'bof/vlsift_newtrain/'];
                    vlad_train = [ROOT 'bof/vlad_newtrain' num2str(vd) '/'];
                    train_files = dir(sift_train);
                    train_vlad = zeros(length(train_files)-2, vd*128);
                    train_sift = cell(1, length(train_files)-2);
                    for i = 3:length(train_files)
                        x = load([vlad_train train_files(i).name]);
                        x = x.f;
                        train_vlad(i-2,:) = x;
                        x = load([sift_train train_files(i).name]);
                        x = x.feature;
                        train_sift{i-2} = x;
                    end
                    parfor i = 3:length(files)
                        if i == 4
                            tic
                        end
                        test2(files(i).name, vd, r, n, rr, centroids, train_vlad, train_sift);
                    end
                    fprintf('%d %d %d %d %f\n', vd, r, n, rr, toc)
                end
            end
        end
    end
end



function test2( im, vd, range, n_ransac, ransac_range, centroids, train_vlad, train_sift)
%MAIN returns the top-n match to the input image.
%   MAIN(im) returns the top-5 match to the input image without autocut.
%   
%   parameters:
%       im:         RGB image.
%       topn:       returns topn matches.
%       autocut:    if use auto cut program.
%   output:
%       result:     List of file names.

    global ROOT;
    im
    ROOT = '/home/zhaow/Projects/wine/';
    addpath([ROOT 'bof']);
    addpath(genpath([ROOT 'bof/vlfeat-0.9.20']));
    im_name = im;
    im = imread(['bof/pics/newtest/' im]);
    im = im2single(im);
    im = imresize(im, [500,NaN]);
    im = rgb2gray(im);
    [f1, d1] = vl_sift(im);
    d1 = double(d1);
    d1 = d1';
    
    vlad_feat = zeros(1,128*vd);
    [d,idxs] = pdist2(centroids, d1, 'euclidean', 'Smallest', 1);
    for j = 1:length(idxs)
        idx = idxs(j);
        vlad_feat(128*idx-127:128*idx) = vlad_feat(128*idx-127:128*idx)+d1(j,:)-centroids(idx,:);
    end
    vlad_feat = vlad_feat/norm(vlad_feat);

    sift_train = [ROOT 'bof/vlsift_newtrain/'];
    vlad_train = [ROOT 'bof/vlad_newtrain' num2str(vd) '/'];
    train_files = dir(sift_train);
    v = zeros(length(train_files)-2, 2);
    v(:,1) = (1:length(train_files)-2)';
    v(:,2) = -train_vlad*vlad_feat';
    v = sortrows(v,2);
    v = v(:,1);
    sorted_train_sift = train_sift(v);
    vv = zeros(range, 1);
    for j = 1:range
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
    target = vv(1,1);
    name = train_files(v(1,1)+2).name;
    mkdir('testresult/');
    ransac_range = min(ransac_range, range); 
    for k = 1:ransac_range
        if -vv(k,2) < current_best
            break
        end
        dtr = sorted_train_sift{vv(k,1)}{2};
        ftr = sorted_train_sift{vv(k,1)}{1};
        d1 = double(d1);
        dtr = double(dtr);
        r = ransac(f1, d1', ftr, dtr, n_ransac);
        if r > current_best
            current_best = r;
            target = vv(k,1);
        end
    end
    name = train_files(v(target,1)+2).name;
    copyfile([ROOT 'bof/pics/newtrain/' name(1:end-4) '.jpg'], ['testresult/' name(1:end-4) '-' im_name]);
end
