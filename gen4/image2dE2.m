% 3-25-2020
% computer the dE between two image files
% return the two-dimensional dE and save the result as an image
function [dE2 dE] = image2dE2 (fn1,fn2,de2out)

% color images
im1 = imread(fn1);
im2 = imread(fn2);

% 2D to 1D
imlin1 = reshape(im1,size(im1,1)*size(im1,2),3);
imlin2 = reshape(im2,size(im2,1)*size(im2,2),3);

% to CIELAB
lab1 = rgb2lab(imlin1);
lab2 = rgb2lab(imlin2);

% color difference
dE = sum((lab1-lab2).^2,2).^0.5;

% 2D
dE2 = reshape(dE,size(im1,1),size(im1,2));

% visualize
imagesc(dE2)
axis image
axis off

colormap parula
colorbar
saveas(gcf,de2out)

return

end
