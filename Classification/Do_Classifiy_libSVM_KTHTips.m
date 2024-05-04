function [svm_score,best_CV]=Do_Classifiy_libSVM_KTHTips(opts,classification_opts)

if nargin<2
    classification_opts=[];
end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end
% if ~isfield(classification_opts,'kernel_option');         classification_opts.kernel_option='Unknown';         end  
% if ~isfield(classification_opts,'kernel');                classification_opts.kernel='Unknown';                end
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';                 end


 %%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
%  labels=load(opts.labels)
 load(opts.testset)
 nclasses=11;
%  nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
     histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
%      histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%      histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%      histogram=[histogram1;histogram3];
     histogram=sqrt(histogram);
  acc_class=[];
for i=1:nclasses
    display('The current Class is for NIPS rebuttal Val :')
    i
    cls=i;
    
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
 %  %%%%%%%%% for Training  GroundTruth %%%%%%%%%%%%%
train_truth=zeros(size(labels,1),1);
a=(trainset.*(labels(:,i)==1))>0;
bcd=find(a==1);
train_truth(bcd,:)=1;
train_truth=train_truth(trainset>0,:);

%  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
test_truth=zeros(size(labels,1),1);
a=(testset.*(labels(:,i)==1))>0;
bcd=find(a==1);
test_truth(bcd,:)=1;
test_truth=test_truth(testset>0,:);
 
%     [max1,labels_index]=max(labels,[],2);
%    train_truth=labels_index(trainset>0);
%    test_truth=labels_index(testset>0);
  size(histogram)
  size(histogram_train)
  size(histogram_test)


 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   
            %%%%%%% Cross Validation %%%%%%%%

%                          [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
   best_C=2000;
                                  best_G=0.01;

                         [predict_labels,svm_score, dec_values]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);
% best_C=20;                         
% [predict_labels,svm_score,dec_values]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
%        [predict_labels,svm_score,dec_values]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);  
                          pred_a=find(predict_labels(:)==1);
                          true_b=find(test_truth(:)==1);
                          chk=ismember(true_b,pred_a);
                          num_corr=sum(chk>0);
                          tot_num=length(true_b);
                          acc_clss(i)=num_corr*100/tot_num
                          
                           if(i==1)
                         dec_values_all{i}=dec_values(:,1);
                           else
                          dec_values_all{i}=dec_values(:,2);
                % dec_values_all{i}=dec_values(:,2);

                          end


end
att=round(sum(acc_clss,'double'))/nclasses;
display('Accuracy is :');
att
dec_values=cell2mat(dec_values_all);
%  save -v7.3 '/home/fahad/Datasets/Birds_200/Fusion/dec_valuesCNSIFT_combined1' dec_values
% save -v7.3 '/home/fahad/Datasets/Birds_200/Fusion/dec_values_PCNSIFT_5k_100_try74_Beta_500' dec_values
% save -v7.3 '/home/fahad/Datasets/Birds_200/Fusion/dec_values_PCNSIFT_5k_100_dependent' dec_values
% save -v7.3 '/home/fahad/Datasets/Birds_200/Fusion/dec_values_SIFT_5k_500_Marcin' dec_values
% save -v7.3 '/home/fahad/Datasets/Birds_200/Fusion/dec_values_P_LF_Val' dec_values

% save -v7.3 '/home/cic/fahad/Datasets/Paintings_Big/Fusion/dec_values_Port1' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/Paintings_Big/Fusion/dec_values_SIFT1400' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/Paintings_Big/Fusion/dec_values_LBP_MS' dec_values

% save -v7.3 '/home/cic/fahad/Datasets/Paintings_Big/Fusion/dec_values_cnsift' dec_values

% save -v7.3 '/home/cic/fahad/Datasets/Texture_own/Fusion/dec_values_lbp' dec_values

%%
save -v7.3 '/home/cic/fahad/Datasets/KTH_TIPS2_A/Data/split1/Fusion/dec_values_Plbp_Sqrt' dec_values




