classdef doallfolder < twocomp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xy_chrome
        xy_edge
        xy_firefox
        data = zeros(2,2,3,22,3);
    end
    
    methods
        
        function tab = combine (obj)
            
            mag = 1;
            bro = 1;
            tab1 = [squeeze(obj.data(mag,1,bro,:,[2 1])) squeeze(obj.data(mag,2,bro,:,[2 1]))];
            bro = 2;
            tab2 = [squeeze(obj.data(mag,1,bro,:,[2 1])) squeeze(obj.data(mag,2,bro,:,[2 1]))];
            bro = 3;
            tab3 = [squeeze(obj.data(mag,1,bro,:,[2 1])) squeeze(obj.data(mag,2,bro,:,[2 1]))];
            
            tab = [tab1 tab2 tab3];
            xlswrite('40x_size.xlsx',tab)
            
            mag = 2;
            bro = 1;
            tab1 = [squeeze(obj.data(mag,1,bro,:,[2 1])) squeeze(obj.data(mag,2,bro,:,[2 1]))];
            bro = 2;
            tab2 = [squeeze(obj.data(mag,1,bro,:,[2 1])) squeeze(obj.data(mag,2,bro,:,[2 1]))];
            bro = 3;
            tab3 = [squeeze(obj.data(mag,1,bro,:,[2 1])) squeeze(obj.data(mag,2,bro,:,[2 1]))];
            
            tab = [tab1 tab2 tab3];
            xlswrite('20x_size.xlsx',tab)
            
        end
        
        function tab = test (obj)
            obj.data(1,1,1,:,:) = obj.do_folder('40x','ims-1','chrome');
            obj.data(1,1,2,:,:) = obj.do_folder('40x','ims-1','edge');
            obj.data(1,1,3,:,:) = obj.do_folder('40x','ims-1','firefox');
            obj.data(1,2,1,:,:) = obj.do_folder('40x','insight','chrome');
            obj.data(1,2,2,:,:) = obj.do_folder('40x','insight','edge');
            obj.data(1,2,3,:,:) = obj.do_folder('40x','insight','firefox');
            obj.data(2,1,1,:,:) = obj.do_folder('20x','ims-1','chrome');
            obj.data(2,1,2,:,:) = obj.do_folder('20x','ims-1','edge');
            obj.data(2,1,3,:,:) = obj.do_folder('20x','ims-1','firefox');
            obj.data(2,2,1,:,:) = obj.do_folder('20x','insight','chrome');
            obj.data(2,2,2,:,:) = obj.do_folder('20x','insight','edge');
            obj.data(2,2,3,:,:) = obj.do_folder('20x','insight','firefox');
        end

        
        function do_folder_reg_all (obj)
            obj.do_folder_reg('40x','chrome');
            obj.do_folder_reg('40x','edge');
            obj.do_folder_reg('40x','firefox');
            obj.do_folder_reg('20x','chrome');
            obj.do_folder_reg('20x','edge');
            obj.do_folder_reg('20x','firefox');
        end
        
        function do_folder_reg (obj,mag,browser)
            %(obj,mag,viewer,browser)
            %mag = '40x';
            %browser = 'chrome';
            
            xy = zeros(obj.n_folder,3);
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fn1 = obj.construct_name(mag,'ims-1',browser);
                fn2 = obj.construct_name(mag,'insight',browser);
                imname1 = sprintf('%s\\%s',fd,fn1);
                imname2 = sprintf('%s\\%s',fd,fn2);
%                 [im1_crop, im2_crop] = obj.alignImage(imname1, imname2);
                
                imnameout1 = sprintf('%s\\%s',fd,sprintf('crop1_%02d.png',i));
                imnameout2 = sprintf('%s\\%s',fd,sprintf('crop2_%02d.png',i));

                fdout  = sprintf('%s_%s',mag,browser);
                mkdir(fdout)
                imnamegif = sprintf('%s\\%s',fdout,sprintf('reg_%02d.gif',i));
                
%                 imwrite(im1_crop,imnameout1);
%                 imwrite(im2_crop,imnameout2);
                
                title1 = sprintf('%s: %s',obj.folder_name{i},fn1);
                title2 = sprintf('%s: %s',obj.folder_name{i},fn2);

                obj.make_gif(imnameout1,imnameout2,imnamegif, title1, title2);
            end
        end
        
        function xy = do_folder_imagesize (obj,mag,viewer,browser)
            
            xy = zeros(obj.n_folder,3);
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fn = obj.construct_name(mag,viewer,browser);
                pathname = sprintf('%s\\%s',fd,fn);
                im = imread(pathname);
                xy(i,:) = size(im);
            end
        end
        
        function fn = construct_name(obj, mag, viewer, browser)
            fn = sprintf('%s-%s-%s.png',mag,viewer,browser);
        end
        
        function make_gif (obj, fn1, fn2, fn3, title1, title2)
            
            figure('units','normalized','outerposition',[0 0 1 1]);

            % Capture the plot as an image
            im1 = imread(fn1);
            image(im1);
            axis image
            axis off
            title(title1,'Interpreter','none')
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            
            % Write frames to the GIF File
            imwrite(imind,cm,fn3,'gif','Loopcount',inf);
            
            % Capture the plot as an image
            im2 = imread(fn2);
            image(im2);
            axis image
            axis off
            title(title2,'Interpreter','none')
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            
            imwrite(imind,cm,fn3,'gif','WriteMode','append');
           
            close all
        end
        
        function [im1_crop, im2_crop] = alignImage(obj, imname1, imname2)
            
            im1 = imread(imname1);
            im2 = imread(imname2);
            
            [optimizer, metric] = imregconfig('multimodal');
            optimizer.InitialRadius = 0.0016;
            
            %% Register im1 to im2
            
            [im1reg, im1ref] = imregister(rgb2gray(im1), rgb2gray(im2), 'translation', optimizer, metric);
            %imshow(imfuse(im1reg, rgb2gray(im2)))
            
            columIm1 = sum(im1reg);
            zeroColsIm1 = find(columIm1 == 0);
            zeroColsIm1_total = length(zeroColsIm1);
            zeroColsIm1_leading = max(find(zeroColsIm1 < size(im1reg, 2)/2));
            if isempty(zeroColsIm1_leading)
                zeroColsIm1_leading = 0;
            end
            im1_startx = zeroColsIm1_leading + 1;
            
            rowsumIm1 = sum(im1reg, 2);
            zeroRowsIm1 = find(rowsumIm1 == 0);
            zeroRowsIm1_total = length(zeroRowsIm1);
            zeroRowsIm1_leading = max(find(zeroRowsIm1 < size(im1reg, 1)/2));
            if isempty(zeroRowsIm1_leading)
                zeroRowsIm1_leading = 0;
            end
            im1_starty = zeroRowsIm1_leading + 1;
            
            
            %% Register im2 to im1
            
            [im2reg, im2ref] = imregister(rgb2gray(im2), rgb2gray(im1), 'translation', optimizer, metric);
            %imshow(imfuse(im2reg, rgb2gray(im1)))
            
            columIm2 = sum(im2reg);
            zeroColsIm2 = find(columIm2 == 0);
            zeroColsIm2_total = length(zeroColsIm2);
            zeroColsIm2_leading = max(find(zeroColsIm2 < size(im2reg, 2)/2));
            if isempty(zeroColsIm2_leading)
                zeroColsIm2_leading = 0;
            end
            im2_startx = zeroColsIm2_leading + 1;
            
            rowsumIm2 = sum(im2reg, 2);
            zeroRowsIm2 = find(rowsumIm2 == 0);
            zeroRowsIm2_total = length(zeroRowsIm2);
            zeroRowsIm2_leading = max(find(zeroRowsIm2 < size(im2reg, 1)/2));
            if isempty(zeroRowsIm2_leading)
                zeroRowsIm2_leading = 0;
            end
            im2_starty = zeroRowsIm2_leading + 1;
            
            
            width = min(size(im1, 2) - zeroColsIm2_total, size(im2, 2) - zeroColsIm1_total)-1;
            height = min(size(im1, 1) - zeroRowsIm2_total, size(im2, 1) - zeroRowsIm1_total)-1;
            
            %% Crop im1
            im1_crop = im1(im2_starty:(im2_starty + height), im2_startx:(im2_startx + width), :);
            %figure; imshow(im1_crop)
            
            %% Crop im2
            im2_crop = im2(im1_starty:(im1_starty + height), im1_startx:(im1_startx + width), :);
            %figure; imshow(im2_crop)
            
            
            %% show result
            %figure; imshow(imfuse(im1_crop, im2_crop))
            
        end
    end
    
end

