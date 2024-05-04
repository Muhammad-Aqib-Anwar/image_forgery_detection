
%%
fname = '/thesis/Dataset/all_images/label/';
image_names=getfield(load([fname,'image_names_prnu.mat']),'image_names');
labels = getfield(load([fname,'labels']),'labels');
trainset = getfield(load([fname,'/','trainset']),'trainset');
testset = getfield(load([fname,'/','testset']),'testset');
pos_dir = '/thesis/Dataset/all_images/pristine_prnu';
neg_dir = '/thesis/Dataset/all_images/tempered_prnu';
All_hist= [];
for i = 1:length(image_names)
    i
    if i >220
        im = imread([neg_dir,'/',image_names{i}]);
    else
        im = imread([pos_dir,'/',image_names{i}]);
    end
    im=im2double(im);
    %%  features '
    im = cat(3, im, im, im);
    feat = reshape(im,size(im,1)*size(im,2),3);
%     feat=reshape(im,[],2) ;
    feat_norm=feat./size(feat,1);
    feature=sum(feat_norm,1);
    %5 collection of features 
    All_hist=[All_hist;feature];
    
end
%%  
%All_hist 
save_dir = '/thesis/Data' ;
save ([save_dir,'/','All_hist_','prnu'],'All_hist');
display('done');