f0 = 'qupath';
f1 = 'asap';
f2 = 'sedeen';
f3 = 'ndpview2';

ndp = imread('ndpview2.png');
movefile('ndpview2.png', 'raw_ndpview2.png');
ndp_crop = imcrop(ndp, [750, 330, 400, 400]);
imwrite(ndp_crop, 'ndpview2.png');

reg_func(f0, f3)
reg_func(f1, f3)
reg_func(f2, f3)

movefile('sedeen.png', 'raw_sedeen.png');
movefile('reg_imgs\r_sedeen.png', 'sedeen.png');

reg_func(f0, f2)
reg_func(f1, f2)

movefile('asap.png', 'raw_asap.png');
movefile('reg_imgs\r_asap.png', 'asap.png');

reg_func(f0, f1)

function reg_func (mov,fix)
r_path = 'reg_imgs\';
dE_path = 'dE\';
heatmap_path = 'heatmaps\';

fn1 = sprintf('%s.png', mov)
fn2 = sprintf('%s.png', fix)
fn1_reg = sprintf('%sr_%s', r_path, fn1);
fn2_reg = sprintf('%sr_%s', r_path, fn2);
com_out = sprintf('%s-%s', mov, fix);
max_color = 30;

mov = imread(fn1);
fix = imread(fn2);

movingReg = registerImages(mov, fix);

t_matrix = movingReg.Transformation.T

[r_mov, r_fix] = ImageRegistration(fn1,fn2,movingReg);
checkregistration(r_mov, r_fix)

imwrite(r_mov, fn1_reg);
imwrite(r_fix, fn2_reg);
dE = compareColorFunction_LAB(fn1_reg, fn2_reg);

save(sprintf('%sdE_%s.mat', dE_path, com_out),'dE');

caxis([0 max_color]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 flip(size(dE))]);
saveas(gcf, sprintf('%sheatmap-%s.png', heatmap_path, com_out));

return

end
