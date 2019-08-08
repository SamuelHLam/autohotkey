% by WCC 
% 8-8-2019
% to clarify that in the poster the dE was not calculated based on L* only

function my1 (fn1, fn2, name)

colorbar_range = [0 40];

im1 = imread(fn1);
im2 = imread(fn2);

lab1 = rgb2lab(im1,'colorspace','srgb','whitepoint','d65');
lab2 = rgb2lab(im2,'colorspace','srgb','whitepoint','d65');

lab1_lin = reshape(lab1,size(lab1,1)*size(lab1,2),3);
lab2_lin = reshape(lab2,size(lab2,1)*size(lab2,2),3);

diff_L_lin = abs(lab1_lin(:,1)-lab2_lin(:,1)); 
diff_a_lin = abs(lab1_lin(:,2)-lab2_lin(:,2)); 
diff_b_lin = abs(lab1_lin(:,3)-lab2_lin(:,3)); 

diff_L = reshape(diff_L_lin,size(lab1,1),size(lab1,2));
diff_a = reshape(diff_a_lin,size(lab1,1),size(lab1,2));
diff_b = reshape(diff_b_lin,size(lab1,1),size(lab1,2));

de_lin = sum((lab1_lin - lab2_lin).^2,2).^0.5;
de = reshape(de_lin,size(lab2,1),size(lab2,2));

the_corr_is = corrcoef(lab1_lin(:,1),lab2_lin(:,1))
the_mean_is = mean(de_lin)
the_std_is = std(de_lin)

figure('units','normalized','outerposition',[0 0 1 1])

subplot(2,4,1)
image(im1)
axis image
axis off
title(fn1,'Interpreter','none')

subplot(2,4,2)
image(im2)
axis image
axis off
title(fn2,'Interpreter','none')

subplot(2,4,3)
histogram(de_lin)
axis square
axis([0 50 0 10000])
xlabel('dE')
ylabel('Count')
str = sprintf('\\mu=%.2f,\\sigma=%.2f',mean(de_lin),std(de_lin));
title(str)

subplot(2,4,5)
de_flipped = flip(de,1);
%mesh(de_flipped)
imagesc(de_flipped)
axis image
axis off
colorbar('southoutside')
caxis(colorbar_range)
view(0,90)
title('Color Difference dE')

subplot(2,4,6)
diff_L_flipped = flip(diff_L,1);
%mesh(diff_L_flipped)
imagesc(diff_L_flipped)
axis image
axis off
colorbar('southoutside')
caxis(colorbar_range)
view(0,90)
title('CIE L* difference')

subplot(2,4,7)
diff_a_flipped = flip(diff_a,1);
%mesh(diff_a_flipped)
imagesc(diff_a_flipped)
axis image
axis off
colorbar('southoutside')
caxis(colorbar_range)
view(0,90)
title('CIE a* difference')

subplot(2,4,8)
diff_b_flipped = flip(diff_b,1);
%mesh(diff_b_flipped)
imagesc(diff_b_flipped)
axis image
axis off
colorbar('southoutside')
caxis(colorbar_range)
view(0,90)
title('CIE b* difference')

subplot(2,4,4)
hold on
plot3(lab1(:,2),lab1(:,3),lab1(:,1),'.r')
plot3(lab2(:,2),lab2(:,3),lab2(:,1),'.b')
legend({fn1,fn2},'interpreter','none')
grid on
xlabel('CIE a*')
ylabel('CIE b*')
zlabel('CIE L*')
view(-77,10)

saveas(gcf,sprintf('%s.tif',name))
end
