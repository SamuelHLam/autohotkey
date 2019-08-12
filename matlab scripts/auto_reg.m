% Input: 4 images named "qupath.png", "asap.png", "sedeen.png", and
% "ndpview2.png"

% Output: 4 registered images, 6 files containing dE information, 6
% heatmaps
f0 = 'qupath';
f1 = 'asap';
f2 = 'sedeen';
f3 = 'ndpview2';

% Keep a log containing the transformation matrices and registration
% correlations
diary log.txt

% Crop the NDP.view 2 screenshot to show a smaller area (makes registering
% all 6 images easier)
ndp = imread('ndpview2.png');
movefile('ndpview2.png', 'raw_ndpview2.png');
ndp_crop = imcrop(ndp, [750, 330, 400, 400]);
imwrite(ndp_crop, 'ndpview2.png');

% Registers every other image to NDP
reg_func(f0, f3)
reg_func(f1, f3)
reg_func(f2, f3)

% This allows us to use the registered Sedeen screenshot as the fixed image
% for the next two registrations
movefile('sedeen.png', 'raw_sedeen.png');
movefile('reg_imgs\r_sedeen.png', 'sedeen.png');

reg_func(f0, f2)
reg_func(f1, f2)

% Finally, we want to use the registered ASAP screenshot as the fixed image
% in the last registration
movefile('asap.png', 'raw_asap.png');
movefile('reg_imgs\r_asap.png', 'asap.png');

reg_func(f0, f1)

% Cleaning up files (the deleted files can already be found in the reg_imgs
% directory
delete asap.png;
delete sedeen.png;
delete ndpview2.png;
movefile('raw_asap.png', 'asap.png');
movefile('raw_sedeen.png', 'sedeen.png');
movefile('raw_ndpview2.png', 'ndpview2.png');

diary off

function reg_func (mov,fix)
% The three folders we want to put the outputs into
r_path = 'reg_imgs\';
dE_path = 'dE\';
heatmap_path = 'heatmaps\';

% File names of the unregistered images
fn1 = sprintf('%s.png', mov)
fn2 = sprintf('%s.png', fix)

% File names of the registered images (add r_ in front)
fn1_reg = sprintf('%sr_%s', r_path, fn1);
fn2_reg = sprintf('%sr_%s', r_path, fn2);

% String used in output files that contains both file names combined (used
% for dE files and heatmaps)
com_out = sprintf('%s-%s', mov, fix);

% Color bar parameter
max_color = 30;

% Reads in moving and fixed images
mov = imread(fn1);
fix = imread(fn2);

% Generates transformation matrix
movingReg = registerImages(mov, fix);

% Displays transformation matrix
t_matrix = movingReg.Transformation.T

% Registers images according to transformation matrix
[r_mov, r_fix] = ImageRegistration(fn1,fn2,movingReg);

% Calculates correlation between registered images
checkregistration(r_mov, r_fix)

% Saves images
imwrite(r_mov, fn1_reg);
imwrite(r_fix, fn2_reg);

% Plots heatmap
dE = compareColorFunction_LAB(fn1_reg, fn2_reg);

% Saves dE information
save(sprintf('%sdE_%s.mat', dE_path, com_out),'dE');

% Heatmap parameters
caxis([0 max_color]);
set(gca,'visible','off');
set(gca,'xtick',[]);
set(gcf,'Position',[0 0 flip(size(dE))]);
saveas(gcf, sprintf('%sheatmap-%s.png', heatmap_path, com_out));

return

end
