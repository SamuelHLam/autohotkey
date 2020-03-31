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
            if 0
                obj.wsi_filename = 'T11-11969 40x Manual - 2019-09-19 16.27.08.ndpi';
                obj.wsi_folder = 'C:\Users\wcc\Desktop\test_wsi\';
                obj.wsi_magnification = 40;
                %obj.wsi_roi = [(48835/69582) (34632/64463)];
                obj.wsi_roi = zeros(10,2);
                for i = 1:10
                    obj.wsi_roi(i,:) = [(200*(i-5)+48835)/69582 (200*(i-5)+34632)/64463];
                end
            end
            
            if 1
                obj.wsi_filename = 'CMU-1.ndpi';
                obj.wsi_folder = 'C:\Users\wcc\Desktop\test_wsi\';
                obj.wsi_magnification = 20;
                %obj.wsi_roi = [(13469/51200) (32079/38144)];
                obj.wsi_roi = zeros(10,2);
                for i = 1:10
                    obj.wsi_roi(i,:) = [(200*(i-5)+16311)/51200 (200*(i-5)+28362)/38144];
                end
            end
            
            obj.wsi_path = sprintf('\" %s%s\"', obj.wsi_folder, obj.wsi_filename);
            
            % AHK
            obj.ahk_path = '"C:\Program Files\AutoHotkey\AutoHotkey.exe" ';
            
            if 0
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
        
        function goto_roi (obj, x, y)
            x1 = obj.minimap_pos(1);
            y1 = obj.minimap_pos(2);
            x2 = obj.minimap_pos(3);
            y2 = obj.minimap_pos(4);
            
            roix = round(x1 + x*(x2-x1));
            roiy = round(y1 + y*(y2-y1));
            
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
        
        function drag_right1 (obj,x)
            
            % 150 is used in AHK
            
            displacement = 150+x;
            if displacement <= 0
                ['drag_right: Out of range']
                return
            end
            
            param = sprintf('%d',displacement);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_right1.ahk');
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
        
        
        function drag_down1 (obj,x)
            
            % 150 is used in AHK
            
            displacement = 150+x;
            if displacement <= 0
                ['drag_down: Out of range']
                return
            end
            
            param = sprintf('%d',displacement);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_down1.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
        end
        
        function drag_right_down (obj,x,y)
            
            % 150 is used in AHK
            
            displacement_x = 150+x;
            if displacement_x <= 0
                ['drag_down: Out of range : x']
                return
            end
            
            displacement_y = 150+y;
            if displacement_y <= 0
                ['drag_down: Out of range : y']
                return
            end
            
            param_x = sprintf('%d',displacement_x);
            param_y = sprintf('%d',displacement_y);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_right_down.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param_x ' ' param_y]);
        end

        function pan (obj, displacement_x, displacement_y)
            
            param_x = sprintf('%+d',500+displacement_x);
            param_y = sprintf('%+d',500+displacement_y);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'pan.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param_x ' ' param_y]);
        end
                
        function drag_step_by_step (obj, x, y)
            
            abs_x = abs(x);
            abs_y = abs(y);
            sign_x = sign(x);
            sign_y = sign(y);
            
            both_step = min(abs_x,abs_y);
            remaining_x = abs_x - both_step;
            remaining_y = abs_y - both_step;
            
            for i = 1:both_step
                obj.drag_right_down (sign_x,sign_y);
            end
            
            for i = 1:remaining_x
                obj.drag_right_down (sign_x,0);
            end
            
            for i = 1:remaining_y
                obj.drag_right_down (0,sign_y);
            end
            
        end
        
        function mybeep (obj)
            load handel.mat;
            nBits = 16;
            sound(y(1:5000),Fs,nBits);
        end
        
        function chord_gen (obj, chordname, duration)
        % generate 3-note chord
        % 3-26-2020
        % WCC and Trinity
        
            sample_rate = 8192;
            
            % parse the chordname to get the base pitch
            switch chordname
                case {'C','c'}
                    i_pitch = 1;
                case {'D','d'}
                    i_pitch = 3;
                case {'E','e'}
                    i_pitch = 5;
                case {'F','f'}
                    i_pitch = 6;
                case {'G','g'}
                    i_pitch = 8;
                case {'A','a'}
                    i_pitch = 10;
                case {'B','b'}
                    i_pitch = 12;
            end
            
            % decide if it is a major or minor chord
            switch chordname
                case {'C','D','E','F','G','A','B'}
                    i_pitch3 = i_pitch+4;
                case {'c','d','e','f','g','a','n'}
                    i_pitch3 = i_pitch+3;
            end
            
            % create the pitch table; make it longer than one octave
            tab = zeros(24,1);
            magicnumber = 0.5 .^ (1/12);
            c = 440 * (magicnumber .^ 10);
            for i = 1:24
                tab(i,1) = c / (magicnumber .^ i);
            end
            
            % the 3 pitches
            fr1 = tab(i_pitch,1);
            fr3 = tab(i_pitch3,1);
            fr5 = tab(i_pitch+7,1);
            
            % lower one octave for some chords -- not complete
            switch chordname
                case {'A','B','a','b','G','g','F'}
                    fr1 = fr1 / 2;
                    fr3 = fr3 / 2;
                    fr5 = fr5 / 2;
            end
            
            % three waveforms
            wav1 = mypitch(fr1,duration,sample_rate);
            wav3 = mypitch(fr3,duration,sample_rate);
            wav5 = mypitch(fr5,duration,sample_rate);
            
            % combine three waveforms
            wav = (wav1+wav3+wav5)/3;
            
            % generate sound
            sound(wav,sample_rate)
            
            % synchronize
            pause(duration)
            
            return
            
            function y = mypitch (freq,duration,sample_rate)
                % freq = 220;
                % duration = 2;
                t = 0:1/sample_rate:duration;
                y = sin(2*pi*t*freq);
                % plot(t,y,'-')
            end
            
        end
    end
end

