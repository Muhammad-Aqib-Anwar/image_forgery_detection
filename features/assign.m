
inpath1 ='/Users/apple/Downloads/data-images/all_images/Sony_57/tempered_400*400' ;
inpath2 ='/Users/apple/Downloads/data-images/all_images/Sony_57/gt_400*400' ;
outpath1='/Users/apple/Downloads/data-images/all_images/all_images/fake/fake000' ;
outpath2 = '/Users/apple/Downloads/data-images/all_images/all_images/real/real000' ;

im_dir1 = dir(fullfile(inpath1,'*.png'));
image_names1= natsort({im_dir1.name});

im_dir2 = dir(fullfile(inpath2,'*.png'));
image_names2= natsort({im_dir2.name});
i=1;
j=1;
for I1 = 1:length(image_names1)

    im1 = fullfile(inpath1,image_names1{I1});
    Im1 = imread(im1);
    Img=rgb2gray(Im1) ;

    
% for I2 = 1: length(image_names2)
        
     im2 = fullfile(inpath2,image_names2{I1});
     Im2 = imread(im2);
     
        
    compare_images = imabsdiff(Img,Im2);
%     figure;
   % imshow(compare_images);
   % title('compare_images');
    %comp1 = imshowpair(X_1,X_2,'diff');
    Im2=im2double(Im2);
%     ctr=0 ;
%     for i =1:size(Im2,1)
%          for j =1:size(Im2,2)
%              if Im2(i,j)==1
%                  ctr = ctr+1 ;
%              end
%          end
%     end
    count1=sum(Im2(:)==1)  ; %get the number of pixel forged 
    count2 = floor(count1/10) ;% %age of the pixel we found forged
    
    if(count1>count2)
        newdata1=[outpath1,num2str(i+767),'.png'] ;
        imwrite(Im1,newdata1)
        i = i+1 ;
    else
        
     newdata2=[outpath2,num2str(j+1708),'.png'] ;
%      save(newdata2,'Im1')
     imwrite(Im1,newdata2)
      j=j+1 ;
    end
% end
end 