% WCC 8/8/2019
% for Dorsa's registration problrm
function checkregistration (im1,im2)


imgray1 = rgb2gray(im1);
imgray2 = rgb2gray(im2);

% imdiff1 = abs(imgray1(:,1:end-1) - imgray1(:,2:end));
% image(imdiff1)
% colormap gray
% 
% return

if size(im1,1) ~= size(im2,1) || size(im1,2) ~= size(im2,2) || size(im1,3) ~= size(im2,3) 
    ['the size is wrong']
    return
end

im3 = uint8(zeros(size(im1,1),size(im1,2),size(im1,3)));
im3(:,:,1) = imgray1(:,:);
im3(:,:,2) = imgray2(:,:);
image(im3)
axis image
axis off

reg_accuracy = corr2(imgray1,imgray2)

title(sprintf('%s (red) vs %s (green), R=%.4f',im1,im2,reg_accuracy),'interpreter','none')

end
