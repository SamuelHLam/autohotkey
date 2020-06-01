% 4-4-2020
% WCC
% manually choose a set of ROI locations
% by clicking on the image
% fn: image file
% n: number of ROIs
% xy: k*2 matrix of (x,y)
% example
% xy = choose_roi('finding_half_pixel.png',10);

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
image(im)

for i = 1:n
    [x,y,button] = ginput(1)
    xy(i,1:2) = round([x y]);
end

end

