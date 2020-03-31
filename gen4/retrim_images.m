% 3-25-2020
% trim two images based on their common region
% two images from printscr -- including the application menu

function retrim_images (fn1, fn2, fnout1, fnout2, i)

im1 = imread(fn1);
im2 = imread(fn2);

size1 = size(im1,1);
size2 = size(im1,2);

shiftrow = floor(i/3) - 1;
shiftcol = mod(i,3) - 1;

rangerow = [2:size1-1];
rangecol = [2:size2-1];

j1 = im1(rangerow,rangecol,:);
j2 = im2(rangerow+shiftrow,rangecol+shiftcol,:);

imwrite(j1,fnout1);
imwrite(j2,fnout2);

return

end
