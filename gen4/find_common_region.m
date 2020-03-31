function box = find_common_region (fn1,fn2)
            
            % color images
            im1 = imread(fn1);
            im2 = imread(fn2);
            
            % 2D to 1D
            imlin1 = reshape(im1,size(im1,1)*size(im1,2),3);
            imlin2 = reshape(im2,size(im2,1)*size(im2,2),3);
            
            % to CIELAB
            lab1 = rgb2lab(imlin1);
            lab2 = rgb2lab(imlin2);
            
            % color difference
            dE = sum((lab1-lab2).^2,2).^0.5;

            % 2D
            dE2 = reshape(dE,size(im1,1),size(im1,2));
            
            if 1
            % visualize
            clf
            imagesc(dE2)
            colormap hsv
            colorbar
            saveas(gcf,'dE2.png')
            end
            
            % analyze it
            col = mean(dE2,1);
            row = mean(dE2,2);
            
            if 0
            % visualize
            subplot(2,1,1)
            plot(col)
            subplot(2,1,2)
            plot(row)
            end
            
            % use 20 dE as the threshold
            th = 15; % for sedeen
            th = 25; % for qupath

            x1 = min(find(col<th));
            x2 = max(find(col<th));
            y1 = min(find(row<th));
            y2 = max(find(row<th));
            
            box = [x1 y1 x2 y2];
            
            return
            
end
        