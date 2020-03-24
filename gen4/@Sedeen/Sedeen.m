% 3-23-2020
% WCC

classdef Sedeen < Viewer
    
    properties
    end
    
    methods
        
        function obj = Sedeen
            
            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.class_dir = mpath;
            
            % Viewer path
            obj.viewer_path = '"C:\Program Files\Sedeen Viewer\sedeen.exe"'
            
            % Viewer title
            obj.viewer_title = '"Sedeen"'
            
            obj.start
%             
%             obj.find_viewarea
% 
            obj.open
            
            % Sedeen memorizes states
            % obj.ahk_do('hide_subwindows.ahk');
             
            obj.find_minimap
             
            obj.click_at(round(obj.screen_size(1)/2), round(obj.screen_size(2)/2))
            for i = 1:4
                obj.zoom_in;
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

            if 0
            im1 = imm1;
            im2 = im1;
            
            a1 = obj.viewarea_pos(1); 
            b1 = obj.viewarea_pos(2); 
            a2 = obj.viewarea_pos(3); 
            b2 = obj.viewarea_pos(4); 
            
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

