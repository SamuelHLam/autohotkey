% GIF flipping between two images
folder = "079";
fn1 = strcat(folder, "\\ndp1.png");
fn2 = strcat(folder, "\\sedeen1_seam.png");
fn3 = strcat(folder, "\\ndp1-sedeen1.gif");
% Capture the plot as an image
im1 = imread(fn1);
im1 = im1(35:size(im1,1)-25, :, :);
im1 = im1(400:700, 400:700, :);
image(im1);
axis image
axis off
title('Predicate')
frame = getframe(gcf);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

% Write frames to the GIF File
imwrite(imind,cm,fn3,'gif','Loopcount',inf);

% Capture the plot as an image
im2 = imread(fn2);
% im2 = im2(35:size(im2,1)-25, :, :);
im2 = im2(400:700, 400:700, :);
image(im2);
axis image
axis off
title('Subject')
frame = getframe(gcf);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

imwrite(imind,cm,fn3,'gif','WriteMode','append');