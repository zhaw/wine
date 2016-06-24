function [r, d] = ransac(f1,d1,f2,d2, n)

[matches, scores] = vl_ubcmatch(d1,d2);
numMatches = size(matches,2);

X1 = f1(1:2, matches(1,:)); X1(3,:) = 1;
X2 = f2(1:2, matches(2,:)); X2(3,:) = 1;
TEST = [0,0,100,100,0;0,100,100,0,0];
TEST(3,:) = 1;
clear H score ok H;
score = zeros(n,1);
for t = 1:n
    subset = vl_colsubset(1:numMatches, 4);
    A = [];
    for i = subset
        A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i))));
    end
    [U,S,V] = svd(A);
    ht = reshape(V(:,9),3,3);
    X2_ = ht * X1;
    du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:);
    dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:);
    okt = (du.*du+dv.*dv) < 36;
    score(t) = sum(okt);
    H{t} = ht;
end
[r, best] = max(score);
test_result = H{best} * TEST;
test_result(1,:) = test_result(1,:) ./ test_result(3,:);
test_result(2,:) = test_result(2,:) ./ test_result(3,:);
s = polyarea(test_result(1,:), test_result(2,:));
if s < 400 || s > 250000
    r = 0;
end

d = s;

end

