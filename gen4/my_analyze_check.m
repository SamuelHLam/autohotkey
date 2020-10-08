% compare all ROIs
% revisit 5-31-2020: what is this??

obj = Viewer;

n_roi = size(obj.wsi_roi,1);

for i = 1:n_roi
    
    % define filenames
    fn1 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'retrim1.png');
    fn2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'retrim2.png');
    
    opt = image_shift(fn1, fn2)
    % image_corrcoef(fn1, fn2)
    
    fn1 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'trim1.png');
    fn2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'trim2.png');
    fnn1 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'trimsmall1.png');
    fnn2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'trimsmall2.png');
    im1 = imread(fn1);
    im2 = imread(fn2);
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
    imwrite(im1(1:500,1:500),fnn1);
    imwrite(im2(1:500,1:500),fnn2);

    fn1 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'retrim1.png');
    fn2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'retrim2.png');
    fnn1 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'retrimsmall1.png');
    fnn2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'retrimsmall2.png');
    im1 = imread(fn1);
    im2 = imread(fn2);
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
    imwrite(im1(1:500,1:500),fnn1);
    imwrite(im2(1:500,1:500),fnn2);
    
end
