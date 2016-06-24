function [image_cut] = autocut(orgain_image)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% imput orgain image
%% output cut image
%% ���? left_cut =1 :��벿�ݾ������
%% ���? right_cut = 1���Ұ벿�ݾ������?


s = 3;%%�϶˵�����ֱ�߼�������޸ļӿ������ٶȣ�������?1��5
ss = 2;%%�¶˵�����ֱ�ߵļ��?%Ϊ��׼ȷ�Ȳ������޸�
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
imrgb = edgecut(imrgb);%ȥ��ͼ��ĺڱߣ�?
[Y,X] = size(imrgb(:,:,1));
imrgb_orgain = imrgb;

% imrgb = imresize(imrgb,4260/Y);%����ͼ����?%%%%%%%%%%%%%%�����޸�426�ӿ�����ٶȣ�?100��426֮��
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
xbot1 = -1*ones(1,20);%��¼��ߵ�ֱ�ߵ��϶˵�?
xtop1 = -1*ones(1,20);%��¼���ֱ�ߵ��¶˵�?
xtop1(1) = index11(lineleftind(1));%���ֱ��
xbot1(1) = lineleftind(1);
linenum = 2;
for i = 1:20%%%��ǰ20���Ƚϴ��ֵ���?��ֱ��
    if (min(abs(xbot1(1:linenum)-lineleftind(i))) >= 15|| min(abs(xtop1(1:linenum)-index11(lineleftind(i)))) >= 15)&&retmax1(lineleftind(i))/retmax1(lineleftind(1)) > 0.5
        xbot1(linenum) = lineleftind(i);
        xtop1(linenum) = index11(lineleftind(i));
        linenum = linenum + 1;
    end
end
ret2 = zeros(X+ halfY - halfX, halfX );%%%%%%%%�Ұ�ߵ�ֱ�߳���?
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
for i = 1:30%��ǰ��ʮ���Ƚϴ��ֵ���?��ֱ��
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
for i = 1:n%%%%%%%%%%%��ǰn��ֱ������������������?��ֱ��ͼ�������ԣ���ȡ����Ƶ���ɫ
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

for i = 1:n%%%%%%%%%%%��ǰ����ֱ������������������?��ֱ��ͼ
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
ret3 = -100*ones(n,n);%%���۾����ʼ��������?i��j�ж�Ӧ����ߵ�?i ��ֱ�� �ұߵ�j��ֱ��
for i = 1:min(n,sum(xtop1(:) ~= -1))
    for j = 1:min(n,sum(xtop2(:) ~= -1))
        av1 = pdist2(colorhist_left(:,1,i)',colorhist_left(:,2,i)','correlation');
        %���ֱ�ߵ����?ֱ��ͼ������;
        av2 = pdist2(colorhist_right(:,1,j)',colorhist_right(:,2,j)','correlation');
        %�ұ�ֱ�ߵ���ɫֱ��ͼ��������
        av3 = pdist2(colorhist_left(:,2,i)',colorhist_right(:,1,j)','correlation');
        %���ֱ�ߵ��ұ����ұ�ֱ�ߵ���ߵ�������
        av4 = pdist2(colorhist_left(:,1,i)',colorhist_right(:,2,j)','correlation');
        %���ֱ�ߵ�������ұ�ֱ�ߵ��ұߵ�������
        if sum(xtop1(:) ~= -1) == 1 && sum(xtop2(:) ~= -1) > 1
            ret3(i,j) = 1- av3 + av2;%һ����һ��ֱ�ߵ������������Խ��Խ��?
        elseif sum(xtop1(:) ~= -1) > 1 && sum(xtop2(:) ~= -1) == 1
            ret3(i,j) = 1- av3 + av1;
        else
            ret3(i,j) = (av1+av2)-av3;%���߶��ж���ֱ�ߵ�����µ����б��?
        end
    end
end
[maxline2,indexline] = max(ret3);
[maxline1 ,right] = max(maxline2);


top1 = xtop1(indexline(right));%��ߵ�ֱ��?
bot1 = xbot1(indexline(right));
top2 = xtop2(right);%�ұߵ�ֱ��
bot2 = xbot2(right);
av1 = pdist2(colorhist_left(:,1,indexline(right))',colorhist_left(:,2,indexline(right))','correlation');
av2 = pdist2(colorhist_right(:,1,right)',colorhist_right(:,2,right)','correlation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%׼ȷ���ֱ�ߵĳ���?
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ж�ֱ���Ƿ����?
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
    %             fprintf('���߾������?\n');
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
            imrgb_orgain(i,j,1) = 0;%��ɺڵ�?
            imrgb_orgain(i,j,2) = 0;
            imrgb_orgain(i,j,3) = 0;
        end
    end
end

image_cut = imcrop(imrgb_orgain,[round(min(p1(1),p2(1))),1,round(max(p3(1),p4(1)))-round(min(p1(1),p2(1))),Y_orgain-1]);%����ͼ��
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
%%% �Ե���ͼƬѰ�����±߽�

    %% Ԥ����

    Im.name = '~';
    Im.rgb = image_name;
    % figure; imshow(Im.rgb);

    % ת��Ϊ�Ҷ�ͼ
    if size(Im.rgb, 3)
        Im.gray = rgb2gray(Im.rgb);
    else
        Im.gray = Im.rgb;
    end
    % figure; imshow(Im.gray);

    % ��˹�˲�
    Im.filter = fspecial('Gaussian');
    Im.gaussian = imfilter(Im.gray, Im.filter);
    % figure; imshow(Im.gray);

    % canny��Ե���
    Im.canny = edge(Im.gaussian, 'canny'); %% ����
    % figure; imshow(Im.canny);

    %��ͼ��������������
    Im.se_vertical = strel('line', 3, 90);
    Im.dilate = imdilate(Im.canny, Im.se_vertical);
    % figure; imshow(Im.dilate);

    %��ͼ����к���ĸ�ʴ
    Im.se_horizontal = strel('line', 3, 0);
    Im.dilate_erode = imerode(Im.dilate,Im.se_horizontal);
    % figure; imshow(Im.dilate_erode);

    % �õ�ϸ���ı�Ե
    Im.edge = Im.canny .* Im.dilate_erode;
    % Im.edge = Im.dilate_erode;
    % figure; imshow(Im.edge);

    %% Ѱ�Һ�ѡ�߽�

    [Im.height, Im.width] = size(Im.edge);
    Im.edge_tmp = Im.edge;

    %%%% ��ѡ�߽������
    Trace = struct();
    STP = 1; % tail-of-Trace-struct; Trace�ṹ�ĳ���-1

    %%%% ȷ����ѡ�߽����㲢Ѱ�ұ߽�
    Global.StartPoints = find(Im.edge_tmp); % ��ѡ�߽�����п��ܵ����
    Global.id_StartPoint = 1;
    while Global.id_StartPoint <= size(Global.StartPoints,1)
        Curve = struct();

        Curve.SP_rowNO = mod(Global.StartPoints(Global.id_StartPoint), Im.height); % �õ����ڵ���
        Curve.SP_colNO = ceil(Global.StartPoints(Global.id_StartPoint) / Im.height); % �õ����ڵ���

    %     findContinuousTrace;

        %% �Ӹ������������ɨ���������ߣ����³��ȴ���ͼ����һ������������

        %%%% ͳ������ʼ��

        % �켣 Curve.trace(i,1)Ϊ��i���켣�����id, Curve.trace(i,2)Ϊ��id
        Curve.trace = zeros(Im.width, 2);

        % �켣��������:1 ����; 2 �ҷ�; 3 ����
        Curve.direction = zeros(1, Im.width - Curve.SP_colNO + 1);

        % �켣����
        Curve.length = 0;

        %% ����
        id_row = Curve.SP_rowNO;
        Im.edge_tmp(Curve.SP_rowNO, Curve.SP_colNO) = 0;
        for id_col = Curve.SP_colNO : 1 : Im.width
            % ��¼x(Im.height)��y(Im.width)����
            Curve.trace(id_col,1) = id_col;
            Curve.trace(id_col,2) = id_row;

            % ���ϵ�Ϊ��Ե��
            if id_row-1 > 0 && id_col+1 <= Im.width && Im.edge_tmp(id_row-1, id_col+1)
                Im.edge_tmp(id_row-1, id_col+1) = 0;
                id_row = id_row - 1;
        %         Curve.right_up_times = Curve.right_up_times + 1;
                Curve.direction(id_col) = 1;

            % �ұߵĵ�Ϊ��Ե��
            elseif Im.edge_tmp(id_row, id_col+1)
                Im.edge_tmp(id_row, id_col+1) = 0;
        %         Curve.right_times = Curve.right_times + 1;
                Curve.direction(id_col) = 2;

            % ���µ�Ϊ��Ե��    
            elseif id_row+1 < Im.height && id_col+1 <= Im.width && Im.edge_tmp(id_row+1, id_col+1)
                Im.edge_tmp(id_row+1, id_col+1) = 0;
                id_row = id_row + 1;
        %         Curve.right_down_times = Curve.right_down_times + 1;
                Curve.direction(id_col) = 3;

            % ���Ҳ��Ҳ��������ı�Ե��    
            else
                break;
            end

            % �켣���ȼ�1
            Curve.length = Curve.length + 1;
        end

        % Curve.right_up_times = sum(Curve.direction==1);
        Curve.right_times = sum(Curve.direction==2);
        % Curve.right_down_times = sum(Curve.direction==3);

        % �켣�ĺ�����
        Curve.span = id_col - Curve.SP_colNO + 1;

        %% �켣��� or �켣���� ����ͼ���ȵ�һ������ �ż�¼�¸ù켣
        if Curve.right_times > 0.3*Im.width || Curve.length > 0.4*Im.width

            Curve.trace = Curve.trace(Curve.SP_colNO:id_col, :);
            Curve.direction(Curve.direction==0) = [];

            %%%% д�����Խṹ
            Trace(STP).details = {Curve.trace}; % �켣�� ��-�� �ѿ�������

            %%%%
            Trace(STP).Height = struct();
            Trace(STP).Height.average = mean(Curve.trace(:,2));  % ƽ���߶�:�������ϱߵ�ƽ������
            Trace(STP).Height.highest = min(Curve.trace(:,2));  % ��߸߶�
            Trace(STP).Height.lowest = max(Curve.trace(:,2));  % ��͸߶�
        %     Trace(STP).Height.std = std(Curve.trace(:,2));  % ��׼��

        %     Trace(STP).span = Curve.span; % �켣�ĺ�����
            Trace(STP).length = Curve.length; % �켣�ĳ���

            %%%% �켣������
            Trace(STP).Trend = struct();
            Trace(STP).Trend.details = Curve.direction; % �켣��������:1 ����; 2 �ҷ�; 3 ����
            Trace(STP).Trend.ru = sum(Trace(STP).Trend.details == 1); % �������ƴ���
            Trace(STP).Trend.r = sum(Trace(STP).Trend.details == 2); % �ҷ����ƴ���
            Trace(STP).Trend.rd = sum(Trace(STP).Trend.details == 3); % �������ƴ���

            %%%% �켣�Ĺؼ���
            Trace(STP).Point = struct();
            Trace(STP).Point.SP = [Curve.SP_colNO, Curve.SP_rowNO]; % ��ʼ���[��id,��id]
            Trace(STP).Point.TP = [id_col, id_row]; % ��ֹ���[��id,��id]

            %%%% �켣����������
            if Trace(STP).Point.SP(1,2) < Im.height/3
                Trace(STP).traceRegion = 'upper';
            elseif Trace(STP).Point.SP(1,2) > 2*Im.height/3
                Trace(STP).traceRegion = 'lower';
            else
                Trace(STP).traceRegion = 'middle';
            end

            %%%% �켣�÷�
        %     Trace(STP).score = 0; % �켣�÷�

            STP = STP + 1;
        end

        Global.id_StartPoint = Global.id_StartPoint + 1;

    end


    %% ȷ���ϱ߽粢����
    Scoring = struct();

    % ��ѡ�켣����Ŀ
    Scoring.traceNum = STP-1;

    %% ��ѡ�켣��ĿΪ0,�洢�� �޺�ѡ�켣��ͼƬ

    if ~Scoring.traceNum

        Im.cutted = Im.rgb;
        image_cutted = Im.cutted;
        
        Im.binaryCutted = ones(Im.height, Im.width);
        image_binary = Im.binaryCutted;
        return;
    end

    %% ����ѡ�켣������� Scoring�ṹ

    %%%% 
    %%% Sort ��
    Scoring.Sort = struct();

    % ƽ���߶� ����
    Scoring.Height = [Trace.Height]; % ɢstruct -> ����struct
    [~, Scoring.Sort.aveHeightInd] = sort([Scoring.Height.average], 'ascend'); % ƽ���߶�����


    %%% Treshold ��
    % Scoring.Threshold = struct('bendUpper',0.2, 'bendLower',0, 'neighborDist',Im.height/50);
    % Scoring.Threshold = struct();
    % Scoring.Threshold.bendLower = 0;
    % Scoring.Threshold.bendUpper = 1/5;
    % Scoring.Threshold.neighborDist = Im.height/50;


    %%%% ͳ�Ƹ�������

    Scoring.aveHeighRank = zeros(1,Scoring.traceNum);
    for id = 1 : Scoring.traceNum   
        Scoring.aveHeightRank(Scoring.Sort.aveHeightInd(id)) = id;         
    end


    %%%% ����ÿ�� trace
    Scoring.UpperBoundaryId = 0;
    Scoring.LowerBoundaryId = 0;
    for id = 1 : Scoring.traceNum

        %%% �м��� ������
        if strcmp(Trace(id).traceRegion, 'middle')
            continue;
        end

        r = Scoring.aveHeightRank(id);
        %%%% �ϱ߽�(��� �� ���� ������)�������ۻ�
        if r == 1 && strcmp(Trace(id).traceRegion, 'upper')
            Scoring.UpperBoundaryId = id;       

        %%%% �±߽�(��� �� ���� ������)�������ۻ�    
        elseif r == Scoring.traceNum && strcmp(Trace(id).traceRegion, 'lower')
            Scoring.LowerBoundaryId = id;              

        end


    %%
    %     %%%% ѡ��׼��
    %     %%%% �����̶�����ֵ֮��
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
    %     %%%% ���������߽��ƽ��������ڸ�����ֵ
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
im=double(imrgb);      % ת��Ϊ[0,1]
im=rgb2hsv(im);     % ת��Ϊhsv�ռ�
H=im(:,:,1);        %hsi(:, :, 1)��ɫ�ȷ��������ķ�Χ��[0, 360]��
S=im(:,:,2);        %hsi(:, :, 2)�Ǳ��Ͷȷ�������Χ��[0, 1]��
V=im(:,:,3);        %hsi(:, :, 3)�����ȷ�������Χ��[0, 1]��
%��hsv�ռ�ǵȼ��������
%  h������16����
%  s������4����
%  v������4����
%����H����
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
 %����S����
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
 
 %����V����
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



