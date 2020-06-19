% Sedeen

% Sedeen memorizes states
% start with minimap on

% 3-23-2020
% 4-5-2020
% WCC
% 5-31-2020: revisit

classdef Sedeen < Viewer
    
    methods
        
        function obj = Sedeen
            
            disp('Sedeen Class: Start')
            disp('Sedeen Class: Sedeen memorizes')
            disp('Sedeen Class: Sedeen: must enable minimap')
            disp('Sedeen Class: Sedeen: must disable Application Toolbars')

            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.class_dir = mpath;
            
            % Viewer path
            obj.viewer_path = '"C:\Program Files\Sedeen Viewer\sedeen.exe"';
            
            % Viewer title
            obj.viewer_title = '"Sedeen"';
            
            % Start the Viewer
            obj.start

            % Open the WSI
            obj.open
            
            % Zoom to normal (20x) view
            obj.ahk_do('zoom_normal.ahk');
            
            % Find the minimap
            obj.find_minimap
             
            % Click on the center
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2))
           
            
            % go through the ROIs defined in Viewer.m
            n_roi = size(obj.wsi_roi,1);
            
            for i = 1:n_roi
                
                sprintf('Working on ROI #%d',i)
                
                % define filenames
                fn_target = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp.png');
                fn_trial = sprintf('%s\\%03d\\%s',obj.current_dir,i,'sedeen.png');
                fn_reg = sprintf('%s\\%03d\\%s',obj.current_dir,i,'sedeen.mat');

                % go to the ROI
                obj.goto_roi(obj.wsi_roi(i,1),obj.wsi_roi(i,2));
                
                if 0
                % check minimap
                % because the accuracy is very low when the image is large
                fn_roi = sprintf('%s\\%03d\\%s',obj.current_dir,i,'sedeen_roi.png');
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
                
                % hide minimap to take the screenshot
                obj.ahk_do('toggle_minimap.ahk');

                
                % screenshot to be registered
                obj.printscr(fn_trial);

                % move cursor to center to save time to travel during panning
                obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2))
            
                keep_looping = 1;
                while keep_looping == 1
                    
                    % try registration
                    tic
                    regT = register_images (fn_target, fn_trial);
                    time_registration = toc
                    
                    % get registration result
                    x_pan = round(regT(3,1));
                    y_pan = round(regT(3,2));
                    x_pan_y_pan = [x_pan y_pan]
                    
                    if x_pan == 0 && y_pan == 0
                        keep_looping = 0;
                    else
                        
                        % do panning
                        tic
                        if 1
                            obj.pan_xy(x_pan,y_pan);
                        else
                            obj.drag_right(x_pan);
                            obj.drag_down(y_pan);
                        end
                        time_panning = toc
                        
                        % screenshot
                        obj.printscr(fn_trial);
                    end
                end
                
                % report accuracy
                reg_accu = obj.roi_corrcoef(fn_target,fn_trial)
                
                % save data
                save(fn_reg,'regT','time_registration','time_panning')
                
                % show minimap
                obj.ahk_do('toggle_minimap.ahk');
                
            end
            
            % exit viewer
            obj.close
            
            % make some noise
            obj.chord_gen('C',1)
            
            return
            
        end
        
        function start (obj)
            if obj.SEDEEN_SKIP_UPDATE == 1
                script_path = sprintf('"%s\\%s"',obj.class_dir,'start_update.ahk');
            else
                script_path = sprintf('"%s\\%s"',obj.class_dir,'start.ahk');
            end
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
            
            % mark on images for debugging
            im1 = obj.mark_roi(im1,obj.minimap_pos);
            im2 = obj.mark_roi(im2,obj.minimap_pos);
            
            imwrite(im1,printscr1_fn);
            imwrite(im2,printscr2_fn);
            
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
            obj.screen_size = [size(im1,2) size(im1,1)];

            return
            
        end
        
        function [x1 y1 x2 y2] = mycomp (obj,imm1,imm2)
            
            im1 = imm1;
            im2 = imm2;

          
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

