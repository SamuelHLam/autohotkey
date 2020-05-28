% 3-23-2020
% WCC
% 3-24-2020: unstable because of timing

classdef iterate < Viewer
    
    properties
        data
    end
    
    methods
        
        function obj = iterate
            
            c = ColorConversionClass
            
            centerx = round(obj.screen_size(1)/2);
            centery = round(obj.screen_size(2)/2);
            
            n_roi = size(obj.wsi_roi,1);
            
            viewername = 'qupath';
%            viewername = 'sedeen';
            
            for i = 1:n_roi
                
                % define filenames
                fn_target = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp.png');
                fn_trial = sprintf('%s\\%03d\\%s%s',obj.current_dir,i,viewername,'.png');
                fn_reg = sprintf('%s\\%03d\\%s%s',obj.current_dir,i,viewername,'.mat');
                
                im1 = imread(fn_target);
                im2 = imread(fn_trial);
                im1 = im1(centery-500:centery+500,centerx-500:centerx+500,:);
                im2 = im2(centery-500:centery+500,centerx-500:centerx+500,:);

                % create new files for trimmed images
                fn_target1 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp1.png');
                fn_trial1 = sprintf('%s\\%03d\\%s%s',obj.current_dir,i,viewername,'1.png');
                imwrite(im1, fn_target1);
                imwrite(im2, fn_trial1);
                
%                [dE2 dE] = obj.image2dE2 (im1,im2);
                
                [dE00 dE94 dEab] = c.image2dE(fn_target1,fn_trial1);
                
                imbw1 = rgb2gray(im1);
                imbw2 = rgb2gray(im2);
                
                ent = entropy(imbw1);
                
                %                [ssimval,ssimmap] = ssim(imbw1,imbw2);
                ssimval = ssim(imbw1,imbw2);
                
                obj.data(i,1:5) = [mean2(dE00) mean2(dE94) mean2(dEab) ssimval ent];
                
                subplot(3,4,i)
                imagesc(imbw1)
            end
            
            
            % make some noise
            obj.chord_gen('C',1)
            
            clf
            plot(obj.data(:,1),obj.data(:,3),'o')

            return
            
        end
        
        function [dE2 dE] = image2dE2 (obj,im1,im2)
            
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
            
            return
            
        end
        
    end
    
end

