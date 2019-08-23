function gen2_reg (mov,fix)
% The three folders we want to put the outputs into
% r_path = 'reg_imgs\';
% dE_path = 'dE\';
% heatmap_path = 'heatmaps\';
r_path = '';
dE_path = '';
heatmap_path = '';

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
movingReg = registerImagesAffine(mov, fix);

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
colorbar('hide');
saveas(gcf, sprintf('%sheatmap-%s.png', heatmap_path, com_out));

return

end
