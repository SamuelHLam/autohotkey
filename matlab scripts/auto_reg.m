f0 = 'qupath';
f1 = 'asap';
f2 = 'sedeen';
f3 = 'ndpview2';

%ndp = imread('ndpview2.png');
%ndp_crop = imcrop(ndp, [750, 330, 400, 400]);
%imwrite(ndp_crop, 'ndpview2.png');

reg_func(f0, f3)
reg_func(f1, f3)
reg_func(f2, f3)

f2 = 'r_sedeen';

reg_func(f0, f2)
reg_func(f1, f2)

f1 = 'r_asap';

reg_func(f0, f1)
