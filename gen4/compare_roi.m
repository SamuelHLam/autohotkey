% 3-25-2020
% compare images from two viewers

function compare_roi (fn1, fn2)

fnout1 = 'trim1.png';
fnout2 = 'trim2.png';

trim_images (fn1, fn2, fnout1, fnout2);

image2dE2 (fnout1,fnout2);

end