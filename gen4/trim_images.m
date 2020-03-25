% 3-25-2020
% trim two images based on their common region
% two images from printscr -- including the application menu

function trim_images (fn1, fn2, fnout1, fnout2)

box = find_common_region(fn1, fn2);

im1 = imread(fn1);
im2 = imread(fn2);

im1_trim = im1(box(1):box(3),box(2):box(4),:);
im2_trim = im2(box(1):box(3),box(2):box(4),:);

imwrite(im1_trim,fnout1);
imwrite(im2_trim,fnout2);

return

end
