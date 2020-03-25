classdef Viewer < handle
    
    properties
        current_dir
        class_dir
        viewerclass_dir
        wsi_filename
        wsi_folder
        wsi_path
        wsi_roi
        wsi_magnification
        ahk_path
        viewer_path
        viewer_title
        minimap_pos
        viewarea_pos
        screen_size
    end
    
    methods
        
        function obj = Viewer
            
            % current directory
            obj.current_dir = cd;
            
            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.viewerclass_dir = mpath;
            
            % WSI file
            if 1
                obj.wsi_filename = 'T11-11969 40x Manual - 2019-09-19 16.27.08.ndpi';
                obj.wsi_folder = 'C:\Users\wcc\Desktop\test_wsi\';
                obj.wsi_roi = [(48835/69582) (34632/64463)];
                obj.wsi_magnification = 40;
            end
            
            if 0
                obj.wsi_filename = 'CMU-1.ndpi';
                obj.wsi_folder = 'C:\Users\wcc\Desktop\test_wsi\';
                obj.wsi_roi = [(13469/51200) (32079/38144)];
                obj.wsi_magnification = 20;
            end
            
            obj.wsi_path = sprintf('\" %s%s\"', obj.wsi_folder, obj.wsi_filename);
            
            % AHK
            obj.ahk_path = '"C:\Program Files\AutoHotkey\AutoHotkey.exe" ';
            
            if 1
                % get display size
                printscr1_fn = sprintf('%s\\%s',obj.viewerclass_dir,'myprintscr0.png');
                im1 = obj.printscr(printscr1_fn);
                obj.screen_size = [size(im1,2) size(im1,1)];
            else
                % HP Z24x
                obj.screen_size = [1920 1200];
            end
        end
        
        function im = printscr (obj, fn)
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'printscr.ahk');
            system([obj.ahk_path ' ' script_path ' ' fn]);
            % why do I need delay here??
            pause(1)
            while ~isfile(fn)
            end
            im = imread(fn);
        end
        
        function goto_roi (obj)
            x1 = obj.minimap_pos(1);
            y1 = obj.minimap_pos(2);
            x2 = obj.minimap_pos(3);
            y2 = obj.minimap_pos(4);
            
            roix = round(x1 + obj.wsi_roi(1)*(x2-x1));
            roiy = round(y1 + obj.wsi_roi(2)*(y2-y1));
            
            obj.click_at(roix,roiy);
        end
        
        function ahk_do (obj, script_file)
            script_path = sprintf('"%s\\%s"',obj.class_dir,script_file);
            system([obj.ahk_path  ' ' script_path ' ' obj.viewer_title]);
        end
        
        function click_at (obj, x, y)
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'click_at.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' sprintf('%d',x) ' ' sprintf('%d',y)]);
        end
        
        function zoom_in (obj)
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'zoom_in.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title]);
        end
        
        function zoom_out (obj)
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'zoom_out.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title]);
        end
    
        function drag_right (obj,x)
            
            % 150 is used in AHK
            
            displacement = 150+x;
            if displacement <= 0
                ['drag_right: Out of range']
                return
            end
            
            param = sprintf('%d',displacement);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_right.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
        end
        
        function drag_down (obj,x)
            
            % 150 is used in AHK
            
            displacement = 150+x;
            if displacement <= 0
                ['drag_down: Out of range']
                return
            end
            
            param = sprintf('%d',displacement);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_down.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
        end        
        
    end
end

