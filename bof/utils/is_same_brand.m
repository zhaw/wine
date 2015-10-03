function [x]=is_same_brand(s1, s2)

n1=size(s1,2); n2=size(s2,2);
if ~n1 || ~n2
    x = 0;
    return
end
tmp=zeros(n1,n2);
for i1 = 1:n1
    if s1(i1) == s2(1)
        tmp(i1:end,1) = 1;
        break
    end
end
for i2 = 1:n2
    if s2(i2) == s1(1)
        tmp(1,i2:end) = 1;
        break
    end
end
for i1 = 2:n1
    for i2 = 2:n2
        if s1(i1) == s2(i2)
            tmp(i1,i2) = max([tmp(i1-1,i2-1)+1,tmp(i1-1,i2),tmp(i1,i2-1)]);
        else
            tmp(i1,i2) = max([tmp(i1-1,i2-1),tmp(i1-1,i2),tmp(i1,i2-1)]);
        end
    end
end
if tmp(n1,n2) > 0.75 * min([n1,n2])
    x = 1;
else
    x = 0;
end

end