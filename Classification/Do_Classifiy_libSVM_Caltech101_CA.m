function [svm_score,best_CV]=Do_Classifiy_libSVM_Caltech101_CA(opts,classification_opts)

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
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
%      histogram_complete=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
%      histogram=sqrt(histogram);
  acc_class=[];
  dec_values_all=[];
  predict_labels_all=[];
for i=1:10
    display('The current Class is :')
    i
%     histogram=histogram_complete{i};
current_hist_name=sprintf('hybrid_fastkmeansColorNMGrid_Dorko500_ikmeansSIFT_DorkoGrid_Dorko12000_aib1000_TD_try_Lazebnik3_class%d',i)
 histogram=getfield(load([opts.data_assignmentpath,'/',current_hist_name]),'All_hist');
    cls=opts.classes{i};
    
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
                 %%% uncomment next line for intersection kernel %%%
%                       [best_C,best_CV]=Do_CV_libSVM_fast(histogram_train',train_truth); 
%                             [best_C,best_CV]=Do_CV_libSVM_ikmmulti(histogram_train',train_truth);
%                          [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
%                                    [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
   
                                            best_C=5000;
                                  best_G=0.1;
               %%% uncomment next line for intersection kernel %%%
%                    [predict_labels,svm_score]=Do_libSVM_fast_multi(histogram_train',histogram_test',train_truth,test_truth,best_C);
%                        [predict_labels,svm_score]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
                         [predict_labels,svm_score, dec_values]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G); 
      
                          pred_a=find(predict_labels(:)==1);
                          true_b=find(test_truth(:)==1);
                          chk=ismember(true_b,pred_a);
                          num_corr=sum(chk>0);
                          tot_num=length(true_b);
                          acc_clss(i)=num_corr*100/tot_num
          %% for computing the product of different kernel responses
%           predict_labels_all=[predict_labels_all,predict_labels];
             predict_labels_all{i}=predict_labels;
          if(i==48)
%               dec_values_all=[dec_values_all,dec_values(:,1)];
dec_values_all{i}=dec_values(:,1);
          else
%               dec_values_all=[dec_values_all,dec_values(:,2)];
dec_values_all{i}=dec_values(:,2);
          end
%           save -v7.3 '/share/CIC/fahad/Caltech_101/Data/Global/predict_labels_LBPCN' predict_labels
%           save -v7.3 '/share/CIC/fahad/Caltech_101/Data/Global/dec_values_LBPCN' dec_values

end
att=round(sum(acc_clss,'double'))/nclasses;
display('Accuracy is :');
att
 
% save -v7.3 '/share/CIC/fahad/Caltech_101/Data/Global/predict_labels_P_CA_CN' predict_labels_all
% save -v7.3 '/share/CIC/fahad/Caltech_101/Data/Global/dec_values_P_CA_CN' dec_values_all
% save -v7.3 '/share/CIC/fahad/Caltech_101/Data/Global/class_score_P_CA_CN' acc_clss
display('Final Prediction and probability matrix computed');










