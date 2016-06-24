function test2
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
                    test3(files(3).name, vd, r, n, rr);
                    for i = 3:length(files)
                        test3(files(i).name, vd, r, n, rr);
                    end
                    fprintf('%d %d %d %d\n', vd, r, n, rr)
                end
            end
        end
    end
end



function test3( im, vd, range, n_ransac, ransac_range )
%MAIN returns the top-n match to the input image.
%   MAIN(im) returns the top-5 match to the input image without autocut.
%   
%   parameters:
%       im:         RGB image.
%       topn:       returns topn matches.
%       autocut:    if use auto cut program.
%   output:
%       result:     List of file names.

    tic
    global ROOT;
    ROOT = '/home/zhaow/Projects/wine/';
    addpath([ROOT 'bof']);
    addpath(genpath([ROOT 'bof/vlfeat-0.9.20']));
    im_name = im;
%    im = imread(['bof/pics/newtest/' im]);
%    im = im2single(im);
%    im = imresize(im, [500,NaN]);
%    im = rgb2gray(im);
%    [f1, d1] = vl_sift(im);
%    d1 = double(d1);
%    d1 = d1';
    name = im(1:end-4);
    vlad_feat = load(['bof/vlad_newtest_cut800/' name]);
    vlad_feat = vlad_feat.f;
    sift_feat = load(['bof/vlsift_newtest_cut/' name]);
    sift_feat = sift_feat.feature;
    d1 = sift_feat{2};
    f1 = sift_feat{1};
     
    
    global centroids;
    if isequal(centroids, [])
        centroids = load([ROOT 'bof/kmeans_feature/kmeans_feature' num2str(vd) '.mat']);
        centroids = centroids.centroids';
    end
%    vlad_feat = zeros(1,128*vd);
%    [d,idxs] = pdist2(centroids, d1, 'euclidean', 'Smallest', 1);
%    for j = 1:length(idxs)
%        idx = idxs(j);
%        vlad_feat(128*idx-127:128*idx) = vlad_feat(128*idx-127:128*idx)+d1(j,:)-centroids(idx,:);
%    end
%    vlad_feat = vlad_feat/norm(vlad_feat);

    sift_train = [ROOT 'bof/vlsift_newtrain_cut/'];
    vlad_train = [ROOT 'bof/vlad_newtrain_cut' num2str(vd) '/'];
    train_files = dir(sift_train);
    global train_vlad;
    global train_sift;
    if isequal(train_vlad,[]) || isequal(train_sift,[])
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
    end
    toc
    tic
    v = zeros(length(train_files)-2, 2);
    v(:,1) = (1:length(train_files)-2)';
    v(:,2) = -train_vlad*vlad_feat';
    v = sortrows(v,2);
    v = v(:,1);
    toc
    tic
    sorted_train_sift = train_sift(v);
    vv = zeros(range, 1);
    parfor j = 1:range
        s1 = sorted_train_sift{j};
        dtr = s1{2};
        ftr = s1{1};
        [matches, scores] = vl_ubcmatch(d1,dtr);
        vv(j) = length(scores);
    end
    toc
    tic
    vv = [(1:range)', -vv];
    vv = sortrows(vv, 2);
    current_best = 0;
    target = vv(1,1);
    name = train_files(v(1,1)+2).name;
    mkdir('testresult5/');
    mkdir('testresult5/score');
    ransac_range = min(ransac_range, range); 
    for k = 1:ransac_range
        if -vv(k,2) < current_best
            break
        end
        dtr = sorted_train_sift{vv(k,1)}{2};
        ftr = sorted_train_sift{vv(k,1)}{1};
        d1 = double(d1);
        dtr = double(dtr);
        r = ransac(f1, d1, ftr, dtr, n_ransac);
        if r > current_best
            current_best = r;
            target = vv(k,1);
        end
    end
    toc
    fprintf('---------\n');
    name = train_files(v(target,1)+2).name;
    fid = fopen(['testresult5/score/' im_name(1:end-4) '.txt'], 'w');
    fprintf(fid, '%d %d', -vv(1,2), current_best);
    fclose(fid);
    copyfile([ROOT 'bof/pics/newtrain/' name(1:end-4) '.jpg'], ['testresult5/' name(1:end-4) '-' im_name]);
end
