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
    
        