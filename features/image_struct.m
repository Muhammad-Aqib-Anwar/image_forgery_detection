
% % images names 
% image_names =dir(fullfile('/home/saadi/Desktop/Thesis/Person Dataset/Data/','*.jpg'));  % to get the names of all images of jpg images 
% image_names =dir(fullfile('/home/saadi/Desktop/Thesis/Person_Dataset/Data/','*.jpg'))
% pos_im = dir(fullfile('/Users/apple/Downloads/data-images/all_images/all_images/real','*.png'));
pos_im = dir(fullfile('/Users/apple/Downloads/ImSpliceDataset/Au-S','*.bmp'));
% pos_im = dir(fullfile('/Users/apple/Downloads/Casai1/Au','*.jpg'));
% pos_im1 = dir(fullfile('/Users/apple/Downloads/CASIA2/Au','*.jpg'));
% pos_im2 = dir(fullfile('/Users/apple/Downloads/CASIA2/Au','*.bmp'));
pos_images= {pos_im.name};
% pos_images2= {pos_im2.name};
% neg_im = dir(fullfile('/Users/apple/Downloads/data-images/all_images/all_images/fake','*.png'));
neg_im = dir(fullfile('/Users/apple/Downloads/ImSpliceDataset/Sp-S','*.bmp'));
% neg_im = dir(fullfile('/Users/apple/Downloads/Casai1/Sp','*.jpg'));
% neg_im1 = dir(fullfile('/Users/apple/Downloads/CASIA2/Tp','*.jpg'));
% neg_im2 = dir(fullfile('/Users/apple/Downloads/CASIA2/Tp','*.tif'));
neg_images= {neg_im.name};
% neg_images2= {neg_im2.name};
% image_names = [pos_images1,pos_images2,neg_images1,neg_images2]';
image_names = [pos_images,neg_images]';
%% labels  to be assigned to each images either it belong to trainset or testset

labels = zeros(length(image_names),2);  %% contain ground-truth information . Since we are dealing a 2 class problem. the labels will be a set of : {0,1}.

trainset = zeros(length(image_names),1); %%% Given a dataset, we take a set of images. This set will be called "trainset". The training set images are mutually exlusive to test images. 

testset=zeros(length(image_names),1);

% labels(1:7491,1)=1;
% labels(7492:end,2)=1;

% labels(1:2278,1)=1;
% labels(2279:end,2)=1; %korus data

labels(1:933,1)=1;
labels(934:end,2)=1;
% labels(1:800,1)=1;
% labels(801:end,2)=1;
%% for testing from real class
n=2523 %casai2
% n = 165;
%n=660 ; %%korus dataset test images
% n=345 ;
 n=369; 
testset(randperm(numel(testset), n)) = 1;
%% for training 
AA=find(testset<1);
trainset(AA,:)=1;

% trainset(1:150,:)=1;
% trainset(200:350,:)=1;
% trainset(400:550,:)=1;
% trainset(575:700,:)=1;
% trainset(725:825,:)=1;
% 
% AA=find(trainset<1);
% testset(AA,:)=1;
%5 labels folder
fname = '/Users/Shared/Relocated Items/Security/thesis/DVMM_label';
%fname = '/Users/Shared/Relocated Items/Security/thesis/casai_label';
% fname = '/Users/Shared/Relocated Items/Security/thesis/Dataset/all_images/' ;
% fname = '/Users/Shared/Relocated Items/Security/thesis/casia2_label/' ;
save([fname,'/','image_names'],'image_names');
save([fname,'/','labels'],'labels');
save([fname,'/','trainset'],'trainset');
save([fname,'/','testset'],'testset');   
disp('done');