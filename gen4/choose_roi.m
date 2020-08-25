% Manually choose a set of ROI locations on an given image
% by clicking on the image
% fn: image file
% n: number of ROIs
% xy: k*2 matrix of (x,y)
% example
% xy = choose_roi('finding_half_pixel.png',10);
% 7-27-2020 revisit
% 4-4-2020
% WCC

function xy = choose_roi (fn, n)

% required to get the correct coordinates inside the image
figure('Units','inches','PaperPositionMode','auto');
% set(gca,...
%     'Units','normalized',...
%     'Position',[.15 .2 .75 .7],...
%     'FontUnits','points',...
%     'FontWeight','normal',...
%     'FontSize',9,...
%     'FontName','Arial');

% show the image
im = imread(fn);
h = size(im, 1);
w = size(im, 2);
image(im)

for i = 1:n
    [x,y,button] = ginput(1)
    % normalize to [0,1]
    xy(i,1:2) = [x/h y/w];
end

end

