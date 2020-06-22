imm1 = imread('t1.png');
imm2 = imread('t2.png');
n = 500;
im1 = imm1(1:n,1:n,:);
im2 = imm2(1:n,1:n,:);
montage({im1,im2});
saveas(gcf,'t12.png');