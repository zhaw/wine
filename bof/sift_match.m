function score = sift_match(test_sift)

global d_x1
global c
global train_sift
global idxs
if isequal(d_x1, [])
    train_sift = dir('vlsift_newtrain_m/*.mat');
    c = 0;
    for i = 1:length(train_sift)
        f = load(['vlsift_newtrain_m/' train_sift(i).name]);
        f = f.feature;
        f = f{2};
        c = c + size(f,2);
    end

    train_sift_array = zeros(128, c); 
    c = 1;
    idxs = zeros(2,length(train_sift));
    for i = 1:length(train_sift)
        idxs(1,i) = c; 
        f = load(['vlsift_newtrain_m/' train_sift(i).name]);
        f = f.feature;
        f = f{2};
        train_sift_array(:,c:c+size(f,2)-1) = f;
        c = c + size(f,2);
        idxs(2,i) = c-1;
    end
    c = c - 1;

    train_sift_array = uint8(train_sift_array);

    d_x1 = gpuArray(train_sift_array);
end

d_x2 = gpuArray(uint8(test_sift));
d_r = gpuArray(int32(zeros(c,1)));
k = parallel.gpu.CUDAKernel('sift_match.ptx', 'sift_match.cu');
k.ThreadBlockSize = 512;
k.GridSize = ceil(idxs(2,1000)/512)+1;

tic
result = feval(k, d_r, d_x2, d_x1(:,1:idxs(2,1000)), size(d_x2,2), size(d_x1,2), 2.25);
wait(gpuDevice())
toc
result = gather(result);
score = zeros(length(train_sift), 1);
for i = 1:length(train_sift)
    score(i) = sum(result(idxs(1,i):idxs(2,i))>-1);
end
end

