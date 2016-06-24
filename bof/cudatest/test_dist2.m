s1 = load('vlsift_newtest/20639400');
s2 = load('vlsift_newtest/20686156');
s1 = s1.feature;
s1 = s1{2};
s2 = s2.feature;
s2 = s2{2};
d_s1 = gpuArray(s1);
d_s2 = gpuArray(s2);
n1 = size(s1, 2);
n2 = size(s2, 2);
r = zeros(n1,n2);
d_r = gpuArray(int32(r));
real = pdist2(s1', s2');
real = real.*real;

k = parallel.gpu.CUDAKernel('sift_dist2.ptx', 'sift_dist2.cu');
k.ThreadBlockSize = 128;
k.GridSize = [n1, n2];
tic
result = feval(k, d_r, d_s1, d_s2, n1, n2);

r = gather(result);
toc
sum(sum(abs(double(r)-real)))
