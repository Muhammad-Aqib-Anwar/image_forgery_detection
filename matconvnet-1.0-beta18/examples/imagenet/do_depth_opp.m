function [c_opp_Depth_image,O_Depth_image,op,op_c]=do_depth_opp(img)

[O1,O2,O3] = RGB2O(img);
w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;

% c_opp_Depth_image = cat(3,w1,w2,img_data); %copp_depth
% O_Depth_image = cat(3,O1,O2,img_data);% opp-depth
op = cat(3,O1,O2,O3); % opp only
op_c = cat(3,w1,w2,O3); % copp only