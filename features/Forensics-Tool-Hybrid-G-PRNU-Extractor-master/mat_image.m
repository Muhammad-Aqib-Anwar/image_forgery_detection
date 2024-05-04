inpath= '/Users/apple/Downloads/data-images/all_images/crop_pristine_level4_prnu' ;
im_dir = dir(fullfile(inpath,'*.mat'));
% image_names= {im_dir.name};
outpath = '/Users/apple/Downloads/data-images/all_images/crop_pristine_level4_prnu_img/real_prnu_' ;
Inputs = natsort{im_dir.name}';
Outputs = Inputs;
for k = 1:numel(im_dir)
    k
    F = fullfile(inpath,im_dir(k).name);
    I = load(F);
%     figure , imshow(I.diffImSum)
    image=I.diffImSum ;
    idx = k; % index number
%   Outputs{k} = regexprep(Outputs{k}, 'big', ['small_' num2str(idx)]);
    newimagename = [outpath num2str(k) '.png'];
%   imwrite(I.diffImSum, [outpath Outputs{k}],'.jpg')
    imwrite(image,newimagename)
end
disp('Done');
% imwrite(I,'res10.PNG')

% diffName = fullfile(outpath, [prnuName{1} '.mat']);
% save(diffName, 'diffImSum');
    