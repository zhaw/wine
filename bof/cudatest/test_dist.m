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

tic

k = parallel.gpu.CUDAKernel('sift_dist.ptx', 'sift_dist.cu');
k.ThreadBlockSize = [32, 32];
k.GridSize = [ceil(n1/32), ceil(n2/32)];
result = feval(k, d_r, d_s1, d_s2, n1, n2);
wait(gpuDevice());
toc

r = gather(result);
sum(sum(abs(double(r)-real)))
