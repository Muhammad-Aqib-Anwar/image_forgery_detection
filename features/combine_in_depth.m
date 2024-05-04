%% combine the images in depth
inpath1 = '/Users/apple/Downloads/data-images/all_images_HCO/lbp/fake' ;% featured image
inpath2 = '/Users/apple/Downloads/data-images/all_images_HCO/ycbcr/fake' ;
inpath3 ='/Users/apple/Downloads/data-images/all_images_HCO/image-energy/fake' ;
outpath1 ='/Users/apple/Downloads/data-images/all_images_HCO/deph_yle/fake/fake0000' ;

im_dir1 = dir(fullfile(inpath1,'*.png'));
image_names1=natsort({im_dir1.name});

im_dir2 = dir(fullfile(inpath2,'*.png'));
image_names2=natsort({im_dir2.name});

im_dir3 = dir(fullfile(inpath3,'*.png'));
image_names3=natsort({im_dir3.name});

for i= 1:length(image_names1)
    i
    im1 = fullfile(inpath1,image_names1{i});
    Im1 = imread(im1);
   
  
    im2 = fullfile(inpath2,image_names2{i});
    Im2 = imread(im2);
    Im2=rgb2gray(Im2) ;
    
    Im3 = fullfile(inpath3,image_names3{i});
    Im3 = imread(Im3);
    
    img=cat(3,Im1,Im2,Im3) ;
%   figure,imshow(img)
    newdata1=[outpath1,num2str(i),'.png'] ;
    imwrite(img,newdata1)
end