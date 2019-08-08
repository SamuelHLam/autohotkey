% WCC 8/8/2019
% for Dorsa's registration problrm
function checkregistration (fn1,fn2)

im1 = imread(fn1);
im2 = imread(fn2);
imgray1 = rgb2gray(im1);
imgray2 = rgb2gray(im2);

if size(im1,1) ~= size(im2,1) || size(im1,2) ~= size(im2,2) || size(im1,3) ~= size(im2,3) 
    ['the size is wrong']
    return
end

im3 = uint8(zeros(size(im1,1),size(im1,2),size(im1,3)));
im3(:,:,1) = im1(:,:,1);
im3(:,:,2) = im1(:,:,2);
image(im3)
axis image
axis off

reg_accuracy = corr2(imgray1,imgray2)

title(sprintf('%s (red) vs %s (green), R=%.4f',fn1,fn2,reg_accuracy),'interpreter','none')

end
