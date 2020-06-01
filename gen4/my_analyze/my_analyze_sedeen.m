% compare all ROIs

obj = Viewer;

n_roi = size(obj.wsi_roi,1);

for i = 1:n_roi
    
    % define filenames
    fn_target = sprintf('%s\\%03d\\%s',obj.current_dir,i,'ndp.png');
    fn_trial = sprintf('%s\\%03d\\%s',obj.current_dir,i,'sedeen.png');

    compare_roi (fn_target, fn_trial)
end
