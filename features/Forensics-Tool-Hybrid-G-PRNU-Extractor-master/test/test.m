addpath '/Users/apple/Downloads/Forensics-Tool-Hybrid-G-PRNU-Extractor-master/Images' ;
addpath '/Users/apple/Downloads/Forensics-Tool-Hybrid-G-PRNU-Extractor-master/PRNU_r' ;
addpath '/Users/apple/Downloads/Forensics-Tool-Hybrid-G-PRNU-Extractor-master/PRNU_t' ;
addpath '/Users/apple/Downloads/Forensics-Tool-Hybrid-G-PRNU-Extractor-master/Images' ;
load('D07_0_nearest_N1_im1_t_M_L.mat')
img_p=diffImSum ;
load('D07_0_nearest_N1_im1_M_L.mat')
img_t=diffImSum ;
orig=imread('im1_t_mask.bmp') ;
diff=img_p-img_t;
figure,imshow(diff)
threshold = graythresh(diff);
diff_bw = im2bw(diff, threshold);
figure,imshow(diff_bw)
 
% newimg = imclose(diff, strel('disk', 3));
% figure,imshow(newimg)

newimg = imclose(diff_bw, strel('disk', 3));
figure,imshow(newimg)
 
im_h=imfill(newimg,'holes');
figure,imshow(im_h)

%to resize the imgae 
outputImage = imresize(im_h, size(im_h));
%to save the image
imwrite(outputImage,'res10.PNG')

close all , clc , clear all