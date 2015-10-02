a = load('../file_brand_map.mat');
map = a.map;
result = load('result');
result = result.result;
posi = cell(1,2);
nega = cell(1,2);
posi_n = 1;
nega_n = 1;
right = 0;
global is_right;
f = cell(5,1);
for k = 1:5
    f{k} = @(hObj,~)set_value(hObj,k);
end
for j = 1:10
    map(result{j,1})
    map(result{j,2})
    if is_same_brand(map(result{j,1}), map(result{j,2}))
        right = right+1;
    end
    subplot(2,3,1)
    im = imread(['pics/test2_cutted/' result{j,1} '.png']);
    imshow(im);
    for k = 1:5
        subplot(2,3,k+1)
        im = imread(['pics/train/' result{j,k+1} '.jpg']);
        ax = imshow(im);
        set(ax,'ButtonDownFcn',f{k}, 'PickableParts','all');
    end
    is_right = zeros(5,1);
    pause
    for k = 1:5
        if is_right(k)
            posi{posi_n,1} = result{j,1};
            posi{posi_n,2} = result{j,k+1};
            posi_n = posi_n+1;
        else
            nega{nega_n,1} = result{j,1};
            nega{nega_n,2} = result{j,k+1};
            nega_n = nega_n+1;
        end
    end
end
data = {posi,nega};
save true_false_match data
right