function [] = set_value( hObj,k )
% For recording mouse click in show.m
global is_right;
is_right(k) = 1-is_right(k);

if is_right(k)
    set(hObj, 'alphaData', 0.25);
else
    set(hObj, 'alphaData', 1);
end
end

