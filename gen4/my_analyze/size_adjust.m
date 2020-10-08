for i = 1:100
        fn = sprintf('%03d\\ndp.png',i);
        im = imread(fn);
        im2 = im(1:1080,1:1920,:);
        imwrite(im2,fn);
end
