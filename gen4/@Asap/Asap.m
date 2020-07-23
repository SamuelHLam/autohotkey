% 3-23-2020
% WCC

classdef Asap < Viewer
    
    properties
        fastforward
        lastrun_path
    end
    
    methods
        
        function obj = Asap

            obj.fastforward = 0;
            
            % setup the path
            obj.setup
            
            % start the viewer
            obj.start
            
            % open the WSI
            obj.open
            
            % hide the subwindows
            obj.hide_subwindows
            
            % find the minimap location
            obj.chord_gen('a',0.3)
            obj.find_minimap
            obj.chord_gen('C',0.3)
                            
            % zoom to top level
            % 16 times is enough
%             for i = 1:16
%                 % save the images to check later
%                 %fn_trial0 = sprintf('%s\\%s%03d%s',obj.current_dir,'asap',i,'.png')
%                 %obj.printscr(fn_trial0);
%                 obj.zoom_out
%             end
            
            if 0
                % zoom through all levels
                % total 121 levels for camelyon
                % total 126 levels for camelyon
                j = 1;
                obj.goto_roi(obj.wsi_roi(j,1),obj.wsi_roi(j,2));
                for i = 1:200
                    fn_trial0 = sprintf('%s\\%s%04d%s',obj.current_dir,'asap',i,'.png')
                    obj.printscr(fn_trial0);
                    obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2));
                    obj.zoom_in
                end
            end
            
            % zoom to 20x
            obj.chord_gen('d',0.3)
            
            i = 5;
            obj.zoom_to_20x(obj.wsi_roi(i,1),obj.wsi_roi(i,2));

            
            obj.chord_gen('G',0.3)
            
            % adjust zoom
%             for i = 1:0
%                 obj.zoom_in
%             end
            
            %             % do some tests
            %             for i = 1:4
            %                 fn_trial0 = sprintf('%s\\%s%d%s',obj.current_dir,'asap',i,'.png')
            %
            %                 j = 1;
            %                 obj.goto_roi(obj.wsi_roi(j,1),obj.wsi_roi(j,2));
            %
            %                 % screenshot
            %                 obj.printscr(fn_trial0);
            %
            %                 obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2));
            %                 obj.zoom_in
            %             end
            
            % go through the ROIs
            if 1
                n_roi = size(obj.wsi_roi,1);
                
                %                       for i = 1:n_roi
                
                for i = 1
                    
                    % define filenames
                    fn_target = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp.png');
                    fn_trial0 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'asap0.png');
                    fn_trial = sprintf('%s\\%03d\\%s',obj.current_dir,i,'asap.png');
                    fn_reg = sprintf('%s\\%03d\\%s',obj.current_dir,i,'reg.mat');
                    
                    obj.goto_roi(obj.wsi_roi(i,1),obj.wsi_roi(i,2));
                    
                    % hide minimap
                    obj.ahk_do('toggle_minimap.ahk');
                    
                    % screenshot
                    obj.printscr(fn_trial0);
                    
                    %                    if ~obj.fastforward
                    if 1
                        obj.chord_gen('F',0.3)
                        regT = register_images (fn_target, fn_trial0)
                        obj.chord_gen('G',0.3)
                        save(fn_reg,'regT')
                    else
                        load(fn_reg,'regT')
                    end
                    
                    %                    if ~obj.fastforward
                    
                    if 1
                        x_pan = round(regT(3,1))
                        y_pan = round(regT(3,2))
                    else
                        x_pan = 1
                        y_pan = 1
                    end
                    
                    % panning

                    obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2));

                    obj.pan(x_pan,y_pan);
                % panning
                %obj.drag_step_by_step(x_pan,y_pan);
                
                    % screenshot
                    obj.printscr(fn_trial);
                    
                    % show minimap
                    obj.ahk_do('toggle_minimap.ahk');
                    
                end
            end
            
            obj.close
            
            % save the parameters for next time
            obj_lastrun = obj;
            save(obj.lastrun_path,'obj_lastrun')
            
            return
        end
        
        function zoom_to_20x (obj,x,y)
            
            % click on the "zoom" icon
            obj.click_at(126,58);
            
            % zoom to top level
            % goto ROI
            obj.goto_roi(x,y);
            
            % cursor must be outside the minimap!
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2));
            
            % 16 times is enough
            for i = 1:16
                obj.ahk_do('drag_up20.ahk');
            end
            
            % zoom to 20x by counting
            % goto ROI
            obj.goto_roi(x,y);
            
            % cursor must be outside the minimap!
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2));
%             for i = 1:67
            for i = 1:86
                obj.ahk_do('drag_down20.ahk');
            end
            
            % click on the "pan" icon
            obj.click_at(95,60);

        end
        
        function setup (obj)
            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.class_dir = mpath;
            
            % Viewer path
            obj.viewer_path = '"C:\Program Files\ASAP 1.9\bin\ASAP.exe"';
            
            % Viewer title
            obj.viewer_title = 'ASAP';
            
            % mat file for last run
            obj.lastrun_path =  sprintf('%s\\%s',obj.class_dir,'lastrun_asap.mat');
        end
        
        function start (obj)
            script_path = sprintf('"%s\\%s"',obj.class_dir,'start.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' obj.viewer_path]);
        end
        
        function open (obj)
            script_path = sprintf('"%s\\%s"',obj.class_dir,'open.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' obj.wsi_path]);
        end
        
        function close (obj)
            script_path = sprintf('"%s\\%s"',obj.class_dir,'close.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title]);
        end
        
        function hide_subwindows (obj)
            obj.ahk_do('toggle_scalebar.ahk');
            obj.ahk_do('toggle_coverageview.ahk');
            obj.ahk_do('toggle_annotations.ahk');
            obj.ahk_do('toggle_imagefilter.ahk');
            obj.ahk_do('toggle_overlays.ahk');
        end
        
        function find_minimap (obj)
            
            % use previous results to save time
            if obj.fastforward && isfile(obj.lastrun_path)
                load(obj.lastrun_path,'obj_lastrun');
                obj.minimap_pos = obj_lastrun.minimap_pos;
                return
            end
            
            printscr1_fn = sprintf('%s\\%s',obj.class_dir,'minimap_on.png');
            printscr2_fn = sprintf('%s\\%s',obj.class_dir,'minimap_off.png');
            
            im1 = obj.printscr(printscr1_fn);
            obj.ahk_do('toggle_minimap.ahk');
            
            im2 = obj.printscr(printscr2_fn);
            
            [x1 y1 x2 y2] = obj.mycomp (im1, im2);
            obj.minimap_pos = [x1 y1 x2 y2];
            
            % mark on images for debugging
            im1 = obj.mark_roi(im1,obj.minimap_pos);
            im2 = obj.mark_roi(im2,obj.minimap_pos);
            
            imwrite(im1,printscr1_fn);
            imwrite(im2,printscr2_fn);
            
            % code should work regardless of initial state of minimap
            map_off = obj.map_state(im1, im2);

            if (map_off)
                % if map is not on, toggle it on
                obj.ahk_do('toggle_minimap.ahk');
            end
        end
        
        function find_viewarea (obj)
            printscr1_fn = sprintf('%s\\%s',obj.class_dir,'myprintscr1.png');
            printscr2_fn = sprintf('%s\\%s',obj.class_dir,'myprintscr2.png');
            
            for i = 1:40
                obj.zoom_in;
            end
            im1 = obj.printscr(printscr1_fn);
            
            for i = 1:40
                obj.zoom_out;
            end
            im2 = obj.printscr(printscr2_fn);
            
            [x1 y1 x2 y2] = mycomp (im1, im2);
            obj.viewarea_pos = [x1 y1 x2 y2];
            
        end
        
        
        function [x1 y1 x2 y2] = mycomp (obj,im1,im2)
            
            % color images
            %im1 = imread('myprintscr1.png');
            %im2 = imread('myprintscr2.png');
            
            %im1 = imread(fn1);
            %im2 = imread(fn2);
            
            % 2D to 1D
            imlin1 = reshape(im1,size(im1,1)*size(im1,2),3);
            imlin2 = reshape(im2,size(im2,1)*size(im2,2),3);
            
            % to CIELAB
            lab1 = rgb2lab(imlin1);
            lab2 = rgb2lab(imlin2);
            
            % color difference
            dE = sum((lab1-lab2).^2,2).^0.5;
            
            % thresholding
            th = 5;
            dE(dE<th) = 0;
            dE(dE>th) = 255;
            
            % 2D
            dE2 = reshape(dE,size(im1,1),size(im1,2));
            
            % find non-zero
            [row,col] = find(dE2);
            
            % result
            y1 = min(row)
            y2 = max(row)
            x1 = min(col)
            x2 = max(col)
            
            return
            
            % visualize
            imagesc(dE2)
            colorbar
        end
        
    end
    
end

