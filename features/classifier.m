%% image classfication using CNN
path= '/thesis/Dataset/' ;
im_dir = dir(fullfile(path,'*.jpg'));
% image_names= {im_dir.name};

for k = 1:numel(im_dir)
    F = fullfile(path,im_dir(k).name);
    I = imread(F);
    imshow(I)
%     S(k).data = I; % optional, save data.
end
norm_im=normalize(I) ;
im=im2double(norm_im) ;
figure ,imshow(im,[])