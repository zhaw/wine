train_files = 'vlad_train100/';
test_files = 'vlad_test2_cutted100/';

r = dir(train_files);
vlad_train = zeros(length(r)-2, 128*100);
for i = 3:length(r)
    i
    name = r(i).name;
    f = load([train_files name]);
    f = f.f;
    vlad_train(i-2,:) = f;
end

r = dir(test_files);
vlad_test = zeros(length(r)-2, 128*100);
for i = 3:length(r)
    i
    name = r(i).name;
    f = load([test_files name]);
    f = f.f;
    vlad_test(i-2,:) = f;
end

%vlad_trainG = gpuArray(vlad_train);
%vlad_testG = gpuArray(vlad_test);

r = dir(test_files);
r1 = dir(train_files);
result = cell(length(r)-2, 8001);

n = size(vlad_train,1);

for i = 3:length(r)
    i
    name = r(i).name;
    v = zeros(n,2);
    v(:,1) = (1:n)';
 %   v(:,2) = -gather(vlad_trainG(:,:)*vlad_testG(i-2,:)');
    v(:,2) = -(vlad_train*vlad_test(i-2,:)');
    v = sortrows(v,2);
    result{i-2,1} = name(1:end-4);
    for k = 1:8000
        name = r1(v(k,1)+2).name;
        result{i-2,k+1} = name(1:end-4);
    end
end

save result/vlad100 result
addpath('..')
score = judge(result, 8000)
save ../scores/vlad100 score
