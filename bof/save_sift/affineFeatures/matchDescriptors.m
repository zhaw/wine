function [j, d] = matchDescriptors(feat1, feat2)
%matchDescriptors     Compute index of closets matching SIFT descriptors
%   j is the index to feat2 indicating the closest match to feat1

n1 = size(feat1, 2);
n2 = size(feat2, 2);

d = zeros(n1,1);
j = zeros(n1,1);

s1 = sum(feat1(6:end,:).^2);
s2 = sum(feat2(6:end,:).^2);
for n = 1:n1
    %D = distMat(feat1(6:end,n1)', feat2(6:end,:)');
    D = s1(n) + s2 - 2*feat1(6:end,n)'*feat2(6:end,:);
    [d(n) j(n)]= min(D);
end
