% An iterator for going through all fils
% to compare the images
% save cropped images
% compare the dE, SSIM, and entropy
% 8-13-2020: clean up code
% 8-12-2020: modify for Summer Student Presentation
% 5-31-2020: revisit
% 3-23-2020
% WCC

classdef iterate < handle
    
    properties
        % input parameters
        data_folder = 'C:\Users\wcc\Documents\GitHub\autohotkey\gen4\data\100-cmu-2'
        
        % override the data size here
        n_roi_vector = 1:10
        
        % define the ROI here
        ydim = 500
        xdim = 500
        
        % viewername
        viewername = 'sedeen';
    end
    
    methods
        
        function obj = iterate
            
            % too long to type...
            xdim = obj.xdim;
            ydim = obj.ydim;
            
            for i = obj.n_roi_vector
                
                disp(sprintf('iterate Class: %d',i))
                
                % define filenames
                fn_target = sprintf('%s\\%03d\\%s',obj.data_folder,i,'ndp.png');
                fn_trial = sprintf('%s\\%03d\\%s%s',obj.data_folder,i,obj.viewername,'.png');
                fn_err = sprintf('%s\\%03d\\%s%s',obj.data_folder,i,obj.viewername,'.mat');
                
                disp(sprintf('iterate Class: %s',fn_target))
                
                % take a small area
                org_im1 = imread(fn_target);
                org_im2 = imread(fn_trial);
                centerx = round(size(org_im1,2)/2);
                centery = round(size(org_im1,1)/2);
                
                im1 = org_im1(centery-ydim+1:centery+ydim,centerx-xdim+1:centerx+xdim,:);
                im2 = org_im2(centery-ydim+1:centery+ydim,centerx-xdim+1:centerx+xdim,:);
                
                obj.do_process_two_im(i,im1,im2);
            end
            
            return
            
        end
        
        function do_process_two_im (obj, i, im1, im2)
            size(im1)
            size(im2)
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

