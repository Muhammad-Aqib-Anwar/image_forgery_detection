
%inpath1 ='/Users/apple/Downloads/ImSpliceDataset/Au-S'; %rgb images
% inpath1 ='/Users/apple/Downloads/CASIA1/Sp'; %real images
% inpath2 ='/Users/apple/Downloads/CASIA1/Au'; %tempered images
inpath1 ='/Users/apple/Downloads/CASIA2/all_images';
inpath2='/Users/apple/Downloads' ; %for PRNU

outpath1 ='/Users/apple/Downloads/CASIA2/dwt/img000' ;
addpath '/Users/Shared/Relocated Items/Security/thesis/code/CameraFingerprint' ;
addpath '/Users/Shared/Relocated Items/Security/thesis/code/CameraFingerprint/Functions'
addpath '/Users/Shared/Relocated Items/Security/thesis/code/Forensics-Tool-Hybrid-G-PRNU-Extractor-master';
addpath '/Users/apple/Downloads' ;
addpath '/Users/Shared/Relocated Items/Security/thesis/code/saliency-map' ;

im_dir1 = dir(fullfile(inpath1,'*.jpg'));
im_dir2 = dir(fullfile(inpath1,'*.bmp'));
im_dir3 = dir(fullfile(inpath1,'*.tif'));
image_names1=natsort({im_dir1.name});
image_names2=natsort({im_dir2.name});
image_names3=natsort({im_dir3.name});
image_names=[image_names1,image_names2,image_names3] ;
% im_dir1 = dir(fullfile(inpath1,'*.jpg'));
% image_names1= natsort({im_dir1.name});
% 
% im_dir2 = dir(fullfile(inpath2,'*.jpg'));
% image_names2= natsort({im_dir2.name});
% image_names = [image_names1,image_names2]';

% srcStruc = dir(fullfile(inpath2,'*.mat'));
% srcFiles = natsort({srcStruc.name});

counter = 1;
n_feature=6 ;
C=cell(n_feature,1) ;
All_hist=[];
% for ij= 1:length(image_names)
%     ij
%     im = fullfile(inpath1,image_names{ij});
    IM='fake000873.png' ;
    Im = imread('fake000873.png');
    Im=color(Im);
%      if (ij<=921) 
%         im1 = fullfile(inpath1,image_names{ij});
%         Im = imread(im1);
%     else
%         im1 = fullfile(inpath2,image_names{ij});
%         Im = imread(im1);
%    
%     end
%   figure, imshow(Im)
%% DWT
%      im_out1=DWT(Im) ;
%      im_out1=rgb2gray(im_out1) ;
%      im_out1=(im_out1-min(im_out1(:)))/(max(im_out1(:))-min(im_out1(:))) ;
      %% lbp 
    im_out3=double(Do_compute_lbp(Im)) ; %LBP
    im_out3=(im_out3-min(im_out3(:)))/(max(im_out3(:))-min(im_out3(:))) ;
    %% PRNU
%   run_lucasdigicamident(image_names{ij})%PRNU
    run_lucasdigicamident(IM)
    srcStruc = dir(fullfile(inpath2,'*.mat')); %for single img
    srcFiles = natsort({srcStruc.name});
    Filepath = fullfile(inpath2,srcFiles{1}); % for single img
%   Filepath = fullfile(inpath2,srcFiles{ij});
    
    I = load(Filepath);
    im_out2=I.diffImSum ;
    im_out2=(im_out2-min(im_out2(:)))/(max(im_out2(:))-min(im_out2(:))) ;
    %% cameraFinger Print and noise%% cameraFinger Print and noise
    [fingerprint,Noise,Cor]=Example(IM) ;%fingerprint % for single img
%     [fingerprint,Noise,Cor]=Example(im) ;%fingerprint
    fingerprint=(fingerprint-min(fingerprint(:)))/(max(fingerprint(:))-min(fingerprint(:)))  ;
     %% R G B channel of ycbcr
        Img=double(rgb2ycbcr(Im)) ;
        Img=(Img-min(Img(:)))/(max(Img(:))-min(Img(:))) ;
        im_out6=rgb2gray(Img);
        Y=double(Img(:,:,1)) ;
        Y=(Y-min(Y(:)))/(max(Y(:))-min(Y(:))) ;
        Cb=double(Img(:,:,2)) ;
        Cb=(Cb-min(Cb(:)))/(max(Cb(:))-min(Cb(:))) ;
        Cr=double(Img(:,:,3)) ;
        Cr=(Cr-min(Cr(:)))/(max(Cr(:))-min(Cr(:))) ;
      %% saliency map 
    im_out4=Run_SUN(Im) ;
    im_out4=imresize(im_out4,[400,400]);
    im_out4=(im_out4-min(im_out4(:)))/(max(im_out4(:))-min(im_out4(:))) ;
      %% image energy
    im_out5 =image_energy(Im) ;
    im_out5=(im_out5-min(im_out5(:)))/(max(im_out5(:))-min(im_out5(:))) ;
    %% fourier_transform
    im_out6=log(abs(ft(Im))) ;
    im_out6=(im_out6-min(im_out6(:)))/(max(im_out6(:))-min(im_out6(:))) ;
    %% combination of features in 1200*1200
%      C=[im_out2,fingerprint,im_out3;im_out4,im_out5,im_out1;Y,Cb,Cr ] ;
C=[{fingerprint},{im_out2},{im_out3},{im_out4},{im_out5},{im_out1},{Y},{Cb},{Cr} ] ;
%   out = cat(3, C{1,1}, C{1,2},C{1,3},C{1,4},C{1,5},C{1,6});
%   out=double([C{1,1}, C{1,2},C{1,3};C{1,4},C{1,5},C{1,6}]) ;
%     newdata1=[outpath1,num2str(ij),'.png'] ;
% %   save(newdata1,'out')
%     imwrite(im_out1,newdata1)

numBlocksYY = 3 ;
numBlocksXX=3 ;
figure;
for ii=1:length(C)
     subplot(numBlocksYY,numBlocksXX,ii), imagesc( C{ii} ); axis image; colormap gray ;
%     image=cell2mat(C(ii)) ;
%     newimagename = [outpath num2str(ii) '.png'];
%     imwrite(image,newimagename)
end
 
% end
% if(length(im_out1(:,1))==256 && length(im_out1(1,:))==384)  
%      image = im_out1;
% elseif(length(im_out1(:,1))==384 && length(im_out1(1,:))==256) 
%     image = im_out1';
% else
%     image=imresize(im_out1,[256,384]) ;


% end
All_hist=[All_hist;image];
% end
fname='/Users/Shared/Relocated Items/Security/thesis/casia2_histogram';
% % save ([fname,'/','all_lbp_400*400','-v7.3'],'All_hist');
save ([fname,'/','PRNU_HandCrafted_all'],'-v7.3','All_hist');
disp('DONE')
