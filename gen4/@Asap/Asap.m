% 3-23-2020
% WCC

classdef Asap < Viewer
    
    properties
    end
    
    methods
        
        function obj = Asap
            
            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.class_dir = mpath;
            
            % Viewer path
            obj.viewer_path = '"C:\Program Files\ASAP 1.9\bin\ASAP.exe"';
            
            % Viewer title
            obj.viewer_title = 'ASAP';
            
            obj.start
            obj.open
            
            obj.hide_subwindows
%            obj.find_viewarea
            obj.find_minimap
            
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2));
            for i = 1:25
                obj.zoom_in
            end
            
            obj.goto_roi
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
            printscr1_fn = sprintf('%s\\%s',obj.class_dir,'myprintscr1.png');
            printscr2_fn = sprintf('%s\\%s',obj.class_dir,'myprintscr2.png');
            
            im1 = obj.printscr(printscr1_fn);
            obj.ahk_do('toggle_minimap.ahk');
            
            im2 = obj.printscr(printscr2_fn);
            obj.ahk_do('toggle_minimap.ahk');
            
            [x1 y1 x2 y2] = obj.mycomp (im1, im2);
            obj.minimap_pos = [x1 y1 x2 y2];
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
            y1 = min(row);
            y2 = max(row);
            x1 = min(col);
            x2 = max(col);
            
            return
            
            % visualize
            imagesc(dE2)
            colorbar
        end
        
    end
    
end

