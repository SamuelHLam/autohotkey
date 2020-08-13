classdef iterate_ssim < iterate
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
    end
    
    methods (Static)
        function test
            id = iterate_ssim;
            id.save_data
            id.show_data
        end
    end
    
    methods
        
        function obj = iterate_ssim
            % it's hard to initiate D with zeros() in the constructor because
            % the superclass constructor may be invoked late
            %            obj@iterate
            %            obj.D = zeros(length(obj.n_roi_vector),(obj.ydim*2)*(obj.xdim*2));
        end
        
        function do_process_two_im (obj, i, im1, im2)
            
            if 1
                % main 1
                
%                 [dE2 dE] = obj.image2dE2 (im1,im2);
%                 dE00 = dE;
%                 dE94 = dE;
%                 dEab = dE;
                
                c = ColorConversionClass;
                [dE00 dE94 dEab] = c.im2dE(im1,im2);
            end
            
            if 1
                % main 2
                imbw1 = rgb2gray(im1);
                imbw2 = rgb2gray(im2);
                
                ent = entropy(imbw1);
            end
            
            if 1
                % main 3
                %                [ssimval,ssimmap] = ssim(imbw1,imbw2);
                ssimval = ssim(imbw1,imbw2);
            end
            
            if 1
                % main 4
                imcorrcoef = corr2(imbw1,imbw2);
            end
            
            if 1
                obj.data(i,1:6) = [mean2(dE00) mean2(dE94) mean2(dEab) ssimval ent imcorrcoef];
            end
            
            return
        end
        
        function save_data (obj)
            % save the result
            pixelwise_error = obj.data;
            save(sprintf('%s%s',obj.viewername,'.mat'),'pixelwise_error')
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
        
    end
    
end
    
