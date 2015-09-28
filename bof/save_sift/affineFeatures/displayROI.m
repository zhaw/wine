
function displayROI(imf, feat, type, colors, weights, Hax)
%displayROI    Overlay regions of interest on image as colored ellipses

nb = size(feat,2);  % number of features
if nargin < 3 || isempty(type)
  type = ones(nb,1);
end
if nargin < 4 || isempty(colors)
  colors = colormap(hsv(max(type)));
end
if nargin < 5 || isempty(weights)
  weights = ones(nb,1);
end
if nargin < 6 || isempty(Hax)
  Hax = gca;
end
Ncolors = size(colors,1);

image(imf,'parent',Hax); axis(Hax,'image'); axis(Hax,'off');
if size(imf,3)==1; colormap(Hax,gray(256)); end

dx = 1; dy = 1;

hold(Hax,'on');
%[foo, n] = sort(weights);
for c1=1:nb
  %c1 = n(c);
  w = weights(c1);
  drawellipse([feat(3,c1) feat(4,c1); feat(4,c1) feat(5,c1)], ...
    feat(1,c1)+dx, feat(2,c1)+dy, ...
    w*colors(mod(type(c1)-1, Ncolors)+1,:) + (1-w)*[.6 .6 .6], w, Hax);
end
hold(Hax,'off');
title(Hax,nb);
%drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function drawellipse(Mi,i,j,col,w,Hax)
[v e]=eig(Mi);

l1=1/sqrt(e(1));
l2=1/sqrt(e(4));

alpha=atan2(v(4),v(3));
s=1;
t = 0:pi/8:2*pi;
y=s*(l2*sin(t));
x=s*(l1*cos(t));

xbar=x*cos(alpha) + y*sin(alpha);
ybar=y*cos(alpha) - x*sin(alpha);

%colw = w*[0 0 0] + (1-w)*col;
colw=[0 0 0];
Lw = w*3+(1-w)*1;
%plot(Hax, ybar+i, xbar+j, 'Color', colw, 'LineWidth', Lw);
%plot(Hax, ybar+i, xbar+j, 'Color', col, 'LineWidth', 1);
%line(ybar+i, xbar+j, 'Color', colw, 'LineWidth', Lw, 'parent', Hax);
line(ybar+i, xbar+j, 'Color', col, 'LineWidth', 2.5, 'parent', Hax);

