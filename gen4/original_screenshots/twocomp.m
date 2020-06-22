classdef twocomp
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        folder_name = {}
        n_folder = 0
    end
    
    methods
        function obj = twocomp
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            allfile = dir;
            obj.n_folder = 0;
            for i = 1:size(allfile,1)
                if allfile(i).isdir & allfile(i).name(1)~='.'
                    obj.n_folder = obj.n_folder + 1;
                    obj.folder_name{obj.n_folder} = allfile(i).name;
                end
            end
            
            
            return
        end
        
        function pan_by_trim (obj, fin1, fin2, fout1, fout2, panx, pany)
            % 4-5-2020
            % panning by trimming
            
            % input filenames
            im1 = imread(fin1);
            im2 = imread(fin2);
            
            % use (x,y) for im1
            % use (u,v) for im2
            
            % map (x,y) to (u,v)
            x1 = 1 + panx;
            y1 = 1 + pany;
            x2 = size(im1,2) + panx;
            y2 = size(im1,1) + pany;
            
            % use (a,b) as crop points in im2
            a1 = max(x1,1);
            b1 = max(y1,1);
            a2 = min(x2,size(im2,2));
            b2 = min(y2,size(im2,1));
            
            % crop im1 in (x,y)
            imout1 = im1([b1:b2]-pany,[a1:a2]-panx,:);
            
            % crop im2
            imout2 = im2(b1:b2,a1:a2,:);
            
            % write the files
            imwrite(imout1,fout1)
            imwrite(imout2,fout2)
            
        end
        
        function method1(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fn1 = '40x-ims-1-chrome.png';
            fn2 = '40x-insight-chrome.png';
            for i = 1:obj.n_folder
                %for i = obj.n_folder:obj.n_folder
                fd = obj.folder_name{i};
                fname1 = sprintf('%s\\%s',fd,fn1);
                fname2 = sprintf('%s\\%s',fd,fn2);
                
                foutname1 = sprintf('%s\\%s',fd,'t1.png');
                foutname2 = sprintf('%s\\%s',fd,'t2.png');
                de2out = sprintf('%s\\%s',fd,'dE.png');
                
                %    im1 = imread(fname1);
                %    im2 = imread(fname2);
                
                %    imshowpair(im1,im2)
                %    pause
                
                t = register_images(fname2,fname1)
                sprintf('%s: %.4f %.4f %.4f %.4f',fd,t(1,1),t(2,2),t(3,1),t(3,2))
                
                panx = round(t(3,1))
                pany = round(t(3,2))
                obj.pan_by_trim(fname1,fname2,foutname1,foutname2,panx,pany)
                
                compare_roi(foutname1,foutname2);
                
                %[dE2 dE] = image2dE2 (foutname1,foutname2,de2out);
                
            end
        end
        
        function two_show (obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fn1 = 't1.png';
            fn2 = 't2.png';
            
            for i = 1:obj.n_folder
                fd = obj.folder_name{i};
                fnout = sprintf('montage_%02d.png',i);
                
                fname1 = sprintf('%s\\%s',fd,fn1);
                fname2 = sprintf('%s\\%s',fd,fn2);
                foutname12 = sprintf('%s\\%s',fd,fnout);
                
                imm1 = imread(fname1);
                imm2 = imread(fname2);
                
                n = 500;
                im1 = imm1(1:n,1:n,:);
                im2 = imm2(1:n,1:n,:);
                
                montage({im1,im2});
                saveas(gcf,foutname12);
                
            end
        end
        
    end
end

