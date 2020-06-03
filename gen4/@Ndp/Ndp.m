% 3-23-2020
% WCC
% 3-24-2020: unstable because of timing
% 5-31-2020: revisit

classdef Ndp < Viewer
    
    properties
    end
    
    methods
        
        function obj = Ndp
            
            % prerequisite 
            disp('Ndp Class: Start')

            disp('Ndp Class: NDP View memorizes')
            disp('Ndp Class: NDP View: must enable minimap')
            disp('Ndp Class: NDP View: no other windows')
            
            tic
            
            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.class_dir = mpath;
            
            % Viewer path
            obj.viewer_path = sprintf('"%s %s%s"','C:\Program Files\Hamamatsu\NDP.view 2\NDPView2.exe',obj.wsi_folder,obj.wsi_filename);
            
            % Viewer title
            obj.viewer_title = '"NDP"';
            
            obj.start

            % NDP memorizes
            % start from with minimap
            % obj.ahk_do('hide_subwindows.ahk');
            
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2))

            obj.find_minimap

            % zoom
            switch obj.wsi_magnification
                case 20
                    obj.ahk_do('zoom_20x.ahk');
                case 40
                    obj.ahk_do('zoom_40x.ahk');
                otherwise
                    ['Zoom does not support']
                    return
            end
        
            % go through the ROIs
            n_roi = size(obj.wsi_roi,1);
            
            for i = 1:n_roi
               
                mkdir(sprintf('%s\\%03d',obj.current_dir,i));
                fn_out = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp.png');

                % goto ROI
                obj.goto_roi(obj.wsi_roi(i,1),obj.wsi_roi(i,2));

                if 0
                % check minimap
                fn_roi = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp_roi.png');
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
                % debug ROI
                imwrite(im,fn_roi);
                end
                
                % hide minimap
                obj.ahk_do('toggle_minimap.ahk');
                
                % screenshot
                im0 = obj.printscr(fn_out);
    
                
                % show minimap
                obj.ahk_do('toggle_minimap.ahk');
                
                % padding if needed
                % because NDP screenshot is smaller than the display
                im3 = uint8(zeros(obj.screen_size(2),obj.screen_size(1),3));
                im3(1:size(im0,1),1:size(im0,2),:) = im0;
                imwrite(im3,fn_out);
                
            end
            
            % exit viewer
            obj.close
            
            % report time
            elapsedTime = toc
            
            % make some noise
            obj.chord_gen('C',1)
            
            return
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
            
            % mark on images for debugging
            im1 = obj.mark_roi(im1,obj.minimap_pos);
            im2 = obj.mark_roi(im2,obj.minimap_pos);
            
            imwrite(im1,printscr1_fn);
            imwrite(im2,printscr2_fn);
        end
        
        function [x1 y1 x2 y2] = mycomp (obj,imm1,imm2)
            
            im1 = imm1;
            im2 = imm2;
            
            % check only the right half
            % because the icons on the left margin change as the minimap is
            % toggled
            if 1
                im1 = imm1;
                im2 = im1;
                
                a1 = round(size(im1,2)/2);
                b1 = round(size(im1,1)/2);
                a2 = size(im1,2);
                b2 = size(im1,1);
                
                im1(b1:b2,a1:a2,:) = imm1(b1:b2,a1:a2,:);
                im2(b1:b2,a1:a2,:) = imm2(b1:b2,a1:a2,:);
            end
            
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

