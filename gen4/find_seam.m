%Find the seam in a single image
folder = "079";
fn1 = strcat(folder,"\\sedeen1.png");

% read the color image
imm1 = imread(fn1);

imm1 = imm1(35:size(imm1,1)-25, :, :);

% get dimensions 
n_col = size(imm1,2);
n_row = size(imm1,1);

% convert to CIELAB
lab1 = rgb2lab(imm1);

% find correlation coefficients for columns
r1 = corrcoef(double(lab1(:,:,1)));
r2 = corrcoef(double(lab1(:,:,2)));
r3 = corrcoef(double(lab1(:,:,3)));

% rotate to find horizontal seams
lab2 = permute(lab1,[2 1 3]);

% find correlation coefficients for rows
v1 = corrcoef(double(lab2(:,:,1)));
v2 = corrcoef(double(lab2(:,:,2)));
v3 = corrcoef(double(lab2(:,:,3)));

% retrieve the correlation coefficient for each pair of
% adjacent columns

data = zeros(n_col-1,3);

% remove the top row and the right column
% and then retrieve the diagonal
data(:,1) = diag(r1(2:end,1:end-1));
data(:,2) = diag(r2(2:end,1:end-1));
data(:,3) = diag(r3(2:end,1:end-1));
data_prod = data(:,1).*data(:,2).*data(:,3);

data2 = zeros(n_row-1,3);

% remove the top row and the right column
% and then retrieve the diagonal
data2(:,1) = diag(v1(2:end,1:end-1));
data2(:,2) = diag(v2(2:end,1:end-1));
data2(:,3) = diag(v3(2:end,1:end-1));
data2_prod = data2(:,1).*data2(:,2).*data2(:,3);

[m seam_x] = min(data_prod);
[m seam_y] = min(data2_prod);

% annotate
imm2 = imm1;
markercolor = [255 128 40]; % orange
markercolor = [0 0 255]; % orange
for j = -50:+50
    imm2(seam_y,max(min(seam_x+j,n_col),1),1:3) = markercolor;
    imm2(max(min(seam_y+j,n_row),1),seam_x,1:3) = markercolor;
end

% save the annotated image
[filepath,name,ext] = fileparts(fn1);
imwrite(imm2,strcat(folder, '\\', name, '_seam.png'))

clf
subplot(4,4,[1:3 5:7 9:11])
image(imm2)

subplot(4,4,[13:15])
hold on
plot(data(:,1)-0)
plot(data(:,2)-0.1)
plot(data(:,3)-0.2)
plot(data_prod-0.3)
axis([1 n_col 0.5 1.1])
axis off

subplot(4,4,[4 8 12])
hold on
plot(data2(:,1)-0,n_row-1:-1:1)
plot(data2(:,2)-0.1,n_row-1:-1:1)
plot(data2(:,3)-0.2,n_row-1:-1:1)
plot(data2_prod-0.3,n_row-1:-1:1)
axis([0.5 1.1 1 n_row])
axis off

[filepath,name,ext] = fileparts(fn1);
saveas(gcf,strcat(folder, '\\', name, '_corr.png'));

return