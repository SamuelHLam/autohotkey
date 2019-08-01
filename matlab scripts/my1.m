fn1 = 'qupath.png';
fn2 = 'ndpview2.png';
fn1_out = ['r_' fn1]
fn2_out = ['r_' fn2]


fn_reg = 'mtreg.mat';

qupath = imread(fn1);
ndp = imread(fn2);

movingReg = registerImages(qupath, ndp);

movingReg.Transformation.T
save(fn_reg,'movingReg')

[r_ndp, r_qupath] = ImageRegistration(fn1,fn2,fn_reg);
quality = registrationQualityEvaluationVariable(r_ndp, r_qupath)

imwrite(r_ndp, fn1_out)
imwrite(r_qupath, fn2_out)
dE = compareColorFunction_LAB(fn1_out, fn2_out);

load('dE','diffMatrix')

surf(diffMatrix)

return

