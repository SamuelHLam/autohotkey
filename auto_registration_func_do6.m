f0 = 'qupath';
f1 = 'asap';
f2 = 'sedeen';
f3 = 'ndpview2';

ndp = imread('ndpview2.png');
ndp_crop = imcrop(ndp, [750, 330, 400, 400]);
imwrite(ndp_crop, 'ndpview2.png');

auto_registration_func(f0, f3, 'QuPath-NDP')
auto_registration_func(f1, f3, 'ASAP-NDP')
auto_registration_func(f2, f3, 'Sedeen-NDP')

f2 = 'r_sedeen';
auto_registration_func(f0, f2, 'QuPath-Sedeen')
auto_registration_func(f1, f2, 'ASAP-Sedeen')

f1 = 'r_asap';
auto_registration_func(f0, f1, 'QuPath-ASAP')
