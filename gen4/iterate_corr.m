classdef iterate_corr < iterate
    %UNTITLED Summary of this class goes here
    %   8-24-2020: added CDF plots
    
    properties
        D
    end
    
    methods (Static)

        function cdf_plot
            id = iterate_dE;
            id.go;

%{
a = iterate_corr
d1 = a.D;
a = iterate_corr
d2 = a.D;
a = iterate_corr
d3 = a.D;
boxplot([d1 d2 d3])
xticklabels({'CMU-1','CMU-2','CMU-3'})
axis([0.5 3.5 0 1])
ylabel('Corr.')
axis square
saveas(gcf,'correlation.png')            
        %}
        end
        
    end
    
    methods
        
        function obj = iterate_corr
            % it's hard to initiate D with zeros() in the constructor because
            % the superclass constructor may be invoked late
            obj.D = zeros(length(obj.n_roi_vector),1);
        end
        
        function do_process_two_im (obj, i, im1, im2)
                
            imgs1 = rgb2gray(im1);
            imgs2 = rgb2gray(im2);
            
            obj.D(i,:) = corr2(imgs1,imgs2);
            
        end
        
    end
end

