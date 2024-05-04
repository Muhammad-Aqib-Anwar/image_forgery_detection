function All_hist_level0=Do_Compute_Histograms_each_window_image_Texture(img,mapping5)
load w2c.mat

% addpath /home/cic/fahad/Matlab_code/Texture_LBP
filename=['/home/cic/fahad/Matlab_code/Texture_LBP/texturefilters/ICAtextureFilters_11x11_8bit'];
load(filename, 'ICAtextureFilters');

All_hist_level0=[];
% compute PHOG Bosch
% bin = 40;
% angle = 360;
% L=3;
% roi = [1;size(img,1);1;size(img,2)];
% 
% p = anna_phog(img,bin,angle,L,roi);
% All_hist_phog=p';
% 


% Complete LBP CLBP
[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),2,16,mapping5,'nh');
All_hist_lbp_C1_2=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),4,16,mapping5,'nh');
All_hist_lbp_C1_3=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),1,16,mapping5,'nh');
All_hist_lbp_C1_4=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),6,16,mapping5,'nh');
All_hist_lbp_C1_5=[(index_lbp_try3),(index_lbp_try4)];





% recently added
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),2,8,mapping6,'nh');
% All_hist_lbp_C1_22=[index_lbp_try3,index_lbp_try4];
%
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),4,8,mapping6,'nh');
% All_hist_lbp_C1_33=[index_lbp_try3,index_lbp_try4];
%
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),1,8,mapping6,'nh');
% All_hist_lbp_C1_44=[index_lbp_try3,index_lbp_try4];



% compute wld descriptor
te1= Do_WLD_Faces(img,8);
All_hist_wld=(te1);



% Gabor binary pattern descriptor
[tHist_BGP] = BGP(im2double((sum(img,3)/3)));



% LPQ
LPQhist = lpq(img,3);


%BSIFT (ICPR 2012)

bsifhistnorm=bsif_Texture(img, ICAtextureFilters,'nh');



% All_hist_level0=[All_hist_lbp_C1_2,All_hist_lbp_C1_3,All_hist_lbp_C1_4,All_hist_lbp_C1_5,All_hist_wld,tHist_BGP',LPQhist,bsifhistnorm];
All_hist_level0=[All_hist_lbp_C1_2,All_hist_lbp_C1_3,All_hist_lbp_C1_4,All_hist_lbp_C1_5];


% All_hist_level0=[All_hist_lbp_C1_2,All_hist_lbp_C1_3,All_hist_lbp_C1_4,All_hist_lbp_C1_5];
% All_hist_level0=[bsifhistnorm];