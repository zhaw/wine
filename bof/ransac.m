function r = ransac(f1,d1,f2,d2)

[matches, scores] = vl_ubcmatch(d1,d2);
numMatches = size(matches,2);

X1 = f1(1:2, matches(1,:)); X1(3,:) = 1;
X2 = f2(1:2, matches(2,:)); X2(3,:) = 1;
clear H score ok x23 deth;
score = zeros(100,1);
parfor t = 1:100
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
    x23(t) = mean(abs(X2_(3,:)));
    deth(t) = abs(det(ht(1:2,1:2)));
end
[r, best] = max(score);
x23 = x23(best);
deth = deth(best);
if deth / x23^2 < 1e-2 || deth / x23^2 > 1e2
    r = 0;
end

end

