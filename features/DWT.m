function [First_Level_Decomposition]=DWT(img)

Input_Image=img;

Red_Input_Image=Input_Image(:,:,1);
Green_Input_Image=Input_Image(:,:,2);
Blue_Input_Image=Input_Image(:,:,3);



%Apply Two Dimensional Discrete Wavelet Transform

[LLr,LHr,HLr,HHr]=dwt2(Red_Input_Image,'haar');
LLr=(LLr-min(LLr(:)))/(max(LLr(:))-min(LLr(:))) ;

[LLg,LHg,HLg,HHg]=dwt2(Green_Input_Image,'haar');
LLg=(LLg-min(LLg(:)))/(max(LLg(:))-min(LLg(:))) ;

[LLb,LHb,HLb,HHb]=dwt2(Blue_Input_Image,'haar');
LLb=(LLb-min(LLb(:)))/(max(LLb(:))-min(LLb(:))) ;

First_Level_Decomposition(:,:,1)=[LLr,LHr;HLr,HHr];
First_Level_Decomposition(:,:,2)=[LLg,LHg;HLg,HHg];
First_Level_Decomposition(:,:,3)=[LLb,LHb;HLb,HHb];


%Display Image
% imshow(First_Level_Decomposition)
% subplot(1,2,1);imshow(Input_Image);title('Input Image');
% subplot(1,2,2);imshow(First_Level_Decomposition);title('First Level Decomposition');
end

% im=rgb2gray(Input_Image) ; 
% X=img ; 
% [LoD,HiD] = wfilters('haar','d');
% [cA,cH,cV,cD] = dwt2(X,LoD,HiD,'mode','symh');
% subplot(2,2,1)
% imagesc(cA)
% colormap gray
% title('Approximation')
% subplot(2,2,2)
% imagesc(cH)
% colormap gray
% title('Horizontal')
% subplot(2,2,3)
% imagesc(cV)
% colormap gray
% title('Vertical')
% subplot(2,2,4)
% imagesc(cD)
% colormap gray
% title('Diagonal')