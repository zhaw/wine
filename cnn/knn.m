train_dir = 'pics/train_overfeat/';
test_dir = 'pics/test2_cutted_overfeat/';

files_train = dir([train_dir '*.csv']);
files_test = dir([test_dir '*.csv']);
files_train = files_train(3:end);
files_test = files_test(3:end);
n_train = length(files_train);
n_test = length(files_test);

feature_train = zeros(n_train, 4096); 
feature_test = zeros(n_test, 4096);

result = {};

parfor i = 1:n_train
    x = csvread([train_dir files_train(i).name]);
    feature_train(i,:) = x;
end

parfor i = 1:n_test
    x = csvread([test_dir files_test(i).name]);
    feature_test(i,:) = x;
end

disp('starting KNN search');

[idx,d] = knnsearch(feature_train, feature_test, 'k', 19);

for i = 1:n_test
    result{i,1} = files_test(i).name(1:end-4);
    for j = 1:19
        result{i,j+1} = files_train(idx(i,j)).name(1:end-4);
    end
end

save result result
