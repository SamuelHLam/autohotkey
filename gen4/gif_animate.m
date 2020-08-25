% GIF flipping between two images
% 8-25-2020: handle grayscale images with optional output filename

function gif_animate (fn1, fn2, fnout)

if nargin < 2
    disp('need two image filenames')
    return
end

if nargin < 3
    fnout = 'test.gif';
end

% Capture the plot as an image
im1 = imread(fn1);
im1 = gray2color(im1);
image(im1);
axis image
axis off
title(fn1)
frame = getframe(gcf);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

% Write frames to the GIF File
imwrite(imind,cm,fnout,'gif','Loopcount',inf);

% Capture the plot as an image
im2 = imread(fn2);
im2 = gray2color(im2);
image(im2);
axis image
axis off
title(fn2)
frame = getframe(gcf);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

imwrite(imind,cm,fnout,'gif','WriteMode','append');

%
% convert a gray image to color
%
    function imout = gray2color (imin)
        if length(size(imin))==2
            imout = repmat(double(imin)/255,1,1,3);
        end
        return
    end
end