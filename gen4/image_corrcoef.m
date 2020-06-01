
function ret = image_corrcoef (fn_target, fn_trial)

imtarget = imread(fn_target);
imtrial = imread(fn_trial);

im1 = rgb2gray(imtarget);
im2 = rgb2gray(imtrial);

ret = corr2(im1,im2);

end
