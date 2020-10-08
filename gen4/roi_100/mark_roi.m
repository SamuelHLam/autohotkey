% 4-4-2020
% WCC
% mark the ROIs chosen by choose_roi

function mark_roi (fn, xy)

[filepath,name,ext] = fileparts(fn);
fn_out = sprintf('%s%s%s%s',filepath,name,'_roi','.png');

im2 = imread(fn);

n = size(xy,1);
for i = 1:n
    row = round(xy(i,2)*size(im2,1));
    col = round(xy(i,1)*size(im2,2));
    mark_location;
end

imwrite(im2,fn_out)

return

    function mark_location
        for i = -5:+5
            im2(row+i,col,1:3) = [0 0 255]; % blue
            im2(row,col+i,1:3) = [0 0 255]; % blue
        end
    end

end

