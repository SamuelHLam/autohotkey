% Q: try semi-auto registration
% 

%https://support.microsoft.com/en-hk/help/14204/windows-7-use-mouse-keys-to-move-mouse-pointer
%

im = imread('Capture.PNG');

image(im)

fullx = 1920;
fully = 1200;

leftx = fullx/2 - fullx/4;
lefty = fully/2;

rightx = fullx/2 + fullx/4;
righty = fully/2;

halfsidex = 400;
halfsidey = 400;

im1 = crop(im,leftx,lefty,halfsidex,halfsidey);

im2 = crop(im,rightx,righty,halfsidex,halfsidey);

subplot(1,2,1)
image(im1)
axis image

subplot(1,2,2)
image(im2)
axis image

return



function im2 = crop (im, centerx, centery, halfsidex, halfsidey)

    im2 = im([centery-halfsidey:centery+halfsidey],[centerx-halfsidex:centerx+halfsidex],:);

end
