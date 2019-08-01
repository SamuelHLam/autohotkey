fn1 = 'qupath.png';
fn2 = 'asap.png';
fn1_out = ['r_' fn1];
fn2_out = ['r_' fn2];


fn_reg = 'mtreg.mat';

qupath = imread(fn1);
ndp = imread(fn2);

movingReg = registerImages(qupath, ndp);

movingReg.Transformation.T
save(fn_reg,'movingReg')

[r_mov, r_fix] = ImageRegistration(fn1,fn2,fn_reg);
quality = registrationQualityEvaluationVariable(r_mov, r_fix)

imwrite(r_mov, fn1_out)
imwrite(r_fix, fn2_out)
dE = compareColorFunction_LAB(fn1_out, fn2_out);

caxis([0 60])
set(gca,'visible','off')
set(gca,'xtick',[])
set(gcf,'Position',[0 0 flip(size(dE))])
saveas(gcf, sprintf('%s%s',fn1,fn2))
return

load('dE','diffMatrix')

surf(diffMatrix)

return

