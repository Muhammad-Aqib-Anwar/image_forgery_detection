fname = '/thesis/Dataset/all_images/label/';
image_names=getfield(load([fname,'image_names_orig.mat']),'image_names');
labels = getfield(load([fname,'labels']),'labels');
trainset = getfield(load([fname,'/','trainset']),'trainset');
testset = getfield(load([fname,'/','testset']),'testset');
pos_dir = '/thesis/Dataset/all_images/pristine';
neg_dir = '/thesis/Dataset/all_images/tempered';
addpath '/thesis/code/color_name' ;
All_hist= [];
level = 4 ; 
for ij = 1:length(image_names)
    ij
    if ij >220
        im = imread([neg_dir,'/',image_names{ij}]);
    else
        im = imread([pos_dir,'/',image_names{ij}]);
    end
    im=im2double(im); 
    feat_pyra=[];
[h,w,c]=size(im);

    for i=1:level 
        for  ii = 1:i
            for j = 1:i 
                x_lo = (w/i)*(ii-1)+1;
                x_hi = (w/i)*ii;
                y_lo = (h/i)*(j-1)+1;
                y_hi = (h/i)*j;
                patch = im(y_lo:y_hi,x_lo:x_hi,:);
                load w2c;
                index1=im2c(patch*255,w2c,-2);
                feat= reshape(index1,size(index1,1)*size(index1,2),11);
                feat = feat./size(feat,1);
                feature= sum(feat,1);
                feat_pyra{i}{ii,j} = feature ;
              
    
            end
        end        
    end



%% display('done');
pyramid =[];
   for l =1:length(feat_pyra)
       pyramid=[pyramid;feat_pyra{l}(:)] ;
   end
   feat = {cat(2,pyramid{:})} ;
    All_hist{ij} = feat;
end 

save_dir = '/thesis/Data' ;
save ([save_dir,'/','All_hist_','color_name'],'All_hist');
display('done');