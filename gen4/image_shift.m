
function opt = image_shift (fn1, fn2)

im1 = imread(fn1);
im2 = imread(fn2);

im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

size1 = size(im1,1);
size2 = size(im1,2);

opt_i = -1;
opt_r = 0;

for i = 0:8
    
    shiftrow = floor(i/3) - 1;
    shiftcol = mod(i,3) - 1;
    
    rangerow = [2:size1-1];
    rangecol = [2:size2-1];
    
    j1 = im1(rangerow,rangecol,:);
    j2 = im2(rangerow+shiftrow,rangecol+shiftcol,:);
    
    r = corr2(j1,j2);
    
    % [i r]

    if r > opt_r
        opt_r = r;
        opt_i = i;
    end
end

opt = [opt_i opt_r];

end