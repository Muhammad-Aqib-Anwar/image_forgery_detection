function []=Do_Detection_Pascal2007_New1(opts,classification_opts)

% if nargin<2
%     classification_opts=[];
% end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end              
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';                 end

%%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
 load(opts.data_locations);
 load(opts.testset)
 load(opts.image_names)
 nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
counter=1;
counter_img=1;
parameter_final_retrain=0;
% counter_rand=1;
counter_retrain=1;
histogram_test=[];
histogram_test_random=[];
histogram_all_retrain=[];
histogram_all_select_random=[];

%% Do the Model Training by Loading the computed Training Histogram Histogram
       
 display('%%% STARTING TO LAERN THE INITIAL MODEL %%%');
 best_C=20;
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.trainhist_name]),'All_hist');
 train_truth=getfield(load([opts.data_assignmentpath,'/',classification_opts.traintruth_name]),'train_truth');
%  model=Do_Model_train_Det(histogram',train_truth,best_C,parameter_final_retrain);
 display('%%% The Initial Model is Computed %%%');
 pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Model is Trained %%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Do Retraining to Pick Hard negative Examples by Testing on Negative Examples

if(classification_opts.model_retrain)
    display('%%% Loading the model %%%');
    model=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/BOW_Model_final'),'model');
    display('%%% Starting to collect Hard Negative Examples %%%');
    classification_opts.distribution_windows=classification_opts.distribution_windows_hardNeg;
    classification_opts.distribution_windows
    %%%%%%%%%%%%%%%%%%% Main Retraining function %%%%%%%%%%%%%%%%%%%%
    histogram_all_retrain=Do_Retrain_Det(opts,classification_opts,model);
end %%%%% end for classification_opts.model_retrain check

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of Retraining to Collect Hard Negative Examples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%    Collect random Background Negative Examples as described in Harzallah's paper (Normally They Collect 70K random Background Examples 

if(classification_opts.randNeg)
    classification_opts.distribution_windows=classification_opts.distribution_windows_randNeg;
    classification_opts.distribution_windows
    %%%%%%%%%%%%%%%%%%% Main Rand Negative function %%%%%%%%%%%%%%%%%%%%
    histogram_all_select_random=Do_RandNeg_Det(opts,classification_opts);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End Background random Negative Example Extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Do The Training of Final Model by Combining pos bbox + Neg bbox + Hard Negative Examples + Rand Neg Examples  

if(classification_opts.final_model)
    parameter_final_retrain=1;
    % %%%%%%%%% Retraining the Model again %%%%%%%%%%%%%%%%
        if(classification_opts.model_retrain)
             histogram_retrain=[histogram,histogram_all_select_random,histogram_all_retrain];
             size(histogram_retrain)
             z=zeros(size(histogram_all_select_random,2),1);
             y=zeros(size(histogram_all_retrain,2),1);
             train_truth_retrain1=[train_truth;z];
             train_truth_retrain=[train_truth_retrain1;y];
             size(train_truth_retrain)
        else %%%%%% Only combine rand Neg Examples Without Hard Negatives
             histogram_retrain=[histogram,histogram_all_select_random];
             size(histogram_retrain)
             z=zeros(size(histogram_all_select_random,2),1);
             train_truth_retrain=[train_truth;z];
             size(train_truth_retrain)
        end
         model=Do_Model_train_Det(histogram_retrain',train_truth_retrain,best_C,parameter_final_retrain);
         display('The Final Model is Retrained');
         pause
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of Retraining the Final Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/BOW_Model_final_retrain4'),'model');

%% Do Testing on the Test Images by Generating Exahuastive Windows 
assignment_opts.det_name_try='aeroplane_det_try';
if(classification_opts.test_flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Construct Histogram of sliding windows and Test Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('%%%%% STARTING TESTING %%%%%%');
classification_opts.distribution_windows=classification_opts.distribution_windows_test;
classification_opts.distribution_windows
tic;
      for i =7001:nimages
          if(testset(i)==1)
%               i=5106;%i=5044
i
              det_points_final=getfield(load([data_locations{i},'/',classification_opts.index_name]),'assignments');
              imt=sprintf('%s/%s',opts.imgpath,image_names{i});
              im=imread(imt);
              windows = Do_SlidingWindows(im,classification_opts.optionGenerate,classification_opts); 
%                windows=[];
%                windows=[53 41 201 457];

              %%%%%%% main Function to do the testing of windows %%%%%%
              dec_values=Do_Test_Det(windows,det_points_final,model,classification_opts);
%               dec_values
%               pause
det_scores=[windows,dec_values];
%               img_structure{counter_img}=[windows,dec_values];
              counter_img=counter_img+1;
%               save -v7.3 '/home/fahad/Datasets/Inria/Data/Global/Assignment/final_predict12' img_structure

          end
          display('Testing done')
          save ([data_locations{i},'/',assignment_opts.det_name_try],'det_scores');
          display('Saved');
%           toc;
%        pause

      end
%       save -v7.3 '/home/fahad/Datasets/Inria/Data/Global/Assignment/final_predict13' img_structure
      toc;
end
display('All Images done');
pause
 %%
%%%%%%%%%%%%%%%%% Do Non-Maxima Supression on sliding window histograms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 display('Starting The Non Maxima Supression and Final Scores');
for i =5151:nimages
     if(testset(i)==1)
         if(labels(i,1)==1)
         windows12=getfield(load([data_locations{i},'/',assignment_opts.det_name_try]),'det_scores');
         imt=sprintf('%s/%s',opts.imgpath,image_names{i});             
%        windows12=getfield(load('/home/fahad/Datasets/Inria/Data/Global/Assignment/final_predict11'),'img_structure');
         [drect,dscores]=Do_non_max_sp(windows12(:,1:4),windows12(:,5),classification_opts.nmax_param); 
 %       [drect,dscores]=Do_non_max_sp(windows12(:,1:4),windows12(:,5),classification_opts.nmax_param);
%        Do_Draw_det(image, win_posw,win_posh,winw,winh,scores, threshold)
          Do_Draw_det(imt, drect(:,1),drect(:,2),drect(:,3)-drect(:,1),drect(:,4)-drect(:,2),dscores, 0);
          pause
          clf
         end
     end
 end