classdef iterate_dE < iterate
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        D
    end
    
    methods (Static)
        function test
            id = iterate_dE;
            id.go
            id.stats
        end
    end
    
    methods
        
        function obj = iterate_dE
            % it's hard to initiate D with zeros() in the constructor because
            % the superclass constructor may be invoked late
            obj.D = zeros(length(obj.n_roi_vector),(obj.ydim*2)*(obj.xdim*2));
        end
        
        function do_process_two_im (obj, i, im1, im2)
                
            [dE2 dE] = obj.image2dE2(im1,im2);

            obj.D(i,:) = dE;
            
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
        
    end
end

