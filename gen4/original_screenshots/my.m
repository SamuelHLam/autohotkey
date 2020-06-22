allfile = dir

for i=1:size(allfile,1)
    if allfile(i,1).isdir
        allfile(i,1).name
    end
end