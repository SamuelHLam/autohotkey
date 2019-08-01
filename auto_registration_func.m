%fn1 = 'qupath.png';
%fn2 = 'asap.png';

function auto_registration_func (f1,f2, name)

fn1 = sprintf('%s.png',f1)
fn2 = sprintf('%s.png',f2)

fn1_out = ['r_' fn1];
fn2_out = ['r_' fn2];

fn_reg = 'mtreg.mat';

mov = imread(fn1);
fix = imread(fn2);

movingReg = registerImages(mov, fix);

movingReg.Transformation.T
save(fn_reg,'movingReg')

[r_mov, r_fix] = ImageRegistration(fn1,fn2,fn_reg);
quality = registrationQualityEvaluationVariable(r_mov, r_fix)

imwrite(r_mov, fn1_out)
imwrite(r_fix, fn2_out)
dE = compareColorFunction_LAB(fn1_out, fn2_out);

save(sprintf('dE_%s.mat',name),'dE')

caxis([0 30])
set(gca,'visible','off')
set(gca,'xtick',[])
set(gcf,'Position',[0 0 flip(size(dE))])
saveas(gcf, sprintf('%s.png',name))

return

% load('dE','diffMatrix')

% surf(diffMatrix)

return

end
