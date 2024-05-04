function All_hist_level0=Do_Compute_Histograms_each_window_image_Action(img,mapping5,mapping2,mapping4)
load w2c.mat
All_hist_level0=[];
% compute PHOG Bosch
bin = 40;
angle = 360;
L=3;
roi = [1;size(img,1);1;size(img,2)];




% Complete LBP CLBP
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),2,16,mapping5,'nh');
% All_hist_lbp_C1_2=[(index_lbp_try3),(index_lbp_try4)];
% 
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),4,16,mapping5,'nh');
% All_hist_lbp_C1_3=[(index_lbp_try3),(index_lbp_try4)];
% 
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),1,16,mapping5,'nh');
% All_hist_lbp_C1_4=[(index_lbp_try3),(index_lbp_try4)];
% 
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),6,16,mapping5,'nh');
% All_hist_lbp_C1_5=[(index_lbp_try3),(index_lbp_try4)];


%% new modified 
[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),2,16,mapping5,'nh');
All_hist_lbp_C1_2=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),3,16,mapping5,'nh');
All_hist_lbp_C1_3=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),1,16,mapping5,'nh');
All_hist_lbp_C1_4=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),4,16,mapping5,'nh');
All_hist_lbp_C1_5=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),5,16,mapping5,'nh');
All_hist_lbp_C1_6=[(index_lbp_try3),(index_lbp_try4)];

% 8 pixel
[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),2,8,mapping2,'nh');
All_hist_lbp_C1_7=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),3,8,mapping2,'nh');
All_hist_lbp_C1_8=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),1,8,mapping2,'nh');
All_hist_lbp_C1_9=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),4,8,mapping2,'nh');
All_hist_lbp_C1_10=[(index_lbp_try3),(index_lbp_try4)];

[index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),5,8,mapping2,'nh');
All_hist_lbp_C1_11=[(index_lbp_try3),(index_lbp_try4)];

% 20 pixel
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),2,20,mapping4,'nh');
% All_hist_lbp_C1_8=[(index_lbp_try3),(index_lbp_try4)];
% 
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),3,20,mapping4,'nh');
% All_hist_lbp_C1_9=[(index_lbp_try3),(index_lbp_try4)];
% 
% [index_lbp_try3,index_lbp_try4]=Do_CellCLBP(im2double((sum(img,3)/3)),1,20,mapping4,'nh');
% All_hist_lbp_C1_10=[(index_lbp_try3),(index_lbp_try4)];






All_hist_level0=[All_hist_lbp_C1_2,All_hist_lbp_C1_3,All_hist_lbp_C1_4,All_hist_lbp_C1_7,All_hist_lbp_C1_8,All_hist_lbp_C1_9];