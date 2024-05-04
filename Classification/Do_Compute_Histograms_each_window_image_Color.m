function All_hist_level0=Do_Compute_Histograms_each_window_image_Color(img)
% load w2c.mat
load DD50_w2c.mat

All_hist_level0=[];



%% Color Names (Joost TIP 2009)
% sigma=2;
% index1=im2c(img*255,w2c,-2); % compute the probability of the color names for all pixels
% % if(sigma~=0)
% %     index1=color_gauss(index1,sigma,0,0);
% % end
% index1=reshape(index1,[],11);
% cct1=index1;
% cct1_norm=cct1./size(cct1,1);
% All_hist_level0=sum(cct1_norm,1);

%% Discriminative color names (CVPR 2013)
index1=im2c(img*255,w2c,-2); % compute the probability of the color names for all pixels
index1=reshape(index1,[],50);
cct1=index1;
cct1_norm=cct1./size(cct1,1);
% cct1_norm=cct1;
All_hist_level0=sum(cct1_norm,1);

%% HUE descriptor (Joost ECCV 2006)
% half_size=floor(8/2);
% sigma=half_size/2;
% sigma_xy=sigma;
% number_of_bins=36;
% sigma_z=3;
% lambda=1;
% cct=DenseHueDescriptor2(img,number_of_bins,sigma_xy,sigma_z);
% % cct=DenseOpponentDescriptor(img,number_of_bins,sigma,sigma_z,lambda);
% cct1=reshape(cct,size(cct,1)*size(cct,2),36);
% cct1_norm=cct1./size(cct1,1);
% All_hist_level0=sum(cct1_norm,1);

%% SO descriptor (Serre ECCV 2012)
% s = SODescriptor(img);
% index1=reshape(s,size(s,1),size(s,2),8);
% index1=reshape(index1,[],8);
% cct1=index1;
% cct1_norm=cct1./size(cct1,1);
% All_hist_level0=sum(cct1_norm,1);

%% HS descriptor
% index22=rgb2hsv(img);
% 
% 
% H_int=ceil(index22(:,:,1).*9);
% H_int=replace(H_int,[0],[1]);
% S_int=ceil(index22(:,:,2).*4);
% S_int=replace(S_int,[0],[1]);
% index2=H_int+(S_int-1).*9;
% cct1=reshape(index2,size(index2,1)*size(index2,2),1);
% patch_im=hist(cct1,1:36);
% % cct1_norm=cct1./size(cct1,1);
% All_hist_level0=normalize(patch_im);
