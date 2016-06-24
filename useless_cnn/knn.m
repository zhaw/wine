train_dir = 'cnn_feature_train/';
test_dir = 'cnn_feature_test2_autocut/';

files_train = dir(train_dir);
files_test = dir(test_dir);
files_train = files_train(3:end);
files_test = files_test(3:end);
n_train = length(files_train);
n_test = length(files_test);

feature_train = zeros(n_train, 50); 
feature_test = zeros(n_test, 50);

result = cell(n_test, 500);

parfor i = 1:n_train
    x = load([train_dir files_train(i).name]);
    x = x.feature;
    feature_train(i,:) = x;
end

parfor i = 1:n_test
    x = load([test_dir files_test(i).name]);
    x = x.feature;
    feature_test(i,:) = x;
end

%feature_mean = mean(feature_train);
%feature_std = std(feature_train);
%feature_train = (feature_train-repmat(feature_mean,size(feature_train,1),1))...
%./ repmat(feature_std,size(feature_train,1),1);
%feature_test = (feature_test-repmat(feature_mean,size(feature_test,1),1))...
%./ repmat(feature_std,size(feature_test,1),1);

disp('starting KNN search');


for i = 1:n_test
    i
    [d, idx] = pdist2(feature_train, feature_test(i,:), 'euclidean', 'Smallest', 500);
    result{i,1} = files_test(i).name(1:end-4);
    for j = 1:500
        result{i,j+1} = files_train(idx(j)).name(1:end-4);
    end
end

save result result
