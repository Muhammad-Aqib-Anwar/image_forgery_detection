inpath1 ='/Users/apple/Downloads/data-images/all_images_HCO/lbp/fake/'  ;
inpath2 ='/Users/apple/Downloads/data-images/all_images_HCO/lbp/real/'  ;
im_dir1 = dir(fullfile(inpath1,'*.png'));
image_names1= natsort({im_dir1.name});

im_dir2 = dir(fullfile(inpath2,'*.png'));
image_names2= natsort({im_dir2.name});
image_names = [image_names1,image_names2]';
All_hist=[];
for I1 = 1:length(image_names)
    I1
    if (I1<=1022) 
        im1 = fullfile(inpath1,image_names{I1});
        Im1 = imread(im1);
%         Im1=rgb2gray(Im1) ;
    else
        im1 = fullfile(inpath2,image_names{I1});
        Im1 = imread(im1);
%         Im1=rgb2gray(Im1) ;
   
    end
   
    Im=im2double(Im1) ;
%     AA1=double(reshape(Im,size(Im,1)*size(Im,2),size(Im,3)));
%     Im=reshape(permute(Im, [3 1 2]), [], size(Im, 2));
    All_hist=[All_hist;Im];
    
end
%  All_hist=reshape(permute(All_hist, [3 1 2]), [], size(All_hist, 2));
fname='/Users/Shared/Relocated Items/Security/thesis/Histogram/all_images';
% save ([fname,'/','all_lbp_400*400','-v7.3'],'All_hist');
save ([fname,'/','lbp_HandCrafted_all'],'-v7.3','All_hist');
disp('done')