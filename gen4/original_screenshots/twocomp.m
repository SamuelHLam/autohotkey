% compare two cropped images
%
classdef twocomp < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        folder_name = {}
        n_folder = 0
        viewer1 = 'insight'
        viewer2 = 'insight'
        browser1 = 'chrome'
        browser2 = 'edge'
    end
    
    methods
        
        function obj = twocomp
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            allfile = dir;
            obj.n_folder = 0;
            for i = 1:size(allfile,1)
                if allfile(i).isdir && allfile(i).name(1)~='.'
                    obj.n_folder = obj.n_folder + 1;
                    obj.folder_name{obj.n_folder} = allfile(i).name;
                end
            end
            
            return
        end
        
        function pan_by_trim (obj, fin1, fin2, fout1, fout2, panx, pany)
            % 4-5-2020
            % panning by trimming
            
            % input filenames
            im1 = imread(fin1);
            im2 = imread(fin2);
            
            % use (x,y) for im1
            % use (u,v) for im2
            
            % map (x,y) to (u,v)
            x1 = 1 + panx;
            y1 = 1 + pany;
            x2 = size(im1,2) + panx;
            y2 = size(im1,1) + pany;
            
            % use (a,b) as crop points in im2
            a1 = max(x1,1);
            b1 = max(y1,1);
            a2 = min(x2,size(im2,2));
            b2 = min(y2,size(im2,1));
            
            % crop im1 in (x,y)
            imout1 = im1([b1:b2]-pany,[a1:a2]-panx,:);
            
            % crop im2
            imout2 = im2(b1:b2,a1:a2,:);
            
            % write the files
            imwrite(imout1,fout1)
            imwrite(imout2,fout2)
            
            return
        end
        
        function register_all (obj)
            % two viewers and browsers registered
            fn1 = sprintf('40x-%s-%s.png',obj.viewer1,obj.browser1);
            fn2 = sprintf('40x-%s-%s.png',obj.viewer2,obj.browser2);
            
            %for i = 1:obj.n_folder
            for i = 4
                
                fd = obj.folder_name{i};
                fname1 = sprintf('%s\\%s',fd,fn1);
                fname2 = sprintf('%s\\%s',fd,fn2);
                fnout = sprintf('%s-%s_%s-%s_dE_%02d.jpg',obj.viewer1,obj.browser1,obj.viewer2,obj.browser2,i);
                
                foutname1 = sprintf('%s\\%s-%s_t1.png',fd,obj.viewer1,obj.browser1);
                foutname2 = sprintf('%s\\%s-%s_t2.png',fd,obj.viewer2,obj.browser2);
                de2out = sprintf('%s\\%s',fd,fnout);
                
                if 0
                    % visualize
                    im1 = imread(fname1);
                    im2 = imread(fname2);
                    
                    imshowpair(im1,im2)
                    pause
                end
                
                t = register_images(fname2,fname1);
                sprintf('%s: %.4f %.4f %.4f %.4f',fd,t(1,1),t(2,2),t(3,1),t(3,2))
                
                panx = round(t(3,1))
                pany = round(t(3,2))
                obj.pan_by_trim(fname1,fname2,foutname1,foutname2,panx,pany)
                
                compare_roi(foutname1,foutname2);
                
                [dE2 dE] = image2dE2 (foutname1,foutname2,de2out);
            end
        end
        
        function two_show (obj)
            % generates png showing t1 and t2 side-by-side
            fn1 = sprintf('%s-%s_t1.png',obj.viewer1,obj.browser1);
            fn2 = sprintf('%s-%s_t2.png',obj.viewer2,obj.browser2);
            roi_xy = load('dataset_roi.mat','xy');
            
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fnout = sprintf('%s-%s_%s-%s_%02d.png',obj.viewer1,obj.browser1,obj.viewer2,obj.browser2,i);
                
                fname1 = sprintf('%s\\%s',fd,fn1);
                fname2 = sprintf('%s\\%s',fd,fn2);
                foutname12 = sprintf('%s\\%s',fd,fnout);
                
                imm1 = imread(fname1);
                imm2 = imread(fname2);
                
                %                 imfinfo(fname1)
                %                 imfinfo(fname2)
                
                % image size will be 2n by 2n pixels
                n = 225;
                roi_center_x = roi_xy.xy(i,1);
                roi_center_y = roi_xy.xy(i,2);
                roi_left = roi_center_x - n;
                roi_right = roi_center_x + n;
                roi_top = roi_center_y - n;
                roi_bottom = roi_center_y + n;
                
                % make sure roi remains within image boundaries
                if roi_left < 1
                    roi_right = roi_right - roi_left + 1;
                    roi_left = 1;
                end
                if roi_top < 1
                    roi_bottom = roi_bottom - roi_top + 1;
                    roi_top = 1;
                end
                if roi_right > size(imm1,1)
                    roi_left = roi_left - roi_right + size(imm1,1);
                    roi_right = size(imm1,1);
                end
                if roi_bottom > size(imm1,2)
                    roi_top = roi_top - roi_bottom + size(imm1,2);
                    roi_bottom = size(imm1,2);
                end
                
                % adjust by 1 to ensure 450x450 image
                im1 = imm1(roi_left:roi_right - 1,roi_top:roi_bottom - 1,:);
                im2 = imm2(roi_left:roi_right - 1,roi_top:roi_bottom - 1,:);
                
                im3 = im1;
                im3(1:2*n,[1:2*n]+2*n,:) = im2;
                imwrite(im3,foutname12);
                
            end
        end
        
        function roi_iterate (obj)
            xy = [];
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fnout = sprintf('dataset_roi');
                
                fn = sprintf('%s\\%s-%s_t1.png',fd,obj.viewer1,obj.browser1);
                temp = choose_roi(fn, 1);
                xy = [xy;temp];
            end
            save(fnout, 'xy');
        end
        
        function find_seam_one_iterate (obj)
            for i = 1:22
                [x,y] = obj.find_seam_one(sprintf('crop\\crop2_%02d.png',i));
            end
        end
        
        function [seam_x, seam_y] = find_seam_one (obj, fn1)
            %Find the seam in a single image
            
            % read the color image
            imm1 = imread(fn1);
            
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
            imwrite(imm2,['seam\\' name '_seam.png'])
            
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
            saveas(gcf,['seam\\' name '_corr.png']);
            
            return
        end
        
        function data = find_seam (obj, fn1, fn2)
            imm1 = imread(fn1);
            imm2 = imread(fn2);
            
            im1 = rgb2gray(imm1);
            im2 = rgb2gray(imm2);
            
            % win is the "window" of the range of lines to compare
            win = 5;
            
            data = zeros(size(im1,2),1);
            
            % the range of the moving window
            % handling the boundary conditions
            % start from 1+win to end-win
            % because the window size is 2*win+1
            for i=1+win:size(im1,2)-win
                
                % obtain one vertical line a time from im1
                col1 = im1(:,i);
                
                % obtain the windown from im2
                col_comp_window = im2(:,[i-win:i+win]);
                
                % create a matrix by combining the two
                col_matrix = [col1 col_comp_window];
                r = corrcoef(double(col_matrix));
                
                % find the maximum
                [mx ind] = max(r(2:end,1));
                
                % store the relative location
                data(i,1) = ind;
            end
            
            
            % condition the results
            % by filling in the start and end
            data(1:win,1) = data(win+1,1);
            data(end-win:end,1) = data(end-win-1,1);
            
            % show the curve
            plot(data)
            saveas(gcf,'find_seam_plot.png')
        end
        
        
        function animation_all (obj)
            % creates .gif switching between subject and predicate
            fn1 = sprintf('%s-%s_t1.png',obj.viewer1,obj.browser1);
            fn2 = sprintf('%s-%s_t2.png',obj.viewer2,obj.browser2);
            
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fname1 = sprintf('%s\\%s',fd,fn1);
                fname2 = sprintf('%s\\%s',fd,fn2);
                
                obj.animation(fname1,fname2,i);
            end
        end
        
        function animation (obj, fn1, fn2, i)
            
            fd = obj.folder_name{i};
            fnout = sprintf('%s-%s_%s-%s_%02d.gif',obj.viewer1,obj.browser1,obj.viewer2,obj.browser2,i);
            fn3 = sprintf('%s\\%s',fd,fnout);
            
            % Capture the plot as an image
            im1 = imread(fn1);
            image(im1);
            axis image
            axis off
            title('Predicate')
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            
            % Write frames to the GIF File
            imwrite(imind,cm,fn3,'gif','Loopcount',inf);
            
            % Capture the plot as an image
            im2 = imread(fn2);
            image(im2);
            axis image
            axis off
            title('Subject')
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            
            imwrite(imind,cm,fn3,'gif','WriteMode','append');
            
        end
    end
end

