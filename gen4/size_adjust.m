for i = 1:10
   fn = sprintf('%03d\\ndp.png',i)
   im = imread(fn);
   im2 = im(:,:,:);
   imwrite(im2,fn);
end
