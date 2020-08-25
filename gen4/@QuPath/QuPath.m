% 3-23-2020
% WCC
% QuPath does not memorize
% 5-31-2020: revisit

classdef QuPath < Viewer
    
    properties
        PANBYTRIM = 1
        FASTFORWARD = 0
    end
    
    methods
        
        function obj = QuPath

            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.class_dir = mpath;
            
            % Viewer path
            obj.viewer_path = '"C:\Program Files\QuPath\QuPath.exe"';
            
            % Viewer title
            obj.viewer_title = '"QuPath"';
            
            obj.start
            obj.ahk_do('hide_subwindows.ahk');
            
            obj.open
            
            % get viewarea to get minimap
            if ~obj.FASTFORWARD
                obj.find_viewarea
                obj.find_minimap
            else
                obj.viewarea_pos = [2,83,1919,1159];
                obj.minimap_pos = [1760,93,1909,230];
            end
            
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2))
            
            % zoom to normal view
            obj.ahk_do('zoom_normal.ahk');
            
            % go through the ROIs
            n_roi = size(obj.wsi_roi,1);
            
            for i = 1:n_roi
                
                % define filenames
                fn_target = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp.png');
                fn_target2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp2.png');
                fn_trial0 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'qupath0.png');
                fn_trial = sprintf('%s\\%03d\\%s',obj.current_dir,i,'qupath.png');
                fn_trial2 = sprintf('%s\\%03d\\%s',obj.current_dir,i,'qupath2.png');
                fn_reg = sprintf('%s\\%03d\\%s',obj.current_dir,i,'qupath.mat');
                
                % goto ROI
                obj.goto_roi(obj.wsi_roi(i,1),obj.wsi_roi(i,2));
                
                if 0
                    % check minimap
                    % because the accuracy is very low when the image is large
                    fn_roi = sprintf('%s\\%03d\\%s',obj.current_dir,i,'qupath_roi.png');
                    obj.printscr(fn_roi);
                    im = imread(fn_roi);
                    x1 = obj.minimap_pos(1);
                    y1 = obj.minimap_pos(2);
                    x2 = obj.minimap_pos(3);
                    y2 = obj.minimap_pos(4);
                    
                    roix = round(x1 + obj.wsi_roi(i,1)*(x2-x1));
                    roiy = round(y1 + obj.wsi_roi(i,2)*(y2-y1));
                    [roix roiy]
                    im = obj.mark_location(im,roiy,roix);
                    imwrite(im,fn_roi);
                end
                
                % hide minimap
                obj.ahk_do('toggle_minimap.ahk');
                
                % screenshot
                obj.printscr(fn_trial0);
                
                % try registration
                if ~obj.FASTFORWARD
                    tic
                    regT = register_images (fn_target, fn_trial0);
                    time_registration = toc
                else
                    load(fn_reg,'regT')
                end
                
                if ~obj.FASTFORWARD
                    x_pan = round(regT(3,1));
                    y_pan = round(regT(3,2));
                else
                    x_pan = 1;
                    y_pan = 1;
                end
                
                % obj.chord_gen('C',0.3)
                
                % panning
                tic

                obj.do_panning(fn_target, fn_trial0, fn_target2, fn_trial2, x_pan, y_pan, fn_trial);
                
                %{
                if obj.PANBYTRIM == 1
                    obj.pan_by_trim (fn_target, fn_trial0, fn_target2, fn_trial2, x_pan, y_pan)
                else
                    obj.drag_step_by_step(x_pan,y_pan);
                    
                    if 0
                        % panning
                        for j = 1:abs(x_pan)
                            obj.drag_right1(sign(x_pan));
                        end
                        for j = 1:abs(y_pan)
                            obj.drag_down1(sign(y_pan));
                        end
                    end
                    
                    % screenshot
                    obj.printscr(fn_trial);
                    
                end
            %}
                
                time_panning = toc
                save(fn_reg,'regT','time_registration','time_panning')
                
                % show minimap
                %                obj.ahk_do('toggle_minimap_short.ahk');
                obj.ahk_do('toggle_minimap.ahk');
                
            end
            
            % exit
            obj.close
            
            % make some noise
            obj.chord_gen('C',1)
            
            return
        end

        function do_panning (obj,fn_target, fn_trial0, fn_target2, fn_trial2, x_pan, y_pan, fn_trial)
                    
            obj.pan_by_trim (fn_target, fn_trial0, fn_target2, fn_trial2, x_pan, y_pan)

%                     obj.drag_step_by_step(x_pan,y_pan);
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
%                     % screenshot
%                     obj.printscr(fn_trial);
                    
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
        
        function find_minimap (obj)
            printscr1_fn = sprintf('%s\\%s',obj.class_dir,'minimap_on.png');
            printscr2_fn = sprintf('%s\\%s',obj.class_dir,'minimap_off.png');
            
            im1 = obj.printscr(printscr1_fn);
            obj.ahk_do('toggle_minimap.ahk');
            
            im2 = obj.printscr(printscr2_fn);
            obj.ahk_do('toggle_minimap.ahk');
            
            [x1 y1 x2 y2] = obj.mycomp (im1, im2);
            obj.minimap_pos = [x1 y1 x2 y2];
        end
        
        function find_viewarea (obj)
            printscr1_fn = sprintf('%s\\%s',obj.class_dir,'myprintscr1.png');
            
            im1 = obj.printscr(printscr1_fn);
            
            im1lin = reshape(im1,size(im1,1)*size(im1,2),3);
            
            % thresholding
            im2lin = zeros(size(im1,1)*size(im1,2),1);
            mask = (im1lin(:,1)==90) & (im1lin(:,2)==0) & (im1lin(:,3)==0);
            im2lin(mask) = 255;
            im2lin(~mask) = 0;
            
            % 2D
            im2 = reshape(im2lin,size(im1,1),size(im1,2));
            
            % find non-zero
            [row,col] = find(im2);
            
            % result
            y1 = min(row)
            y2 = max(row)
            x1 = min(col)
            x2 = max(col)
            
            % visualize
            %            imagesc(imgray2)
            %            colorbar
            
            obj.viewarea_pos = [x1 y1 x2 y2];
            
            return
            
        end
        
        function [x1 y1 x2 y2] = mycomp (obj,imm1,imm2)
            
            im1 = imm1;
            im2 = im1;
            
            a1 = obj.viewarea_pos(1);
            b1 = obj.viewarea_pos(2);
            a2 = obj.viewarea_pos(3);
            b2 = obj.viewarea_pos(4);
            
            im1(b1:b2,a1:a2,:) = imm1(b1:b2,a1:a2,:);
            im2(b1:b2,a1:a2,:) = imm2(b1:b2,a1:a2,:);
            
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
            mask = dE<th;
            dE(mask) = 0;
            dE(~mask) = 255;
            
            % 2D
            dE2 = reshape(dE,size(im1,1),size(im1,2));
            
            % find non-zero
            [row,col] = find(dE2);
            
            % result
            y1 = min(row);
            y2 = max(row);
            x1 = min(col);
            x2 = max(col);
            
            % visualize
            %            imagesc(dE2)
            %            colorbar
            
            return
            
        end
        
    end
    
end

