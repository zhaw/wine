function [image_cut] = autocut(orgain_image)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% imput orgain image
%% output cut image
%% ��� left_cut =1 :��벿�ݾ������
%% ��� right_cut = 1���Ұ벿�ݾ������

global ROOT;
if ROOT == []
    ROOT = '~/Projects/wine/';
end
addpath([ROOT 'Seg_m/segment_guangyi']);

s = 3;%%�϶˵�����ֱ�߼�������޸ļӿ������ٶȣ�������1��5
ss = 2;%%�¶˵�����ֱ�ߵļ��%Ϊ��׼ȷ�Ȳ������޸�
q = 5;%%����ֱ���ϵĵ���%�����޸ļӿ������ٶȽ�����1��5

imrgb = orgain_image;
[row,col,dep]=size(imrgb);
% if row>col
%     imrgb=imresize(imrgb,[min(2560,row),min(2560,row)*col/row]);
% else
%     imrgb=imresize(imrgb,[min(2560,col)*row/col,min(2560,col)]);
% end
% [Y,X] = size(imrgb(:,:,1));
% if(X > Y)%%%%��ͼ����ת
%     imrgb = imrotate(imrgb,-90,'nearest');
% end
imrgb = edgecut(imrgb);%ȥ��ͼ��ĺڱߣ�
[Y,X] = size(imrgb(:,:,1));
imrgb_orgain = imrgb;

% imrgb = imresize(imrgb,4260/Y);%����ͼ���С%%%%%%%%%%%%%%�����޸�426�ӿ�����ٶȣ�100��426֮��
imgray = rgb2gray(imrgb);%ת���ɻҶ�
im = imgray;
[Y,X] = size(im);
imcanny = edge(im,'canny',0.1);%canny������Ե
se1 = strel('line',3,0);
se2 = strel('line',3,90);
im = imdilate(imcanny,se1);%%��ͼ����к��������
im = imerode(im,se2);%%��ͼ���������ĸ�ʴ
halfY  = round(Y/2);
halfX  = round(X/2);
unicomnum = round(Y/5);%���ϵ���ͨ��֧��������
unicom = zeros(2*halfY + X,X,unicomnum);
for i = 3:s:2* halfY +X%%%��ѭ��
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
ret1 = zeros( halfY + halfX , halfX );%ǰ�ĸ���ͨ��֧�ĺ�
for i = 1: halfY + halfX
    for j = 1: halfX
        unicomsort = sort(unicom(i,j,:),'descend');
        ret1(i,j) = sum(unicomsort(1:4))/Y*q;
    end
end
[retmax1,index11] = max(ret1);
[lineleft,lineleftind] = sort(retmax1,'descend');
xbot1 = -1*ones(1,20);%��¼��ߵ�ֱ�ߵ��϶˵�
xtop1 = -1*ones(1,20);%��¼���ֱ�ߵ��¶˵�
xtop1(1) = index11(lineleftind(1));%���ֱ��
xbot1(1) = lineleftind(1);
linenum = 2;
for i = 1:20%%%��ǰ20���Ƚϴ��ֵ��ͬ��ֱ��
    if (min(abs(xbot1(1:linenum)-lineleftind(i))) >= 15|| min(abs(xtop1(1:linenum)-index11(lineleftind(i)))) >= 15)&&retmax1(lineleftind(i))/retmax1(lineleftind(1)) > 0.5
        xbot1(linenum) = lineleftind(i);
        xtop1(linenum) = index11(lineleftind(i));
        linenum = linenum + 1;
    end
end
ret2 = zeros(X+ halfY - halfX, halfX );%%%%%%%%�Ұ�ߵ�ֱ�߳���
for i = X+ halfY - halfX +1:2*X+2*halfY-2*halfX
    for j =  halfX +1:X
        unicomsort = sort(unicom(i,j,:),'descend');
        ret2(i-(X+ halfY - halfX ),j- halfX ) = sum(unicomsort(1:4))/Y*q;
    end
end
[retmax2,index21] = max(ret2);%��ret2ÿһ������
[lineright,linerightind] = sort(retmax2,'descend');
xbot2 = -1*ones(1,20);%��¼�ұ�ֱ�ߵ��¶˵�
xtop2 = -1*ones(1,20);%��¼�ұ�ֱ�ߵ��϶˵�
xbot2(1) = halfX + linerightind(1);
xtop2(1) = halfY + halfX + index21(linerightind(1));
linenum = 2;
for i = 1:30%��ǰ��ʮ���Ƚϴ��ֵ��ͬ��ֱ��
    if (min(abs(xbot2(1:linenum)-halfX - linerightind(i))) >= 15 || min(abs(xtop2(1:linenum)-halfY-halfX-index21(linerightind(i)))) >= 15)&&retmax2(linerightind(i))/retmax2(linerightind(1)) > 0.5
        xbot2(linenum) = halfX + linerightind(i);
        xtop2(linenum) = halfX + halfY + index21(linerightind(i));
        linenum = linenum + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ֱ�ߵ��ж�
width = 20;%ȡ��ֱ�����ߵ�������
lineleftr = zeros(width,Y,3);%ֱ���󲿷�
linerightr = zeros(width,Y,3);%ֱ���Ҳ���
n = 6;%ÿ��ȡ��ֱ�߸���
%         figure;
for i = 1:n%%%%%%%%%%%��ǰn��ֱ�����������������ɫ��ֱ��ͼ�������ԣ���ȡ����Ƶ���ɫ
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

for i = 1:n%%%%%%%%%%%��ǰ����ֱ�����������������ɫ��ֱ��ͼ
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
ret3 = -100*ones(n,n);%%���۾����ʼ��������i��j�ж�Ӧ����ߵ�i ��ֱ�� �ұߵ�j��ֱ��
for i = 1:min(n,sum(xtop1(:) ~= -1))
    for j = 1:min(n,sum(xtop2(:) ~= -1))
        av1 = pdist2(colorhist_left(:,1,i)',colorhist_left(:,2,i)','correlation');
        %���ֱ�ߵ���ɫֱ��ͼ������;
        av2 = pdist2(colorhist_right(:,1,j)',colorhist_right(:,2,j)','correlation');
        %�ұ�ֱ�ߵ���ɫֱ��ͼ��������
        av3 = pdist2(colorhist_left(:,2,i)',colorhist_right(:,1,j)','correlation');
        %���ֱ�ߵ��ұ����ұ�ֱ�ߵ���ߵ�������
        av4 = pdist2(colorhist_left(:,1,i)',colorhist_right(:,2,j)','correlation');
        %���ֱ�ߵ�������ұ�ֱ�ߵ��ұߵ�������
        if sum(xtop1(:) ~= -1) == 1 && sum(xtop2(:) ~= -1) > 1
            ret3(i,j) = 1- av3 + av2;%һ����һ��ֱ�ߵ������������Խ��Խ��
        elseif sum(xtop1(:) ~= -1) > 1 && sum(xtop2(:) ~= -1) == 1
            ret3(i,j) = 1- av3 + av1;
        else
            ret3(i,j) = (av1+av2)-av3;%���߶��ж���ֱ�ߵ�����µ����б�׼
        end
    end
end
[maxline2,indexline] = max(ret3);
[maxline1 ,right] = max(maxline2);


top1 = xtop1(indexline(right));%��ߵ�ֱ��
bot1 = xbot1(indexline(right));
top2 = xtop2(right);%�ұߵ�ֱ��
bot2 = xbot2(right);
av1 = pdist2(colorhist_left(:,1,indexline(right))',colorhist_left(:,2,indexline(right))','correlation');
av2 = pdist2(colorhist_right(:,1,right)',colorhist_right(:,2,right)','correlation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%׼ȷ���ֱ�ߵĳ���
se1 = strel('line',6,0);
im = imdilate(imcanny,se1);%%��ͼ����к��������
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ж�ֱ���Ƿ����
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
    %             fprintf('���߾������\n');
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
    %             fprintf('�Ұ�߾������\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Y_orgain,X_orgain] = size(imrgb_orgain(:,:,1));
p1 = Y_orgain/Y*p1;%���任��ԭͼ��
p2 = Y_orgain/Y*p2;
p3 = Y_orgain/Y*p3;
p4 = Y_orgain/Y*p4;

for i = 1:Y_orgain
    for j = 1:X_orgain
        cc = (p1(2)-p2(2))*(j-p1(1))-(p1(1)-p2(1))*(i-p1(2));
        dd = (p3(2)-p4(2))*(j-p3(1))-(p3(1)-p4(1))*(i-p3(2));
        if cc*dd >= 0
            imrgb_orgain(i,j,1) = 0;%��ɺڵ�
            imrgb_orgain(i,j,2) = 0;
            imrgb_orgain(i,j,3) = 0;
        end
    end
end

image_cut = imcrop(imrgb_orgain,[round(min(p1(1),p2(1))),1,round(max(p3(1),p4(1)))-round(min(p1(1),p2(1))),Y_orgain-1]);%����ͼ��
end


