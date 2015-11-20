train_dir = 'pics/train/';
target_dir = 'pics/train_expanded/';

try
    mkdir(target_dir)
catch
end

fp = fopen('train_class.txt', 'w');
train_imgs = dir(train_dir);
alphabet = 'abcdefghijklmn';

for i = 1:length(train_imgs)-2
    i
    name = train_imgs(i+2).name;
    im = imread([train_dir name]);
    ims = expand_image(im);
    imwrite(ims{1}, [target_dir name(1:end-4) 'a' '.jpg'], 'JPEG');
    imwrite(ims{2}, [target_dir name(1:end-4) 'b' '.jpg'], 'JPEG');
    imwrite(ims{3}, [target_dir name(1:end-4) 'c' '.jpg'], 'JPEG');
    imwrite(ims{4}, [target_dir name(1:end-4) 'd' '.jpg'], 'JPEG');
    imwrite(ims{5}, [target_dir name(1:end-4) 'e' '.jpg'], 'JPEG');
    imwrite(ims{6}, [target_dir name(1:end-4) 'f' '.jpg'], 'JPEG');
    imwrite(ims{7}, [target_dir name(1:end-4) 'g' '.jpg'], 'JPEG');
    imwrite(ims{8}, [target_dir name(1:end-4) 'h' '.jpg'], 'JPEG');
    imwrite(ims{9}, [target_dir name(1:end-4) 'i' '.jpg'], 'JPEG');
    imwrite(ims{10}, [target_dir name(1:end-4) 'j' '.jpg'], 'JPEG');
    imwrite(ims{11}, [target_dir name(1:end-4) 'k' '.jpg'], 'JPEG');
    imwrite(ims{12}, [target_dir name(1:end-4) 'l' '.jpg'], 'JPEG');
    imwrite(ims{13}, [target_dir name(1:end-4) 'm' '.jpg'], 'JPEG');
    imwrite(ims{14}, [target_dir name(1:end-4) 'n' '.jpg'], 'JPEG');
    for j = alphabet
        fprintf(fp, '%s%s.jpg %d\n', name(1:end-4), j, i-1); 
    end
end

fp.close();
