function [orientation, scale, aspectRatio, X, Y] = getROIproperties(feat)
%getROIproperties    Extract geometric properties of region of interest (ROI)

nb = size(feat,2);
dx = 1; dy = 1;

orientation = zeros(nb,1);
scale = zeros(nb,1);
aspectRatio = zeros(nb,1);
X = zeros(nb,1);
Y = zeros(nb,1);
for c1=1:nb,%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Si = [feat(3,c1) feat(4,c1); feat(4,c1) feat(5,c1) ];
    mi =  [feat(1,c1)+dx, feat(2,c1)+dy];

    [v e]=eig(Si);

    l1=1/sqrt(e(1));
    l2=1/sqrt(e(4));

    alpha=-atan2(v(3),v(4));

    orientation(c1) = alpha;
    scale(c1) = l1;
    aspectRatio(c1) = l1/l2;
    X(c1) = mi(1);
    Y(c1) = mi(2);
end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout == 0
    x = linspace(-pi, pi, 50); x = x(1:end-1);
    figure
    [h,x]=hist(orientation, x); h = h/max(h);
    polar([x x(1)],[h h(1)])
    hold on
    j = find(aspectRatio>3);
    [h,x]=hist(orientation(j), x); h = h/max(h);
    polar([x x(1)],[h h(1)], 'r')
end
