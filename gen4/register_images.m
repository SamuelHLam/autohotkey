% 3-25-2020
% image registration
% r = register_images('target.png','trial.png');

function regT = register_images (fn_target, fn_trial)

imtarget = imread(fn_target);
imtrial = imread(fn_trial);

reg = registerImages(imtrial,imtarget);
regT = reg.Transformation.T;

save('reg','reg')

end
