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

