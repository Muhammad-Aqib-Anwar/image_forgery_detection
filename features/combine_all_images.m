

inpath1 ='/Users/apple/Downloads/data-images/all_images/Nikon_D7000/real'; %rgb images
outpath1 ='/Users/apple/Downloads/data-images/all_images/all_images/real/real000' ;


im_dir = dir(fullfile(inpath1,'*.png'));
image_names=natsort({im_dir.name});

for ij= 1:length(image_names)
    ij
    im = fullfile(inpath1,image_names{ij});
    Im = imread(im);
%     figure,imshow(Im)
    newdata1=[outpath1,num2str(ij+1424),'.png'] ;
    imwrite(Im,newdata1)
end