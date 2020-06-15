% 3-23-2020
% WCC
% QuPath does not memorize
% 5-31-2020: revisit
% 6-15-2020

classdef QuPath_pan < QuPath
    
    methods
        
        
        function do_panning (obj,fn_target, fn_trial0, fn_target2, fn_trial2, x_pan, y_pan, fn_trial)
            
            
            obj.drag_step_by_step(x_pan,y_pan);
            %
            %                     if 0
            %                         % panning
            %                         for j = 1:abs(x_pan)
            %                             obj.drag_right1(sign(x_pan));
            %                         end
            %                         for j = 1:abs(y_pan)
            %                             obj.drag_down1(sign(y_pan));
            %                         end
            %                     end
            %
            % screenshot
            obj.printscr(fn_trial);
            
        end
        
    end
    
end

