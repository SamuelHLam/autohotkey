insight_sizes = zeros(22,6);
ims_sizes = zeros(22,6);

insight_chrome = fullfile(pwd,'**/40x-insight-chrome.png');
insight_firefox = fullfile(pwd,'**/40x-insight-firefox.png');
insight_edge = fullfile(pwd,'**/40x-insight-edge.png');

ims_chrome = fullfile(pwd,'**/40x-ims-1-chrome.png');
ims_firefox = fullfile(pwd,'**/40x-ims-1-firefox.png');
ims_edge = fullfile(pwd,'**/40x-ims-1-edge.png');

ins_c_files = dir(insight_chrome);
ins_f_files = dir(insight_firefox);
ins_e_files = dir(insight_edge);

ims_c_files = dir(ims_chrome);
ims_f_files = dir(ims_firefox);
ims_e_files = dir(ims_edge);

for i = 1:22
    ins_c_fname = fullfile(ins_c_files(i).folder,ins_c_files(i).name);
    ins_f_fname = fullfile(ins_f_files(i).folder,ins_f_files(i).name);
    ins_e_fname = fullfile(ins_e_files(i).folder,ins_e_files(i).name);
    
    x1 = imfinfo(ins_c_fname).Width;
    y1 = imfinfo(ins_c_fname).Height;
    x2 = imfinfo(ins_f_fname).Width;
    y2 = imfinfo(ins_f_fname).Height;
    x3 = imfinfo(ins_e_fname).Width;
    y3 = imfinfo(ins_e_fname).Height;
    
    insight_sizes(i,:) = [x1,y1,x2,y2,x3,y3];
    
    ims_c_fname = fullfile(ims_c_files(i).folder,ims_c_files(i).name);
    ims_f_fname = fullfile(ims_f_files(i).folder,ims_f_files(i).name);
    ims_e_fname = fullfile(ims_e_files(i).folder,ims_e_files(i).name);
    
    x1 = imfinfo(ims_c_fname).Width;
    y1 = imfinfo(ims_c_fname).Height;
    x2 = imfinfo(ims_f_fname).Width;
    y2 = imfinfo(ims_f_fname).Height;
    x3 = imfinfo(ims_e_fname).Width;
    y3 = imfinfo(ims_e_fname).Height;
    
    ims_sizes(i,:) = [x1,y1,x2,y2,x3,y3];
   
end
save('insight_size_table.mat','insight_sizes');
save('ims_size_table.mat','ims_sizes');