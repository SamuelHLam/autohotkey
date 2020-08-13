% An iterator for going through all fils
% to compare the images
% save cropped images
% compare the dE, SSIM, and entropy
% 8-13-2020: clean up code
% 8-12-2020: modify for Summer Student Presentation
% 5-31-2020: revisit
% 3-23-2020
% WCC

classdef iterate
    
    properties
        % comparison results
        data
        
        % 
        D
    end
    
    methods (Static)
        function test
            i = iterate;
            i.stats;
        end
    end
    
    methods
        
        function obj = iterate
            
            % input parameters
            data_folder = 'C:\Users\wcc\Documents\GitHub\autohotkey\gen4\data\100-cmu-3'
            
            % override the data size here
            n_roi_vector = 1:100
            
            % define the ROI here
            ydim = 500
            xdim = 500
            
            % use my old colorimetry code
            % c = ColorConversionClass;
            
            %           viewername = 'qupath';
            viewername = 'sedeen';

            D = zeros(length(n_roi_vector),(ydim*2+1)*(xdim*2+1));
            
            for i = n_roi_vector
                
                disp(sprintf('iterate Class: %d',i))
                
                % define filenames
                fn_target = sprintf('%s\\%03d\\%s',data_folder,i,'ndp.png');
                fn_trial = sprintf('%s\\%03d\\%s%s',data_folder,i,viewername,'.png');
                fn_err = sprintf('%s\\%03d\\%s%s',data_folder,i,viewername,'.mat');
                
                disp(sprintf('iterate Class: %s',fn_target))
                
                % take a small area
                org_im1 = imread(fn_target);
                org_im2 = imread(fn_trial);
                centerx = round(size(org_im1,2)/2);
                centery = round(size(org_im1,1)/2);
                im1 = org_im1(centery-ydim+1:centery+ydim,centerx-xdim+1:centerx+xdim,:);
                im2 = org_im2(centery-ydim+1:centery+ydim,centerx-xdim+1:centerx+xdim,:);
                
                [dE2 dE] = image2dE2 (obj,im1,im2);
                               
                obj.D(i,:) = dE;
                
                %% need to debug
                
                %                 % check alignment again; smaller area may have different
                %                 % optimal offset
                %                 [opt_i, opt_r] = obj.image_shift_opt(im1,im2);
                %                 [opt_i opt_r]
                %
                %                 % calculate the shift
                %                 shiftrow = floor(i/3) - 1;
                %                 shiftcol = mod(i,3) - 1;
                %
                %                 % adjust im2
                %                 im2 = org_im2(centery-ydim+1+shiftrow:centery+ydim+shiftrow,centerx-xdim+1+shiftcol:centerx+xdim+shiftcol,:);
                %                 [opt_i, opt_r] = obj.image_shift_opt(im1,im2);
                %                 [opt_i opt_r]
                
                if 0
                    % create new files for trimmed images
                    % save the trimmed images
                    fn_target1 = sprintf('%s\\%03d\\%s%s',data_folder,i,'ndp','1.png');
                    fn_trial1 = sprintf('%s\\%03d\\%s%s',data_folder,i,viewername,'1.png');
                    imwrite(im1, fn_target1);
                    imwrite(im2, fn_trial1);
                end
                
                if 0
                    % main 1
                    
                    % [dE2 dE] = obj.image2dE2 (im1,im2);
                    
                    [dE00 dE94 dEab] = c.image2dE(fn_target1,fn_trial1);
                end
                
                if 0
                    % main 2
                    imbw1 = rgb2gray(im1);
                    imbw2 = rgb2gray(im2);
                    
                    ent = entropy(imbw1);
                end
                
                if 0
                    % main 3
                    %                [ssimval,ssimmap] = ssim(imbw1,imbw2);
                    ssimval = ssim(imbw1,imbw2);
                end
                
                if 0
                    % main 4
                    imcorrcoef = corr2(imbw1,imbw2);
                end
                
                if 0
                    obj.data(i,1:6) = [mean2(dE00) mean2(dE94) mean2(dEab) ssimval ent imcorrcoef];
                end
                
            end
            
            if 0
                % save the result
                pixelwise_error = obj.data;
                save(sprintf('%s%s',viewername,'.mat'),'pixelwise_error')
                
                %             % make some noise
                %             obj.chord_gen('C',1)
                
                % show some results
                clf
                plot(obj.data(:,1),obj.data(:,3),'o')
            end
            
            return
            
        end

        function stats (obj)
        % generate statistics of 100 ROIs
            Dmin = min(obj.D,[],2)
            Dmax = max(obj.D,[],2)
            Dmean = mean(obj.D,2)
            Dmedian = median(obj.D,2)
            Dstd = std(obj.D,0,2)
            
            boxplot([Dmin Dmax Dmean Dmedian Dstd])
            xticklabels({'Min','Max','Mean','Median','Std'})
            ylabel('{\Delta}E')
            
            saveas(gcf,'boxplot.png');
        end
        
        %
        % visualize the differences
        %
        function show_data (obj)
            clf
            
            subplot(2,2,1)
            hold on
            plot(obj.data(:,1),obj.data(:,2),'.r')
            plot(obj.data(:,1),obj.data(:,3),'.b')
            xlabel('\DeltaE_{00}')
            ylabel('\DeltaE_{94}')
            legend('\DeltaE94','\DeltaEab')
            
            subplot(2,2,2)
            plot(obj.data(:,1),obj.data(:,6),'.')
            xlabel('\DeltaE_{00}')
            ylabel('Corr Coef')
            
            subplot(2,2,3)
            plot(obj.data(:,1),obj.data(:,4),'.')
            xlabel('\DeltaE_{00}')
            ylabel('SSIM')
            
            subplot(2,2,4)
            plot(obj.data(:,1),obj.data(:,5),'.')
            xlabel('\DeltaE_{00}')
            ylabel('Entropy')
            
            saveas(gcf,'finding_diff.tif')
        end
        
        % not used here
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

