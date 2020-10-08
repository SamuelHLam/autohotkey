% For adjusting image size for Samuel's display, which reports odd
% dimensions
for i = 1:10
   fn = sprintf('%03d\\ndp.png',i)
   im = imread(fn);
   
   % modify the image dimensions here
   im2 = im(:,:,:);
   
   imwrite(im2,fn);
end
