function [image_cut] = autocut(orgain_image)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% imput orgain image
%% output cut image
%% ï¿½ï¿½ï¿? left_cut =1 :ï¿½ï¿½ë²¿ï¿½Ý¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
%% ï¿½ï¿½ï¿? right_cut = 1ï¿½ï¿½ï¿½Ò°ë²¿ï¿½Ý¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?


s = 3;%%ï¿½Ï¶Ëµï¿½ï¿½ï¿½ï¿½ï¿½Ö±ï¿½ß¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Þ¸Ä¼Ó¿ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù¶È£ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?1ï¿½ï¿½5
ss = 2;%%ï¿½Â¶Ëµï¿½ï¿½ï¿½ï¿½ï¿½Ö±ï¿½ßµÄ¼ï¿½ï¿?%Îªï¿½ï¿½×¼È·ï¿½È²ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Þ¸ï¿½
q = 5;%%ï¿½ï¿½ï¿½ï¿½Ö±ï¿½ï¿½ï¿½ÏµÄµï¿½ï¿½ï¿½%ï¿½ï¿½ï¿½ï¿½ï¿½Þ¸Ä¼Ó¿ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù¶È½ï¿½ï¿½ï¿½ï¿½ï¿½1ï¿½ï¿½5

imrgb = orgain_image;
[row,col,dep]=size(imrgb);
% if row>col
%     imrgb=imresize(imrgb,[min(2560,row),min(2560,row)*col/row]);
% else
%     imrgb=imresize(imrgb,[min(2560,col)*row/col,min(2560,col)]);
% end
% [Y,X] = size(imrgb(:,:,1));
% if(X > Y)%%%%ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½×ª
%     imrgb = imrotate(imrgb,-90,'nearest');
% end
imrgb = edgecut(imrgb);%È¥ï¿½ï¿½Í¼ï¿½ï¿½ÄºÚ±ß£ï¿?
[Y,X] = size(imrgb(:,:,1));
imrgb_orgain = imrgb;

% imrgb = imresize(imrgb,4260/Y);%ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½ï¿½Ð?%%%%%%%%%%%%%%ï¿½ï¿½ï¿½ï¿½ï¿½Þ¸ï¿½426ï¿½Ó¿ï¿½ï¿½ï¿½ï¿½ï¿½Ù¶È£ï¿?100ï¿½ï¿½426Ö®ï¿½ï¿½
imgray = rgb2gray(imrgb);%×ªï¿½ï¿½ï¿½É»Ò¶ï¿½
im = imgray;
[Y,X] = size(im);
imcanny = edge(im,'canny',0.1);%cannyï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ôµ
se1 = strel('line',3,0);
se2 = strel('line',3,90);
im = imdilate(imcanny,se1);%%ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½Ðºï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
im = imerode(im,se2);%%ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¸ï¿½Ê´
halfY  = round(Y/2);
halfX  = round(X/2);
unicomnum = round(Y/5);%ï¿½ï¿½ï¿½Ïµï¿½ï¿½ï¿½Í¨ï¿½ï¿½Ö§ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
unicom = zeros(2*halfY + X,X,unicomnum);
for i = 3:s:2* halfY +X%%%ï¿½ï¿½Ñ­ï¿½ï¿½
    if i <=  halfY
        for j = 1:ss: halfX
            k = 1;
            line = zeros(1,Y);
            t = 1:halfY+i-1;
            x = halfY-i+t;
            y = round((j-1)./(Y-halfY+i-1).*(x-Y)+j);
            for tt = 2*q:q: halfY +i-1
                line(tt) = im(x(tt),y(tt));
                if line(tt) ~= 0
                    unicom(i,j,k) = unicom(i,j,k)+1;
                elseif line(tt) == 0&&line(tt-q) ~= 0
                    k = k+1;
                end
            end
        end
    elseif i >  halfY &&i<= halfX + halfY
        for j = 1:ss: halfX
            k = 1;
            line = zeros(1,Y);
            x = 1:Y;
            y = round((j-i+halfY)./(Y-1).*(x-1)+(i-halfY));
            for tt = 2*q:q:Y
                line(tt) = im(x(tt),y(tt));
                if line(tt) ~= 0
                    unicom(i,j,k) = unicom(i,j,k)+1;
                elseif line(tt) == 0 && line(tt-q) ~= 0
                    k = k+1;
                end
            end
        end
    elseif i> halfX + halfY &&i<X+ halfY
        for j =  halfX :ss:X
            k = 1;
            line = zeros(1,Y);
            x = 1:Y;
            y = round((j-i+halfY)./(Y-1).*(x-1)+(i-halfY));
            for tt = 2*q:q:Y
                line(tt) = im(x(tt),y(tt));
                if line(tt) ~= 0
                    unicom(i,j,k) = unicom(i,j,k)+1;
                elseif line(tt) == 0&&line(tt-q) ~= 0
                    k = k+1;
                end
            end
        end
    elseif i >=  halfY +X
        for j =  halfX :ss:X
            k = 1;
            line = zeros(1,Y);
            t = 1:halfY+X+Y-i;
            x = t+i-halfY-X;
            y = round((j-X)./(Y-i+X+halfY).*(x-Y)+j);
            for tt = 2*q:q:halfY+X+Y-i
                line(tt) = im(x(tt),y(tt));
                if line(tt) ~= 0
                    unicom(i,j,k) = unicom(i,j,k)+1;
                elseif line(tt) == 0&&line(tt-q) ~= 0
                    k = k+1;
                end
            end
        end
    end
end
ret1 = zeros( halfY + halfX , halfX );%Ç°ï¿½Ä¸ï¿½ï¿½ï¿½Í¨ï¿½ï¿½Ö§ï¿½Äºï¿½
for i = 1: halfY + halfX
    for j = 1: halfX
        unicomsort = sort(unicom(i,j,:),'descend');
        ret1(i,j) = sum(unicomsort(1:4))/Y*q;
    end
end
[retmax1,index11] = max(ret1);
[lineleft,lineleftind] = sort(retmax1,'descend');
xbot1 = -1*ones(1,20);%ï¿½ï¿½Â¼ï¿½ï¿½ßµï¿½Ö±ï¿½ßµï¿½ï¿½Ï¶Ëµï¿?
xtop1 = -1*ones(1,20);%ï¿½ï¿½Â¼ï¿½ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½Â¶Ëµï¿?
xtop1(1) = index11(lineleftind(1));%ï¿½î³¤ï¿½ï¿½Ö±ï¿½ï¿½
xbot1(1) = lineleftind(1);
linenum = 2;
for i = 1:20%%%ï¿½ï¿½Ç°20ï¿½ï¿½ï¿½È½Ï´ï¿½ï¿½Öµï¿½ï¿½Í?ï¿½ï¿½Ö±ï¿½ï¿½
    if (min(abs(xbot1(1:linenum)-lineleftind(i))) >= 15|| min(abs(xtop1(1:linenum)-index11(lineleftind(i)))) >= 15)&&retmax1(lineleftind(i))/retmax1(lineleftind(1)) > 0.5
        xbot1(linenum) = lineleftind(i);
        xtop1(linenum) = index11(lineleftind(i));
        linenum = linenum + 1;
    end
end
ret2 = zeros(X+ halfY - halfX, halfX );%%%%%%%%ï¿½Ò°ï¿½ßµï¿½Ö±ï¿½ß³ï¿½ï¿½ï¿?
for i = X+ halfY - halfX +1:2*X+2*halfY-2*halfX
    for j =  halfX +1:X
        unicomsort = sort(unicom(i,j,:),'descend');
        ret2(i-(X+ halfY - halfX ),j- halfX ) = sum(unicomsort(1:4))/Y*q;
    end
end
[retmax2,index21] = max(ret2);%ï¿½ï¿½ret2Ã¿Ò»ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
[lineright,linerightind] = sort(retmax2,'descend');
xbot2 = -1*ones(1,20);%ï¿½ï¿½Â¼ï¿½Ò±ï¿½Ö±ï¿½ßµï¿½ï¿½Â¶Ëµï¿½
xtop2 = -1*ones(1,20);%ï¿½ï¿½Â¼ï¿½Ò±ï¿½Ö±ï¿½ßµï¿½ï¿½Ï¶Ëµï¿½
xbot2(1) = halfX + linerightind(1);
xtop2(1) = halfY + halfX + index21(linerightind(1));
linenum = 2;
for i = 1:30%ï¿½ï¿½Ç°ï¿½ï¿½Ê®ï¿½ï¿½ï¿½È½Ï´ï¿½ï¿½Öµï¿½ï¿½Í?ï¿½ï¿½Ö±ï¿½ï¿½
    if (min(abs(xbot2(1:linenum)-halfX - linerightind(i))) >= 15 || min(abs(xtop2(1:linenum)-halfY-halfX-index21(linerightind(i)))) >= 15)&&retmax2(linerightind(i))/retmax2(linerightind(1)) > 0.5
        xbot2(linenum) = halfX + linerightind(i);
        xtop2(linenum) = halfX + halfY + index21(linerightind(i));
        linenum = linenum + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½Ð¶ï¿½
width = 20;%È¡ï¿½ï¿½Ö±ï¿½ï¿½ï¿½ï¿½ï¿½ßµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
lineleftr = zeros(width,Y,3);%Ö±ï¿½ï¿½ï¿½ó²¿·ï¿½
linerightr = zeros(width,Y,3);%Ö±ï¿½ï¿½ï¿½Ò²ï¿½ï¿½ï¿½
n = 6;%Ã¿ï¿½ï¿½È¡ï¿½ï¿½Ö±ï¿½ß¸ï¿½ï¿½ï¿½
%         figure;
for i = 1:n%%%%%%%%%%%ï¿½ï¿½Ç°nï¿½ï¿½Ö±ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½É?ï¿½ï¿½Ö±ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ô£ï¿½ï¿½ï¿½È¡ï¿½î²»ï¿½ï¿½ï¿½Æµï¿½ï¿½ï¿½É«
    if xtop1(i) ~= -1
        for j = 1:min(width,xbot1(i))
            for t = 1:Y
                yleft = max(1,round((-t+1)*(max(1,xbot1(i) -j) - max(xtop1(i)-j-halfY,1))/(min(halfY+xtop1(i)-j,Y)-1)+max(1,xbot1(i)-j)));
                lineleftr(j,t,:) = imrgb(Y-t+1,yleft,:);
                yright = max(1,round((-t+1)*(max(1,xbot1(i) +j) - max(xtop1(i)+j-halfY,1))/(min(halfY+xtop1(i)+j,Y)-1)+max(1,xbot1(i)+j)));
                linerightr(j,t,:) = imrgb(Y-t+1,yright,:);
            end
        end
        countleftr = colorhistf(lineleftr(:,round(Y/4):min(xtop1(i)+halfY-width,round(Y/4*3)),:));
        countrightr = colorhistf(linerightr(:,round(Y/4):min(xtop1(i)+halfY-width,round(Y/4*3)),:));
        colorhist_left(:,:,i) = [countleftr,countrightr];
        
    end
end

for i = 1:n%%%%%%%%%%%ï¿½ï¿½Ç°ï¿½ï¿½ï¿½ï¿½Ö±ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½É?ï¿½ï¿½Ö±ï¿½ï¿½Í¼
    if xtop2(i) ~= -1
        for j = 1:min(Y-xbot2(i)+1,width)
            for t = 1:Y
                yleft = min(round((-t+1)*(min(xbot2(i)-j,X)-min(X,xtop2(i)-j-halfY))/(Y-max(xtop2(i)-j-halfY-X,1))+min(xbot2(i)-j,X)),X);
                lineleftr(j,t,:) = imrgb(Y-t+1,yleft,:);
                yright = min(round((-t+1)*(min(xbot2(i)+j,X)-min(X,xtop2(i)+j-halfY))/(Y-max(xtop2(i)+j-halfY-X,1))+min(xbot2(i)+j,X)),X);
                linerightr(j,t,:) = imrgb(Y-t+1,yright,:);
            end
        end
        countleftr = colorhistf(lineleftr(:,round(Y/4):min(Y+X+halfY-xtop2(i)-width,round(Y/4*3)),:));
        countrightr = colorhistf(linerightr(:,round(Y/4):min(Y+X+halfY-xtop2(i)-width,round(Y/4*3)),:));
        colorhist_right(:,:,i) = [countleftr,countrightr];
    end
end
ret3 = -100*ones(n,n);%%ï¿½ï¿½ï¿½Û¾ï¿½ï¿½ï¿½ï¿½Ê¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?iï¿½ï¿½jï¿½Ð¶ï¿½Ó¦ï¿½ï¿½ï¿½ï¿½ßµï¿?i ï¿½ï¿½Ö±ï¿½ï¿½ ï¿½Ò±ßµï¿½jï¿½ï¿½Ö±ï¿½ï¿½
for i = 1:min(n,sum(xtop1(:) ~= -1))
    for j = 1:min(n,sum(xtop2(:) ~= -1))
        av1 = pdist2(colorhist_left(:,1,i)',colorhist_left(:,2,i)','correlation');
        %ï¿½ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½ï¿½É?Ö±ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½;
        av2 = pdist2(colorhist_right(:,1,j)',colorhist_right(:,2,j)','correlation');
        %ï¿½Ò±ï¿½Ö±ï¿½ßµï¿½ï¿½ï¿½É«Ö±ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        av3 = pdist2(colorhist_left(:,2,i)',colorhist_right(:,1,j)','correlation');
        %ï¿½ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½Ò±ï¿½ï¿½ï¿½ï¿½Ò±ï¿½Ö±ï¿½ßµï¿½ï¿½ï¿½ßµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        av4 = pdist2(colorhist_left(:,1,i)',colorhist_right(:,2,j)','correlation');
        %ï¿½ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ò±ï¿½Ö±ï¿½ßµï¿½ï¿½Ò±ßµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
        if sum(xtop1(:) ~= -1) == 1 && sum(xtop2(:) ~= -1) > 1
            ret3(i,j) = 1- av3 + av2;%Ò»ï¿½ï¿½ï¿½ï¿½Ò»ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ô½ï¿½ï¿½Ô½ï¿½ï¿?
        elseif sum(xtop1(:) ~= -1) > 1 && sum(xtop2(:) ~= -1) == 1
            ret3(i,j) = 1- av3 + av1;
        else
            ret3(i,j) = (av1+av2)-av3;%ï¿½ï¿½ï¿½ß¶ï¿½ï¿½Ð¶ï¿½ï¿½ï¿½Ö±ï¿½ßµï¿½ï¿½ï¿½ï¿½ï¿½Âµï¿½ï¿½ï¿½ï¿½Ð±ï¿½×?
        end
    end
end
[maxline2,indexline] = max(ret3);
[maxline1 ,right] = max(maxline2);


top1 = xtop1(indexline(right));%ï¿½ï¿½ßµï¿½Ö±ï¿½ï¿?
bot1 = xbot1(indexline(right));
top2 = xtop2(right);%ï¿½Ò±ßµï¿½Ö±ï¿½ï¿½
bot2 = xbot2(right);
av1 = pdist2(colorhist_left(:,1,indexline(right))',colorhist_left(:,2,indexline(right))','correlation');
av2 = pdist2(colorhist_right(:,1,right)',colorhist_right(:,2,right)','correlation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%×¼È·ï¿½ï¿½ï¿½Ö±ï¿½ßµÄ³ï¿½ï¿½ï¿?
se1 = strel('line',6,0);
im = imdilate(imcanny,se1);%%ï¿½ï¿½Í¼ï¿½ï¿½ï¿½ï¿½Ðºï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
%         figure;
%         imshow(1-im);
count1 = 1;
count2 = 1;
finalleftline = zeros(1,round(Y/2));
finalrightline = zeros(1,round(Y/2));
line_left = zeros(1,Y);
line_right = zeros(1,Y);
for t = 2:Y
    yleft = max(1,round((-t+1)*(max(1,bot1) - max(top1-halfY,1))/(min(halfY+top1,Y)-1)+max(1,bot1)));
    yright = min(round((-t+1)*(min(bot2,X)-min(X,top2-halfY))/(Y-max(top2-halfY-X,1))+min(bot2,X)),X);
    line_left(t) = im(Y-t+1,yleft);
    line_right(t) = im(Y-t+1,yright);
    if line_left(t) ~= 0
        finalleftline(count1) = finalleftline(count1)+1;
    elseif line_left(t) == 0&&line_left(t-1) ~= 0
        count1 = count1+1;
    end
    if line_right(t) ~= 0
        finalrightline(count2) = finalrightline(count2)+1;
    elseif line_right(t) == 0&&line_right(t-1) ~= 0
        count2 = count2+1;
    end
end
finalleft = sort(finalleftline,'descend');
finalright = sort(finalrightline,'descend');
leftlength = sum(finalleft(1:3));
rightlength = sum(finalright(1:3));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ï¿½Ð¶ï¿½Ö±ï¿½ï¿½ï¿½Ç·ï¿½ï¿½ï¿½ï¿?
left_cut = 0;
right_cut = 0;
if av1*leftlength/Y < 0.05 &&leftlength/Y < 0.36
    p1 = [1,1];
    p2 = [1,Y];
elseif av1*leftlength/Y < 0.075 &&sum(xtop1(:) >= 1) > 1&&leftlength/Y <0.36
    p1 = [1,1];
    p2 = [1,Y];
else
    left_cut = 1;
    p1 = [max(1,top1-halfY),max(1,halfY-top1)];
    p2 = [bot1,Y];
    %             fprintf('ï¿½ï¿½ï¿½ß¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?\n');
end

if av2*rightlength/Y < 0.05&&rightlength/Y < 0.36
    p3 = [X,1];
    p4 = [X,Y];
elseif av2*rightlength/Y < 0.075&&sum(xtop2(:) >= 1) > 1&&rightlength/Y<0.36
    p3 = [X,1];
    p4 = [X,Y];
else
    right_cut = 1;
    p3 = [min(X,top2-halfY),max(top2-halfY-X,1)];
    p4 = [bot2,Y];
    %             fprintf('ï¿½Ò°ï¿½ß¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Y_orgain,X_orgain] = size(imrgb_orgain(:,:,1));
p1 = Y_orgain/Y*p1;%ï¿½ï¿½ï¿½ä»»ï¿½ï¿½Ô­Í¼ï¿½ï¿½
p2 = Y_orgain/Y*p2;
p3 = Y_orgain/Y*p3;
p4 = Y_orgain/Y*p4;

for i = 1:Y_orgain
    for j = 1:X_orgain
        cc = (p1(2)-p2(2))*(j-p1(1))-(p1(1)-p2(1))*(i-p1(2));
        dd = (p3(2)-p4(2))*(j-p3(1))-(p3(1)-p4(1))*(i-p3(2));
        if cc*dd >= 0
            imrgb_orgain(i,j,1) = 0;%ï¿½ï¿½ÉºÚµï¿?
            imrgb_orgain(i,j,2) = 0;
            imrgb_orgain(i,j,3) = 0;
        end
    end
end

image_cut = imcrop(imrgb_orgain,[round(min(p1(1),p2(1))),1,round(max(p3(1),p4(1)))-round(min(p1(1),p2(1))),Y_orgain-1]);%ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
[~, image_cut] = findBoundary_updown(image_cut);

end

function imcut = edgecut(im)
% im = imread('cutexample.png');
imgray = rgb2gray(im);
a = sum(imgray,1);
a = a/length(a);
a1 = [0,a(1:length(a)-1)];
b = sum(imgray,2);
b = b/length(b);
b1 = [0;b(1:length(b)-1)];
a = abs(a-a1);
b = abs(b-b1);
mark1 = 0;
mark2 = 0;
leftedge = 1;
rightedge = 1;
for i = round(1/30*length(a)):round(29/30*length(a))
    if a(i) > 15&&mark1 == 0
        leftedge = i;
        mark1 = 1;
    end
    if a(length(a)-i+1) >20 && mark2 == 0
        rightedge = i;
        mark2 = 1;
    end
end
    
mark1 = 0;
mark2 = 0;
upedge = 1;
downedge = 1;
for i = round(1/30*length(a)):round(29/30*length(b))
    if b(i) > 15&&mark1 == 0
        upedge = i;
        mark1 = 1;
    end
    if b(length(b)-i+1) > 20 &&mark2 == 0
        downedge = i;
        mark2 = 1;
    end
end

% fprintf('%d,%d,%d,%d',leftedge,rightedge,upedge,downedge);

if (abs(leftedge-rightedge) < 5)&&abs(upedge-downedge) < 30&&leftedge > round(1/30*length(a))&&upedge > round(1/30*length(b))
    up = upedge;
    left = max(leftedge,rightedge);
    imcut = imcrop(im,[left,up,length(a)-2*left,length(b)-upedge-downedge]);
    
else
    imcut = im;
end
% imshow(imcut);
end
    
function [image_binary, image_cutted] = findBoundary_updown(image_name)
% [image_binary, image_cutted] = findBoundary_updown(image_name)
%%% ¶Ôµ¥¸öÍ¼Æ¬Ñ°ÕÒÉÏÏÂ±ß½ç

    %% Ô¤´¦Àí

    Im.name = '~';
    Im.rgb = image_name;
    % figure; imshow(Im.rgb);

    % ×ª»¯Îª»Ò¶ÈÍ¼
    if size(Im.rgb, 3)
        Im.gray = rgb2gray(Im.rgb);
    else
        Im.gray = Im.rgb;
    end
    % figure; imshow(Im.gray);

    % ¸ßË¹ÂË²¨
    Im.filter = fspecial('Gaussian');
    Im.gaussian = imfilter(Im.gray, Im.filter);
    % figure; imshow(Im.gray);

    % canny±ßÔµ¼ì²â
    Im.canny = edge(Im.gaussian, 'canny'); %% µ÷ÊÔ
    % figure; imshow(Im.canny);

    %¶ÔÍ¼Ïñ½øÐÐ×ÝÏòµÄÅòÕÍ
    Im.se_vertical = strel('line', 3, 90);
    Im.dilate = imdilate(Im.canny, Im.se_vertical);
    % figure; imshow(Im.dilate);

    %¶ÔÍ¼Ïñ½øÐÐºáÏòµÄ¸¯Ê´
    Im.se_horizontal = strel('line', 3, 0);
    Im.dilate_erode = imerode(Im.dilate,Im.se_horizontal);
    % figure; imshow(Im.dilate_erode);

    % µÃµ½Ï¸»¯µÄ±ßÔµ
    Im.edge = Im.canny .* Im.dilate_erode;
    % Im.edge = Im.dilate_erode;
    % figure; imshow(Im.edge);

    %% Ñ°ÕÒºòÑ¡±ß½ç

    [Im.height, Im.width] = size(Im.edge);
    Im.edge_tmp = Im.edge;

    %%%% ºòÑ¡±ß½çµÄÊôÐÔ
    Trace = struct();
    STP = 1; % tail-of-Trace-struct; Trace½á¹¹µÄ³¤¶È-1

    %%%% È·¶¨ºòÑ¡±ß½çµÄÆðµã²¢Ñ°ÕÒ±ß½ç
    Global.StartPoints = find(Im.edge_tmp); % ºòÑ¡±ß½çµÄËùÓÐ¿ÉÄÜµÄÆðµã
    Global.id_StartPoint = 1;
    while Global.id_StartPoint <= size(Global.StartPoints,1)
        Curve = struct();

        Curve.SP_rowNO = mod(Global.StartPoints(Global.id_StartPoint), Im.height); % ¸ÃµãËùÔÚµÄÐÐ
        Curve.SP_colNO = ceil(Global.StartPoints(Global.id_StartPoint) / Im.height); % ¸ÃµãËùÔÚµÄÁÐ

    %     findContinuousTrace;

        %% ´Ó¸ø¶¨µÄÆðµãÏòÓÒÉ¨ÃèÁ¬ÐøÇúÏß£¬ÁôÏÂ³¤¶È´óÓÚÍ¼Ïñ¿í¶ÈÒ»¶¨±ÈÀýµÄÇúÏß

        %%%% Í³¼ÆÁ¿³õÊ¼»¯

        % ¹ì¼£ Curve.trace(i,1)ÎªµÚi¸ö¹ì¼£µãµÄÁÐid, Curve.trace(i,2)ÎªÐÐid
        Curve.trace = zeros(Im.width, 2);

        % ¹ì¼£Éú³¤·½Ïò:1 ÓÒÉÏ; 2 ÓÒ·½; 3 ÓÒÏÂ
        Curve.direction = zeros(1, Im.width - Curve.SP_colNO + 1);

        % ¹ì¼£³¤¶È
        Curve.length = 0;

        %% Éú³¤
        id_row = Curve.SP_rowNO;
        Im.edge_tmp(Curve.SP_rowNO, Curve.SP_colNO) = 0;
        for id_col = Curve.SP_colNO : 1 : Im.width
            % ¼ÇÂ¼x(Im.height)ºÍy(Im.width)×ø±ê
            Curve.trace(id_col,1) = id_col;
            Curve.trace(id_col,2) = id_row;

            % ÓÒÉÏµãÎª±ßÔµµã
            if id_row-1 > 0 && id_col+1 <= Im.width && Im.edge_tmp(id_row-1, id_col+1)
                Im.edge_tmp(id_row-1, id_col+1) = 0;
                id_row = id_row - 1;
        %         Curve.right_up_times = Curve.right_up_times + 1;
                Curve.direction(id_col) = 1;

            % ÓÒ±ßµÄµãÎª±ßÔµµã
            elseif Im.edge_tmp(id_row, id_col+1)
                Im.edge_tmp(id_row, id_col+1) = 0;
        %         Curve.right_times = Curve.right_times + 1;
                Curve.direction(id_col) = 2;

            % ÓÒÏÂµãÎª±ßÔµµã    
            elseif id_row+1 < Im.height && id_col+1 <= Im.width && Im.edge_tmp(id_row+1, id_col+1)
                Im.edge_tmp(id_row+1, id_col+1) = 0;
                id_row = id_row + 1;
        %         Curve.right_down_times = Curve.right_down_times + 1;
                Curve.direction(id_col) = 3;

            % ÏòÓÒ²àÕÒ²»µ½Á¬ÐøµÄ±ßÔµµã    
            else
                break;
            end

            % ¹ì¼£³¤¶È¼Ó1
            Curve.length = Curve.length + 1;
        end

        % Curve.right_up_times = sum(Curve.direction==1);
        Curve.right_times = sum(Curve.direction==2);
        % Curve.right_down_times = sum(Curve.direction==3);

        % ¹ì¼£µÄºáÏò¿ç¶È
        Curve.span = id_col - Curve.SP_colNO + 1;

        %% ¹ì¼£¿ç¶È or ¹ì¼£³¤¶È ´óÓÚÍ¼Ïñ¿í¶ÈµÄÒ»¶¨±ÈÀý ²Å¼ÇÂ¼ÏÂ¸Ã¹ì¼£
        if Curve.right_times > 0.3*Im.width || Curve.length > 0.4*Im.width

            Curve.trace = Curve.trace(Curve.SP_colNO:id_col, :);
            Curve.direction(Curve.direction==0) = [];

            %%%% Ð´ÈëÊôÐÔ½á¹¹
            Trace(STP).details = {Curve.trace}; % ¹ì¼£µÄ ÁÐ-ÐÐ µÑ¿¨¶û×ø±ê

            %%%%
            Trace(STP).Height = struct();
            Trace(STP).Height.average = mean(Curve.trace(:,2));  % Æ½¾ù¸ß¶È:¾àÀë×îÉÏ±ßµÄÆ½¾ù¾àÀë
            Trace(STP).Height.highest = min(Curve.trace(:,2));  % ×î¸ß¸ß¶È
            Trace(STP).Height.lowest = max(Curve.trace(:,2));  % ×îµÍ¸ß¶È
        %     Trace(STP).Height.std = std(Curve.trace(:,2));  % ±ê×¼²î

        %     Trace(STP).span = Curve.span; % ¹ì¼£µÄºáÏò¿ç¶È
            Trace(STP).length = Curve.length; % ¹ì¼£µÄ³¤¶È

            %%%% ¹ì¼£µÄ×ßÊÆ
            Trace(STP).Trend = struct();
            Trace(STP).Trend.details = Curve.direction; % ¹ì¼£Éú³¤·½Ïò:1 ÓÒÉÏ; 2 ÓÒ·½; 3 ÓÒÏÂ
            Trace(STP).Trend.ru = sum(Trace(STP).Trend.details == 1); % ÓÒÉÏ×ßÊÆ´ÎÊý
            Trace(STP).Trend.r = sum(Trace(STP).Trend.details == 2); % ÓÒ·½×ßÊÆ´ÎÊý
            Trace(STP).Trend.rd = sum(Trace(STP).Trend.details == 3); % ÓÒÏÂ×ßÊÆ´ÎÊý

            %%%% ¹ì¼£µÄ¹Ø¼üµã
            Trace(STP).Point = struct();
            Trace(STP).Point.SP = [Curve.SP_colNO, Curve.SP_rowNO]; % ÆðÊ¼µãµÄ[ÁÐid,ÐÐid]
            Trace(STP).Point.TP = [id_col, id_row]; % ÖÕÖ¹µãµÄ[ÁÐid,ÐÐid]

            %%%% ¹ì¼£µÄËùÊôÇøÓò
            if Trace(STP).Point.SP(1,2) < Im.height/3
                Trace(STP).traceRegion = 'upper';
            elseif Trace(STP).Point.SP(1,2) > 2*Im.height/3
                Trace(STP).traceRegion = 'lower';
            else
                Trace(STP).traceRegion = 'middle';
            end

            %%%% ¹ì¼£µÃ·Ö
        %     Trace(STP).score = 0; % ¹ì¼£µÃ·Ö

            STP = STP + 1;
        end

        Global.id_StartPoint = Global.id_StartPoint + 1;

    end


    %% È·¶¨ÉÏ±ß½ç²¢±£´æ
    Scoring = struct();

    % ºòÑ¡¹ì¼£µÄÊýÄ¿
    Scoring.traceNum = STP-1;

    %% ºòÑ¡¹ì¼£ÊýÄ¿Îª0,´æ´¢¸Ã ÎÞºòÑ¡¹ì¼£µÄÍ¼Æ¬

    if ~Scoring.traceNum

        Im.cutted = Im.rgb;
        image_cutted = Im.cutted;
        
        Im.binaryCutted = ones(Im.height, Im.width);
        image_binary = Im.binaryCutted;
        return;
    end

    %% ¸øºòÑ¡¹ì¼£Öð¸öÆÀ·Ö Scoring½á¹¹

    %%%% 
    %%% Sort Óò
    Scoring.Sort = struct();

    % Æ½¾ù¸ß¶È ÅÅÐò
    Scoring.Height = [Trace.Height]; % É¢struct -> Êý×éstruct
    [~, Scoring.Sort.aveHeightInd] = sort([Scoring.Height.average], 'ascend'); % Æ½¾ù¸ß¶ÈÅÅÐò


    %%% Treshold Óò
    % Scoring.Threshold = struct('bendUpper',0.2, 'bendLower',0, 'neighborDist',Im.height/50);
    % Scoring.Threshold = struct();
    % Scoring.Threshold.bendLower = 0;
    % Scoring.Threshold.bendUpper = 1/5;
    % Scoring.Threshold.neighborDist = Im.height/50;


    %%%% Í³¼Æ¸÷ÖÖÅÅÃû

    Scoring.aveHeighRank = zeros(1,Scoring.traceNum);
    for id = 1 : Scoring.traceNum   
        Scoring.aveHeightRank(Scoring.Sort.aveHeightInd(id)) = id;         
    end


    %%%% ±éÀúÃ¿¸ö trace
    Scoring.UpperBoundaryId = 0;
    Scoring.LowerBoundaryId = 0;
    for id = 1 : Scoring.traceNum

        %%% ÖÐ¼äÏß ²»¿¼ÂÇ
        if strcmp(Trace(id).traceRegion, 'middle')
            continue;
        end

        r = Scoring.aveHeightRank(id);
        %%%% ÉÏ±ß½ç(×î¸ß ÇÒ ÊôÓÚ ÉÏÇøÓò)µÄÅÅÃûÀÛ»ý
        if r == 1 && strcmp(Trace(id).traceRegion, 'upper')
            Scoring.UpperBoundaryId = id;       

        %%%% ÏÂ±ß½ç(×îµÍ ÇÒ ÊôÓÚ ÏÂÇøÓò)µÄÅÅÃûÀÛ»ý    
        elseif r == Scoring.traceNum && strcmp(Trace(id).traceRegion, 'lower')
            Scoring.LowerBoundaryId = id;              

        end


    %%
    %     %%%% Ñ¡Ôñ×¼Ôò
    %     %%%% ÍäÇú³Ì¶ÈÔÚãÐÖµÖ®¼ä
    %     if (   Trace(id).Trend.ru / Trace(id).length > Scoring.Threshold.bendLower ...
    %         || Trace(id).Trend.rd / Trace(id).length > Scoring.Threshold.bendLower ...
    %         )
    %         Trace(id).score = Trace(id).score + 0.1;
    %     end
    %     
    % 
    %     if  (   Trace(id).Trend.ru / Trace(id).length < Scoring.Threshold.bendUpper ...
    %          || Trace(id).Trend.rd / Trace(id).length < Scoring.Threshold.bendUpper ...
    %          )
    %         Trace(id).score = Trace(id).score + 0.01;
    %     end
    %     
    %     %%%% ÏàÁÚÁ½Ìõ±ß½çµÄÆ½¾ù¾àÀë´óÓÚ¸ø¶¨ãÐÖµ
    %     if  (    id == 1 ...
    %           || id == Scoring.traceNum ...
    %           || (    Trace(id).Height.average - Trace(Scoring.Sort.aveHeightInd(id-1)).Height.average > Scoring.Threshold.neighborDist ...
    %                && Trace(Scoring.Sort.aveHeightInd(id+1)).Height.average - Trace(id).Height.average > Scoring.Threshold.neighborDist ...
    %               ) ...
    %          )
    %         Trace(id).score = Trace(id).score + 0.001;
    %     end


    end

    if Scoring.UpperBoundaryId == 0
        Im.upperLineCutted = 1;
    else
        Im.upperLineCutted = Trace(Scoring.UpperBoundaryId).Height.highest;
    end

    if Scoring.LowerBoundaryId == 0
        Im.lowerLineCutted = Im.height;
    else
        Im.lowerLineCutted = Trace(Scoring.LowerBoundaryId).Height.lowest;
    end

    Im.cutted = Im.rgb(  Im.upperLineCutted : Im.lowerLineCutted, :, : );
    image_cutted = Im.cutted;
    
    Im.binaryCutted =  zeros(Im.height, Im.width);
    Im.binaryCutted(Im.upperLineCutted : Im.lowerLineCutted, :) = 1;
    image_binary = Im.binaryCutted;


end


function count = colorhistf(imrgb )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
im=double(imrgb);      % ×ª»»Îª[0,1]
im=rgb2hsv(im);     % ×ª»»Îªhsv¿Õ¼ä
H=im(:,:,1);        %hsi(:, :, 1)ÊÇÉ«¶È·ÖÁ¿£¬ËüµÄ·¶Î§ÊÇ[0, 360]£»
S=im(:,:,2);        %hsi(:, :, 2)ÊÇ±¥ºÍ¶È·ÖÁ¿£¬·¶Î§ÊÇ[0, 1]£»
V=im(:,:,3);        %hsi(:, :, 3)ÊÇÁÁ¶È·ÖÁ¿£¬·¶Î§ÊÇ[0, 1]¡£
%½«hsv¿Õ¼ä·ÇµÈ¼ä¸ôÁ¿»¯£º
%  hÁ¿»¯³É16¼¶£»
%  sÁ¿»¯³É4¼¶£»
%  vÁ¿»¯³É4¼¶£»
%Á¿»¯H·ÖÁ¿
[hm,hn]=size(H);
H = H*360;
for i=1:hm
    for j=1:hn
        if H(i,j)>=345 || H(i,j)<15
            H(i,j)=0;
        end
        if H(i,j)<25&&H(i,j)>=15
            H(i,j)=1;
        end
        if H(i,j)<45&&H(i,j)>=25
            H(i,j)=2;
        end
        if H(i,j)<55&&H(i,j)>=45
            H(i,j)=3;
        end
        if H(i,j)<80&&H(i,j)>=55
            H(i,j)=4;
        end
        if H(i,j)<108&&H(i,j)>=80
            H(i,j)=5;
        end
        if H(i,j)<140&&H(i,j)>=108
            H(i,j)=6;
        end
        if H(i,j)<165&&H(i,j)>=140
            H(i,j)=7;
        end
        if H(i,j)<190&&H(i,j)>=165
            H(i,j)=8;
        end
        if H(i,j)<220&&H(i,j)>=190
            H(i,j)=9;
        end
        if H(i,j)<255&&H(i,j)>=220
            H(i,j)=10;
        end
        if H(i,j)<275&&H(i,j)>=255
            H(i,j)=11;
        end
        if H(i,j)<290&&H(i,j)>=275
            H(i,j)=12;
        end
        if H(i,j)<316&&H(i,j)>=290
            H(i,j)=13;
        end
        if H(i,j)<330&&H(i,j)>=316
            H(i,j)=14;
        end
        if H(i,j)<345&&H(i,j)>=330
            H(i,j)=15;
        end
    end
end
 %Á¿»¯S·ÖÁ¿
 for i=1:hm
    for j=1:hn
        if S(i,j)>0 && S(i,j)<=0.15
            S(i,j)=0;
        end
        if S(i,j)<=0.4&&S(i,j)>0.15
            S(i,j)=1;
        end
        if S(i,j)<=0.75&&S(i,j)>0.4
            S(i,j)=2;
        end
        if S(i,j)<=1&&S(i,j)>0.75
            S(i,j)=3;
        end
    end
 end
 
 %Á¿»¯V·ÖÁ¿
 for i=1:hm
    for j=1:hn
        if V(i,j)>0 && V(i,j)<=0.15
            V(i,j)=0;
        end
        if V(i,j)<=0.4&&V(i,j)>0.15
            V(i,j)=1;
        end
        if V(i,j)<=0.75&&V(i,j)>0.4
            V(i,j)=2;
        end
        if V(i,j)<=1&&V(i,j)>0.75
            V(i,j)=3;
        end
    end
 end
 G = zeros(hm,hn);
 for i = 1:hm
     for j = 1:hn
         G(i,j) = 4*H(i,j)+S(i,j);
     end
 end
%  imhist(G/64,64)
 [count1,n] = imhist(G/64,64);
 
%  count1 = [count1(2:16);count1(1)]+count1;
 count1 = count1/sum(count1);

 count = count1;
 
end



