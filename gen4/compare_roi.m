% 3-25-2020
% compare images from two viewers

function compare_roi (fn1, fn2)

[filepath,name,ext] = fileparts(fn1);

fnout1 = sprintf('%s\\%s',filepath,'trim1.png');
fnout2 = sprintf('%s\\%s',filepath,'trim2.png');
fnretrim1 = sprintf('%s\\%s',filepath,'retrim1.png');
fnretrim2 = sprintf('%s\\%s',filepath,'retrim2.png');
de2out = sprintf('%s\\%s',filepath,'dE2.png');
matout = sprintf('%s\\%s',filepath,'de.mat');

trim_images (fn1, fn2, fnout1, fnout2);

opt = image_shift (fnout1, fnout2)

retrim_images (fnout1, fnout2, fnretrim1, fnretrim2, opt(1));

[dE2 dE] = image2dE2 (fnretrim1,fnretrim2,de2out);

save(matout,'dE2','dE')

end

