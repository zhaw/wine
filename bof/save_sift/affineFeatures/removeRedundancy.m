function [j, feat] = removeRedundancy(feat, th)
%removeRedundancy    Remove redundant interest regions with significant overlap

nb = size(feat,2);
tmp = zeros(nb,1);

j = 1;

parfor c = 2:nb
D = min(distKL(feat(:,c), feat(:,j), th));
tmp(c-1) = D;
end

for c = 2:nb
if tmp(c-1)>th
j = [j c];
end
end

if nargout == 2
feat = feat(:,j);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D = distKL(feat1, feat2, th)
n1 = size(feat1,2);
n2 = size(feat2,2);

D = zeros(n1,n2);

for c1 = 1:n1
invSigma1 = [feat1(3,c1) feat1(4,c1); feat1(4,c1) feat1(5,c1)];
mu1 = [feat1(1,c1) feat1(2,c1)];
for c2 = 1:n2
invSigma2 = [feat2(3,c2) feat2(4,c2); feat2(4,c2) feat2(5,c2)];
mu2 = [feat2(1,c2) feat2(2,c2)];
D(c1,c2) = symKLgaussian(mu1, invSigma1, mu2, invSigma2, th);
end
end





function sKL = symKLgaussian(mu1, invSigma1, mu2, invSigma2, th)
% Symmetric KL-divergence between two gaussians
% 
% To speed up, we can use the threshold to compute only the full distance when it is needed.

m = (mu1 - mu2);
sKL = m*(invSigma1+invSigma2)*m';

% if distance is already larger than th then do not bother to compute second term
if sKL<th
Sigma1 = inv(invSigma1);
Sigma2 = inv(invSigma2);
sKL = trace(invSigma2*Sigma1 + invSigma1*Sigma2) - 4 + sKL;
end







