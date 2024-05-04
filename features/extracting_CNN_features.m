%  function extracting_CNN_features(VOCopts)

% cd /Stanford40/matconvnet-1.0-beta18
addpath '/Users/Shared/Relocated Items/Security/thesis/code' ;
cd  '/Users/Shared/Relocated Items/Security/thesis/matconvnet-1.0-beta18'
%   net = load('imagenet-vgg-verydeep-16.mat') ;
net = load('imagenet-vgg-verydeep-19.mat') ;% trained model on imagenet dataset
% run Stanford/matconvnet-1.0-beta18/matlab/vl_setupnn.m
run '/Users/Shared/Relocated Items/Security/thesis/matconvnet-1.0-beta18/matlab/vl_setupnn.m'
% addpath /Users/Shared/Relocated Items/Security/thesis/matconvnet-1.0-beta18/matlab/simplenn/vl_simplenn.m
% fname = '/Users/Shared/Relocated Items/Security/thesis/Dataset/Label_CD60/';
% fname = '/Users/Shared/Relocated Items/Security/thesis/Dataset/Label_Sony_A57/';
% fname = '/Users/Shared/Relocated Items/Security/thesis/Dataset/Label_CD60/';
% image_names=getfield(load([fname,'image_names.mat']),'image_names');
% labels = getfield(load([fname,'labels']),'labels');
% trainset = getfield(load([fname,'/','trainset']),'trainset');
% testset = getfield(load([fname,'/','testset']),'testset');
% pos_dir = '/Users/apple/Downloads/data-images/Sony_A57/real';
% pos_dir = '/Users/apple/Downloads/data-images/all_images/images800*1200/real'
% neg_dir = '/Users/apple/Downloads/data-images/Canon_60D/fake';
% addpath /thesis/Dataset/all_images/pristine
% inpath1 ='/Users/apple/Downloads/CASIA1/Sp'  ;
% inpath2 ='/Users/apple/Downloads/CASIA1/Au'  ;
inpath1 ='/Users/apple/Downloads/CASIA2/all_images'; %rgb images
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
%% Initialize the directory structure
% opts = VOCopts;
% load(opts.image_names)
% load(VOCopts.image_names)
%% for extracting features using convolutional layers (avoid fixed size image)
% net = load('imagenet-vgg-s.mat') ;
% net_new=net;
% net_new.layers={};
% % for ll=1:31
% for ll=1:21
%     net_new.layers{ll}=net.layers{ll};
% end
% net = net_new;
All_hist = [];
 for i = 1:length(image_names)
%     i
%     img = imread(sprintf(VOCopts.imgpath,image_names{i}(1:end-4)));
%      img = imread('F3_PRNU.jpg') ;
      i
       im = fullfile(inpath1,image_names{i});
       img = imread(im);
%     if (i<=921) 
%         im1 = fullfile(inpath1,image_names{i});
%         img = imread(im1);
%     else
%         im1 = fullfile(inpath2,image_names{i});
%         img = imread(im1);
%    
%     end
    img=color(img);    
    %% Do compute deep features using Matconvnet
    im_ = single(img) ; % note: 255 range
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
%     im_ = im_ - net.meta.normalization.averageImage ;
%     
%     A_mask=ones(size(im_,1),size(im_,2),3);
%     A_mask(:,:,1)=net.meta.normalization.averageImage(1,1,1);
%     A_mask(:,:,2)=net.meta.normalization.averageImage(1,1,2);
%     A_mask(:,:,3)=net.meta.normalization.averageImage(1,1,3);
%     im_ = im_ - A_mask ;
%     if( size(im_,1)<35) || (size(im_,2)< 35)
%         im_ = single(im_orig) - A_mask ;
%         if( size(im_,1)<35) || (size(im_,2)< 35)
%             im_  = padarray(im_ ,[30 30],'replicate','post');
%         end
%     end
    res = vl_simplenn(net, im_);
    AA=res(1,31).x; %% for vgg-deep-16
%     AA=res(1,13).x; %% for vgg-f
%     AA=res(1,36).x; %% for vgg-f
    AA1=double(reshape(AA,size(AA,1)*size(AA,2),size(AA,3)));
%   AA1=double(AA1);  
    
    All_hist=[All_hist,AA1']; 
 end
%5 normalize the histograms 
%All_hist=All_hist./norm(All_hist);
%All_hist=All_hist';
% save_dir = '/Stanford40/VOCdevkit/Data1/Data1';
fname='/Users/Shared/Relocated Items/Security/thesis/DVMM_histogram';
save ([fname,'/','silency_image_CNN_VGG16_Hist16'],'-v7.3','All_hist');
disp('done');