function registration_func (mov,fix)

fn1 = sprintf('%s.png',mov)
fn2 = sprintf('%s.png',fix)
fn1_reg = sprintf('r_%s', fn1);
fn2_reg = sprintf('r_%s', fn2);
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

save(sprintf('dE_%s.mat', com_out),'dE');

caxis([0 max_color]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 flip(size(dE))]);
saveas(gcf, sprintf('heatmap-%s.png',com_out));

return

end
