fn = 'dE_sedeen-ndpview2.mat'
load(fn,'dE')

imagesc(dE)

caxis([0 30]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 1200 1200]);
saveas(gcf, 'whole.png');

tile1 = dE(1:11, : );
imagesc(tile1)

caxis([0 30]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 1200 44]);
saveas(gcf, 'tile1.png');

tile2 = dE(11:270, : );
imagesc(tile2)

caxis([0 30]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 1200 777]);
saveas(gcf, 'tile2.png');

tile3 = dE(270:400, : );
imagesc(tile3)

caxis([0 30]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 1200 390]);
saveas(gcf, 'tile3.png');

% ndp = imread('r_ndpview2.png');
% sedeen = imread('r_sedeen.png');
% 
% ndp = ndp(11:270, 1:400, :);
% sedeen = sedeen(11:270, 1:400, :);
% 
% imwrite(ndp, 'test_ndp.png');
% imwrite(sedeen, 'test_sedeen.png');