function [H1]=Do_compute_lbp(im)
% fname = '/Users/Shared/Relocated Items/Security/thesis/Dataset/all_images/label/';
% image_names=getfield(load([fname,'image_names_orig.mat']),'image_names');
% labels = getfield(load([fname,'labels']),'labels');
% trainset = getfield(load([fname,'/','trainset']),'trainset');
% testset = getfield(load([fname,'/','testset']),'testset');
% pos_dir = '/thesis/Dataset/all_images/pristine';
% neg_dir = '/thesis/Dataset/all_images/tempered';
% All_hist= [];
mapping=getmapping(8,'u2'); 

% for ij = 1:length(image_names)
%     ij
%     if ij >220
%         im = imread([neg_dir,'/',image_names{ij}]);
%     else
%         im = imread([pos_dir,'/',image_names{ij}]);
%     end
      im=im2double(im); 
      I=color(im);
      I=sum(I,3)/3 ;
      I=padarray(I,[2,2],'replicate','post');
%       SP=[-1 -1; -1 0];
      SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];

      H1=lbp(I,SP,8,mapping,'hist');
%      H1=lbp(I,SP,0,'i');
%      H1=lbp(I,1,8,mapping,'h');
%      H1=lbp(I)


     

    
           
       
%     All_hist=[All_hist;H1];
% end

 

% save_dir = '/thesis/Data' ;
% save ([save_dir,'/','All_hist_','lbp'],'All_hist');
display('done');
end