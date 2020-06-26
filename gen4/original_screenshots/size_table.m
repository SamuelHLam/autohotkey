fpattern = fullfile(pwd,'**/40x*');
files = dir(fpattern);
sizes = cell(198,1);
for i = 1:length(files)
    fname = fullfile(files(i).folder,files(i).name);
    new_row = {fname, imfinfo(fname).Width, imfinfo(fname).Height};
    sizes{i} = new_row;
end
save('size_table.mat','sizes');