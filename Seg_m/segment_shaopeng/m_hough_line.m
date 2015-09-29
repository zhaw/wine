function s = m_hough_line( f )
%f是输入图像，s是处理后的图像
f = imread(f); %读取图像
o = f;
f=rgb2gray(f);
oo = f;
f=im2double(f);
q = edge(f,'canny');
[m,n] = size(q);

%canny算子提取边缘信息后滤波
for i=3:m-2
    for j=3:n-2
        if q(i,j) > 0
            q(i,j) = 1;
        end;
    end;
end;
for i=3:m-2
    for j=3:n-2
        if q(i,j) == 1
            if sum(sum(q(i,j-2:j+2))) >= sum(sum(q(i-2:i+2,j)))
                q(i,j) = 0;
            end;
        end;
    end;
end;

q = bwareaopen(q,40);
BB = strel('line',3,0);
q = imdilate(q,BB);
[m,n] = size(q);
nn = round(n/2);
q1 = q(:,1:nn);
q2 = q(:,nn+1:n);

%Hough变换检测直线
%左半图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW1 = q1;
[m1,n1] = size(q1);
[H1,T1,R1] = hough(BW1,'Theta',-60:0.1:60);
Peaks=houghpeaks(H1,8);
lines=houghlines(BW1,T1,R1,Peaks);
k=length(lines);

try
    
    thetaleft = zeros(1,3);
    rholeft = zeros(1,3);
    thetai = 1;
    rhoi = 1;
    firstrho = -1;
    for i=1:k
        if lines(i).rho ~= firstrho
            thetaleft(thetai) = lines(i).theta;
            rholeft(rhoi) = lines(i).rho;
            firstrho = lines(i).rho;
            thetai = thetai+1;
            rhoi = rhoi+1;
            if rhoi==4
                break;
            end;
        end;
    end;
catch
    for i=1:m1
        o(i,1:2,1)=0;
        o(i,1:2,2)=0;
        o(i,1:2,3)=0;
        sub11 = 3;
        sub12 = 3;
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%检测右半图直线
BW1 = q2;
[m2,n2]=size(q2);
[H1,T1,R1] = hough(BW1,'Theta',-60:0.1:60);
Peaks=houghpeaks(H1,8);
lines=houghlines(BW1,T1,R1,Peaks);
k=length(lines);

try
    thetaright = zeros(1,3);
    rhoright = zeros(1,3);
    thetai = 1;
    rhoi = 1;
    firstrho = -1;
    for i=1:k
        if lines(i).rho ~= firstrho
            thetaright(thetai) = lines(i).theta;
            rhoright(rhoi) = lines(i).rho;
            firstrho = lines(i).rho;
            thetai = thetai+1;
            rhoi = rhoi+1;
            if rhoi==4
                break;
            end;
        end;
    end;
catch
    for i=1:m
        o(i,n-2:n,1)=0;
        o(i,n-2:n,2)=0;
        o(i,n-2:n,3)=0;
        sub21 = n-3;
        sub22 = n-3;
    end;
end;

%进行直线判断%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rholeft(1)>0 &&rhoright(1)>0
    corrnum = zeros(3,3);
    X = zeros(m1,40);
    Y = zeros(m1,40);
    for left=1:3
        for right=1:3
            if rholeft(left)>0 && rhoright(right)>0
                for i=1:m1
                    j = round((rholeft(left)-i*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
                    if j>=1 && j<=n1
                        X(i,:) = oo(i,j:j+39);
                    else
                        X(i,:) = oo(i,1:40);
                    end;
                    j = round((rhoright(right)-i*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180));
                    if j>=1 && j<=n2
                        Y(i,:) = oo(i,j+nn-39:j+nn);
                    else
                        Y(i,:) = oo(i,n2+nn-39:n2+nn);
                    end;
                end;
                Y = fliplr(Y);
                corrnum(left,right) = abs(corr2(X,Y));
            end;
        end;
    end;
    [B,I] = max(corrnum);
    [C,J] = max(B);
    left = I(J);
    right = J;
    
    kk11 = 0;
    kk12 = 0;
    for i=1:round(m1/2)
        j = round((rholeft(left)-i*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
        if j >= 1 && j<=n1 && q1(i,j)>0
            kk11 = kk11+1;
        end;
    end;
    for i=round(m1/2)+1:m1
        j = round((rholeft(left)-i*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
        if j >= 1 && j<=n1 && q1(i,j)>0
            kk12 = kk12+1;
        end;
    end;
    if kk11+kk12 >= 130
        for i=1:m1
            j = round((rholeft(left)-i*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
            if j >= 1 && j<=n1
                o(i,1:j,1) = 0;
                o(i,1:j,2) = 0;
                o(i,1:j,3) = 0;
            end
        end;
        sub11 = round((rholeft(left)-1*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
        sub12 = round((rholeft(left)-m1*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
    else
        if kk11>30*kk12
            for i=1:m1
                o(i,1:2,1)=0;
                o(i,1:2,2)=0;
                o(i,1:2,3)=0;
                sub11 = 3;
                sub12 = 3;
            end;
        else
            for i=1:m1
                j = round((rholeft(left)-i*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
                if j >= 1 && j<=n1
                    o(i,1:j,1) = 0;
                    o(i,1:j,2) = 0;
                    o(i,1:j,3) = 0;
                end
            end;
            sub11 = round((rholeft(left)-1*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
            sub12 = round((rholeft(left)-m1*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
        end;
    end;
    
    kk21 = 0;
    kk22 = 0;
    for i=1:round(m2/2)
        j = round((rhoright(right)-i*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180));
        if j >= 1 && j<=n2 && q2(i,j)>0
            kk21 = kk21+1;
        end
    end;
    for i=round(m2/2)+1:m2
        j = round((rhoright(right)-i*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180));
        if j >= 1 && j<=n2 && q2(i,j)>0
            kk22 = kk22+1;
        end
    end;
    if kk21+kk22>130
        for i=1:m1
            j = round((rhoright(right)-i*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180));
            if j >= 1 && j<=n2
                o(i,j+nn:n,1) = 0;
                o(i,j+nn:n,2) = 0;
                o(i,j+nn:n,3) = 0;
            end
        end;
        sub21 = round((rhoright(right)-1*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180))+nn;
        sub22 = round((rhoright(right)-m2*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180))+nn;
    else 
        if kk21>30*kk22
            for i=1:m1
                o(i,n-2:n,1)=0;
                o(i,n-2:n,2)=0;
                o(i,n-2:n,3)=0;
            end;
            sub21 = n-3;
            sub22 = n-3;
        else
            for i=1:m1
                j = round((rhoright(right)-i*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180));
                if j >= 1 && j<=n2
                    o(i,j+nn:n,1) = 0;
                    o(i,j+nn:n,2) = 0;
                    o(i,j+nn:n,3) = 0;
                end
            end;
            sub21 = round((rhoright(right)-1*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180))+nn;
            sub22 = round((rhoright(right)-m2*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180))+nn;
        end;
    end;
else
    try
        for i=1:m1
            j = round((rholeft(1)-i*sin(thetaleft(1)*pi/180))/cos(thetaleft(1)*pi/180));
            if j >= 1 && j<=n1
                o(i,1:j,1) = 0;
                o(i,1:j,2) = 0;
                o(i,1:j,3) = 0;
            end
        end;
        sub11 = round((rholeft(left)-1*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
        sub12 = round((rholeft(left)-m1*sin(thetaleft(left)*pi/180))/cos(thetaleft(left)*pi/180));
    catch
        for i=1:m1
            o(i,1:2,1)=0;
            o(i,1:2,2)=0;
            o(i,1:2,3)=0;
        end;
        sub11 = 3;
        sub12 = 3;
    end;
    try
        for i=1:m1
            j = round((rhoright(1)-i*sin(thetaright(1)*pi/180))/cos(thetaright(1)*pi/180));
            if j >= 1 && j<=n2
                o(i,j+nn:n,1) = 0;
                o(i,j+nn:n,2) = 0;
                o(i,j+nn:n,3) = 0;
            end
        end;
        sub21 = round((rhoright(right)-1*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180))+nn;
        sub22 = round((rhoright(right)-m2*sin(thetaright(right)*pi/180))/cos(thetaright(right)*pi/180))+nn;
    catch
        for i=1:m
            o(i,n-2:n,1)=0;
            o(i,n-2:n,2)=0;
            o(i,n-2:n,3)=0;
        end;
        sub21 = n-3;
        sub22 = n-3;
    end;
end;
sub111 = max(min(sub11,sub12),1);
sub222 = min(max(sub21,sub22),n);
s = o(:,sub111:sub222,:);
