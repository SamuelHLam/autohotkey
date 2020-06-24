imm1 = imread('t1.png');
imm2 = imread('t2.png');

im1 = rgb2gray(imm1);
im2 = rgb2gray(imm2);
win = 5;

data = zeros(size(im1,2),1);
for i=1+win:size(im1,2)-win
    col1 = im1(:,i);
    r = corrcoef(double([col1 im2(:,[i-win:i+win])]));
    [mx ind] = max(r(2:end,1));
    data(i,1) = ind;
end
