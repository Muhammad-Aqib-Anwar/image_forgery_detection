inpath1= '/Users/apple/Downloads/data-images/all_images/new_dataset/real' ;
inpath2= '/Users/apple/Downloads/data-images/all_images/new_dataset/fake'
% im_dir = dir(fullfile(inpath,'*.mat'));
% image_names= {im_dir.name};
outpath = '/Users/Shared/Relocated Items/Security/thesis/Data' ;
srcStruc = dir(fullfile(inpath1,'*.mat'));
srcFiles = natsort({srcStruc.name});
for k = 1:numel(srcFiles)
    k
    if k >599
    F = fullfile(inpath1,srcFiles{k});
    I = load(F);
    else    
    F = fullfile(inpath2,srcFiles{k});
    I = load(F);
    end
    I=im2double(I);
    feat = reshape(im,size(im,1)*size(im,2),6);
end
disp('Done');

