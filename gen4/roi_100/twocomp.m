% compare two cropped images
%
% 7-9-2020: for round 3

classdef twocomp < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        folder_name = {}
        n_folder = 0
        viewer1 = 'ims-1'
        viewer2 = 'insight'
        browser1 = 'chrome'
        browser2 = 'chrome'
        mag1 = '40x'
        mag2 = '40x'
        deltaE = {} 
        four_dE   % percentage of >= 4 dE
        dE4_GE    % >= 4 dE vs. < 4 dE
        ROI_xy
    end
    
    methods
        
        function obj = twocomp
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            allfile = dir;
            obj.n_folder = 0;
            for i = 1:size(allfile,1)
                if allfile(i).isdir && allfile(i).name(1)~='.'
                    if strncmpi(allfile(i).name,'RA',2) || strncmpi(allfile(i).name,'HoBI20-',7)
                        obj.n_folder = obj.n_folder + 1;
                        slide_name = allfile(i).name;
                        obj.folder_name{obj.n_folder} = sprintf('%s\\%s',slide_name,slide_name);
                    end
                end
            end
            
            
            % calculate dE for all 22 folders
            obj.dE_all;
            
            return
        end
        
        
        function two_show (obj)
            % generates png showing t1 and t2 side-by-side
            fn1 = obj.construct_name(obj.mag1,obj.viewer1,obj.browser1);
            fn2 = obj.construct_name(obj.mag2,obj.viewer2,obj.browser2);
            % roi_xy = load('dataset_roi.mat','xy');
            
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
              
                %roi_center_x = roi_xy.xy(i,1);
                %roi_center_y = roi_xy.xy(i,2);
                
                roi_center_x = round(size(imm1,2)/2);
                roi_center_y = round(size(imm1,1)/2);
                
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
        
        function two_gif (obj)
            % generates png showing t1 and t2 side-by-side
            fn1 = obj.construct_name(obj.mag1,obj.viewer1,obj.browser1);
            fn2 = obj.construct_name(obj.mag2,obj.viewer2,obj.browser2);
            roi_xy = load('ROI_xy.mat','xy');
            
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fnout1 = sprintf('%s-%s_t1.png',obj.viewer1,obj.browser1);
                fnout2 = sprintf('%s-%s_t2.png',obj.viewer2,obj.browser2);
                
                fname1 = sprintf('%s\\%s',fd,fn1);
                fname2 = sprintf('%s\\%s',fd,fn2);
                foutname1 = sprintf('%s\\%s',fd,fnout1);
                foutname2 = sprintf('%s\\%s',fd,fnout2);
                
                imm1 = imread(fname1);
                imm2 = imread(fname2);
                
                %                 imfinfo(fname1)
                %                 imfinfo(fname2)
                
                % image size will be 2n by 2n pixels
                n = 200;
              
                if 1
                roi_center_x = roi_xy.xy(i,1);
                roi_center_y = roi_xy.xy(i,2);
                else
                %roi_center_x = round(size(imm1,2)/2);
                %roi_center_y = round(size(imm1,1)/2);
                end
                
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
                
                imwrite(im1,foutname1);
                imwrite(im2,foutname2);
                
                % generate gif
                obj.animation(foutname1,foutname2,i);
                
            end
        end
        
        function fn = construct_name (obj, mag, viewer, browser)
            fn = sprintf('%s-%s-%s_reg.png',mag,viewer,browser);
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

        function ROI_pick (obj)
            
            xy = zeros(obj.n_folder,2);
            
            fn1 = obj.construct_name(obj.mag1,obj.viewer1,obj.browser1)
            fn2 = obj.construct_name(obj.mag2,obj.viewer2,obj.browser2)
            
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fnout = sprintf('%s-%s_%s-%s_%02d.tif',obj.viewer1,obj.browser1,obj.viewer2,obj.browser2,i);
                fn3 = sprintf('%s\\%s',fd,fnout);

                im = imread(fn3);
                imagesc(im);
                
                [x,y] = ginput(1);
                
                xy(i,:) = [x y];
            end
            
            obj.ROI_xy = xy;
        end
        
        function dE_all (obj)
            
            fn1 = obj.construct_name(obj.mag1,obj.viewer1,obj.browser1)
            fn2 = obj.construct_name(obj.mag2,obj.viewer2,obj.browser2)
            
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fname1 = sprintf('%s\\%s',fd,fn1)
                fname2 = sprintf('%s\\%s',fd,fn2)
                
                fnout = sprintf('%s-%s_%s-%s_%02d.tif',obj.viewer1,obj.browser1,obj.viewer2,obj.browser2,i);
                fn3 = sprintf('%s\\%s',fd,fnout);
                
                [dE2 dE] = image2dE2(fname1,fname2,fn3);

%                [dE2 dE] = image2dE2(fname1,fname2,'');  % skip the imwrite
                
                [mean(dE) max(dE)]
                obj.deltaE{i} = dE;
            end
        end

        function dE_all_boxplot (obj)
            
            close all
            figure('units','normalized','outerposition',[0 0 1 1])  
            
            for i = 1:obj.n_folder

                mean_dE = mean(obj.deltaE{i});
                
                subplot(4,6,i)
                boxplot(obj.deltaE{i})
                xlabel('')
                ylabel('dE')
                title(sprintf('ROI #%02d, mean dE=%.2f',i,mean_dE))
            end
            
            saveas(gcf,'boxplot.jpg')
        end
        
        function dE_all_4dE_or_greater (obj)
            % count the pixels with 4 dE or greater
            obj.dE4_GE = zeros(obj.n_folder,2);
            for i = 1:obj.n_folder
                obj.dE4_GE(i,1) = nnz(obj.deltaE{i} < 4);
                obj.dE4_GE(i,2) = nnz(obj.deltaE{i} >= 4);
            end
            
            % calcualte the ratio
            rat = obj.dE4_GE(:,2) ./ sum(obj.dE4_GE,2)
            rat_max = max(rat);
            rat_mean = mean(rat);
            
            close all
            figure('units','normalized','outerposition',[0 0 1 1])  
            bar(obj.dE4_GE,'stacked')
            legend('< 4 dE','>= 4 dE')
            xlabel('ROI')
            ylabel('Pixel count')
            title(['Number of pixels with 4 dE or greater' sprintf(' -- max=%2.2f%%, mean=%2.2f%%',rat_max*100,rat_mean*100)])
            saveas(gcf,'dE4_GE.jpg')
            
        end
        
        function dE_all_plot (obj)
            clf
            for i = 1:obj.n_folder
%                subplot(4,6,i)
%                histogram(obj.deltaE{i})
%                boxplot(obj.deltaE{i})
                
                % percentage of dE >= 4
                obj.four_dE(i) = nnz(obj.deltaE{i}>=4)/length(obj.deltaE{i});
            end
            
            kk = zeros(obj.n_folder,2);
            for i = 1:obj.n_folder
                kk(i,1) = nnz(obj.deltaE{i} < 4);
                kk(i,2) = nnz(obj.deltaE{i} >= 4);
            end            
            bar(kk,'stacked')
            obj.kk = kk;
        end
        
        function animation_all (obj)
            % creates .gif switching between subject and predicate
            fn1 = obj.construct_name(obj.mag1,obj.viewer1,obj.browser1)
            fn2 = obj.construct_name(obj.mag2,obj.viewer2,obj.browser2)
            
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

