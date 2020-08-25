% GIF flipping between two images
function gif_animate (fn1, fn2)

fn3 = 'test.gif'

% Capture the plot as an image
im1 = imread(fn1);
image(im1);
axis image
axis off
title(fn1)
frame = getframe(gcf);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

% Write frames to the GIF File
imwrite(imind,cm,fn3,'gif','Loopcount',inf);

% Capture the plot as an image
im2 = imread(fn2);
image(im2);
axis image
axis off
title(fn2)
frame = getframe(gcf);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

imwrite(imind,cm,fn3,'gif','WriteMode','append');
end