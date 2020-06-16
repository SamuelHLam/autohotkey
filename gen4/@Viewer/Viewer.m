%
% Superclass of viewers
% set input files
%
classdef Viewer < handle
    
    properties
        current_dir
        class_dir
        viewerclass_dir
        wsi_filename
        wsi_folder
        roi_folder
        wsi_path
        wsi_roi
        wsi_magnification
        ahk_path
        viewer_path
        viewer_title
        minimap_pos
        viewarea_pos
        screen_size
        username
        ROISIZEHALF = 500
        SEDEEN_SKIP_UPDATE = 1        
    end
    
    methods
        
        function obj = Viewer
            % constructor
            
            % get the user name for setting local variables
            obj.username = getenv('username')
            
            if strcmp(obj.username,'wcc')
                % Wei-Chung's environment settings here
                obj.wsi_folder = 'C:\Users\wcc\Desktop\test_wsi\';
                obj.roi_folder = 'C:\Users\wcc\Documents\GitHub\autohotkey\gen4\roi_100\';
                obj.SEDEEN_SKIP_UPDATE = 1;        
            else
                % Samuel's environment settings here
                obj.wsi_folder = 'C:\Users\Sam\Desktop\test_wsi\';
                obj.roi_folder = 'C:\Users\Sam\Documents\GitHub\autohotkey\gen4\roi_100\';
                obj.SEDEEN_SKIP_UPDATE = 0;
            end
            
            obj.my_disp('Viewer Class: Start');
            
            % current directory
            obj.current_dir = cd;
            
            % get the class directory for the AHK scripts
            thispath = mfilename('fullpath');
            [mpath mname mext] = fileparts(thispath);
            obj.viewerclass_dir = mpath;
            
            
            % WSI file
            obj.my_disp('Viewer Class: Assign WSI paths');
            
            %{
            % camelyon slide
                obj.wsi_filename = 'T11-11969 40x Manual - 2019-09-19 16.27.08.ndpi';
                obj.wsi_folder = 'C:\Users\wcc\Desktop\test_wsi\';
                obj.wsi_magnification = 40;
                %obj.wsi_roi = [(48835/69582) (34632/64463)];
                obj.wsi_roi = zeros(10,2);
                for i = 1:10
                    obj.wsi_roi(i,:) = [(200*(i-5)+48835)/69582 (200*(i-5)+34632)/64463];
                end
            %}

            % WSI input: the CMU samples
            testcasename = 'CMU-3';
            obj.wsi_filename = [testcasename '.ndpi'];
            obj.wsi_magnification = 20;
            
            % get ROIs
            obj.my_disp('Viewer Class: Load ROI data');
            load([obj.roi_folder testcasename '_roi.mat'],'xy')
            obj.wsi_roi = xy;
            
            % WCC
            DEMO_N = 1
            obj.my_disp(sprintf('Viewer Class: Demo mode: %d ROI(s) only',DEMO_N));
            obj.wsi_roi = xy(1:DEMO_N,:);
          
           
            obj.wsi_path = sprintf('\" %s%s\"', obj.wsi_folder, obj.wsi_filename);
            
            % AHK
            obj.my_disp('Viewer Class: Assign AHK path');
            obj.ahk_path = '"C:\Program Files\AutoHotkey\AutoHotkey.exe" ';
            
            if 1
                obj.my_disp('Viewer Class: Obtain display dimension, pixel counts');
                
                % get display size
                printscr1_fn = sprintf('%s\\%s',obj.viewerclass_dir,'myprintscr0.png');
                im1 = obj.printscr(printscr1_fn);
                obj.screen_size = [size(im1,2) size(im1,1)];
                [size(im1,2) size(im1,1)]
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
        
%         function drag_right (obj,x)
%             
%             % 500 is used in AHK
%             
%             displacement = 500+x;
%             [displacement]
%             assert(displacement > 0, 'drag_right: x out of range');
%             
%             param = sprintf('%d',displacement);
%             
%             script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_right.ahk');
%             system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
%         end
        
%         function drag_right1 (obj,x)
%             
%             % 500 is used in AHK
%             
%             displacement = 500+x;
%             assert(displacement > 0, 'drag_right1: x out of range');
%             
%             param = sprintf('%d',displacement);
%             
%             script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_right1.ahk');
%             system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
%         end
        
%         function drag_down (obj,x)
%             
%             % 500 is used in AHK
%             
%             displacement = 500+x;
%             assert(displacement > 0, 'drag_down: out of range');
%             
%             param = sprintf('%d',displacement);
%             
%             script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_down.ahk');
%             system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
%         end
        
        
%         function drag_down1 (obj,x)
%             
%             % 500 is used in AHK
%             
%             displacement = 500+x;
%             assert(displacement > 0, 'drag_down: out of range');
%             
%             param = sprintf('%d',displacement);
%             
%             script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_down1.ahk');
%             system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param]);
%         end
        
        function drag_right_down (obj,x,y)
            
            % 500 is used in AHK
            
            displacement_x = 500+x;
            displacement_y = 500+y;
            assert(displacement_x > 0, 'drag_down: x out of range');
            assert(displacement_y > 0, 'drag_down: y out of range');
            
            param_x = sprintf('%d',displacement_x);
            param_y = sprintf('%d',displacement_y);
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'drag_right_down.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param_x ' ' param_y]);
        end
        
        function pan_by_trim (obj, fn_target, fn_trial0, fn_target2, fn_trial2, panx, pany)
            % 4-5-2020
            % panning by trimming
            
            % input filenames
            im1 = imread(fn_target);
            im2 = imread(fn_trial0);
            
            % get the box for im1
            x1 = 1 + panx;
            y1 = 1 + pany;
            x2 = size(im1,2) + panx;
            y2 = size(im1,1) + pany;
            
            % adjust
            x1 = max(x1,1);
            y1 = max(y1,1);
            x2 = min(x2,size(im1,2));
            y2 = min(y2,size(im1,1));
            
            imout1 = im1(y1:y2,x1:x2,:);
            
            % get the box for im2
            x1 = 1 - panx;
            y1 = 1 - pany;
            x2 = size(im2,2) - panx;
            y2 = size(im2,1) - pany;
            
            % adjust
            x1 = max(x1,1);
            y1 = max(y1,1);
            x2 = min(x2,size(im2,2));
            y2 = min(y2,size(im2,1));
            
            imout2 = im2(y1:y2,x1:x2,:);
            
            % write the files
            imwrite(imout1,fn_target2)
            imwrite(imout2,fn_trial2)
        end
        
        
        % mouse drag from the center of the screen
        function pan_xy (obj, displacement_x, displacement_y)
            
            % limit the mouse drag range to 500,500 rather than the screen size
            % because the boundaries, menu, other subwindows need to be considered
            
            %{
                This is for assuring the correctness of the registration. The panning distance is determined by registering two images, which are limited to the screen size. If the panning distance is longer than 50% of the screen, usually it is a bad registration result.
            %}
            assert(abs(displacement_x)<obj.screen_size(1)/2,'pan: x out of range')
            assert(abs(displacement_y)<obj.screen_size(2)/2,'pan: y out of range')
            
            % passing the displacement relative to the current cursor position
            param_x = sprintf('%d',displacement_x);
            param_y = sprintf('%d',displacement_y);
            
            % passing the screen center position
            screen_x = sprintf('%d',round(obj.screen_size(1)/2));
            screen_y = sprintf('%d',round(obj.screen_size(2)/2));
            
            script_path = sprintf('"%s\\%s"',obj.viewerclass_dir,'pan_xy.ahk');
            system([obj.ahk_path ' ' script_path ' ' obj.viewer_title ' ' param_x ' ' param_y ' ' screen_x ' ' screen_y]);
            
        end
        
        function pan (obj, displacement_x, displacement_y)
            
            assert(abs(displacement_x)<500,'pan: x out of range')
            assert(abs(displacement_y)<500,'pan: y out of range')
            
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
        
        function im2 = mark_roi (obj, im1, roibox)
            x1 = roibox(1);
            y1 = roibox(2);
            x2 = roibox(3);
            y2 = roibox(4);
            
            DEBUG_mark_roi_x1_y1_x2_y2 = [x1 y1 x2 y2]
            
            im2 = im1;
            
            % 4 corners
            im2 = obj.mark_location(im2,y1,x1);
            im2 = obj.mark_location(im2,y1,x2);
            im2 = obj.mark_location(im2,y2,x1);
            im2 = obj.mark_location(im2,y2,x2);
        end
        
        
        function im2 = mark_location (obj, im1, row, col)
            % draw a blue cross at location (row,col)
            im2 = im1;
            for i = -5:+5
                im2(row+i,col,1:3) = [0 0 255]; % blue
                im2(row,col+i,1:3) = [0 0 255]; % blue
            end
        end
        
        function ret = roi_corrcoef (obj, fn_target, fn_trial)
            % calculate correlation coefficients between two images
            % for evaluating the registration accuracy
            
            % load images
            imtarget = imread(fn_target);
            imtrial = imread(fn_trial);
            
            % convert color images to grayscale images
            im1 = rgb2gray(imtarget);
            im2 = rgb2gray(imtrial);
            
            % get the center of the screen
            x = round(obj.screen_size(1)/2);
            y = round(obj.screen_size(2)/2);
            
            % crop a box 
            size = obj.ROISIZEHALF;
            im1 = im1(y-size:y+size,x-size:x+size);
            im2 = im2(y-size:y+size,x-size:x+size);
            
            % main
            ret = corr2(im1,im2);

            return
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
        
        function my_disp (obj, msg)
            % A wrapped text output function so that it can be turned on/off
            % easily for debugging
            disp(msg)
        end
    end
end

