function [svm_score,best_CV]=Do_Classifiy_libSVM_flower102_DITC_try(opts,histogram)


 load(opts.trainset)
%  labels=load(opts.labels)
 load(opts.testset)
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 
for i=1:102
    display('The current Class is :')
    i
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

%                          [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
   best_C=5000;
                                  best_G=0.01;
% [predict_labels,svm_score, dec_values]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
%         [predict_labels,svm_score, dec_values]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G); 
       [predict_labels,svm_score, dec_values]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);  
                          pred_a=find(predict_labels(:)==1);
                          true_b=find(test_truth(:)==1);
                          chk=ismember(true_b,pred_a);
                          num_corr=sum(chk>0);
                          tot_num=length(true_b);
                          acc_clss(i)=num_corr*100/tot_num
                          
                           if(i==77)
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
%  save -v7.3 '/home/fahad/Datasets/flower_102/Fusion/dec_values_CNSIFT_1M_independent7' dec_values
%  save -v7.3 '/home/fahad/Datasets/flower_102/Fusion/dec_values_CNSIFT_5k_100_try73_Beta_1000_Shrinkage_Weight12' dec_values
% save -v7.3 '/home/fahad/Datasets/flower_102/Fusion/dec_values_CNSIFT_5k_100_try49' dec_values
% save -v7.3 '/home/fahad/Datasets/flower_102/Fusion/dec_values_P_LF' dec_values


% save -v7.3 '/home/fahad/Datasets/flower_102/Fusion/dec_values_journal_temp' dec_values

% save -v7.3 '/home/fahad/Datasets/flower_102/Fusion/dec_values_BioInspired_SIFT1' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_BioInspired_CNSIFT11' dec_values

% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_PCNSIFT13k_aib4k' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_CNSIFT13k_aib4k_New' dec_values

% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_temp1' dec_values

% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_PCN_R' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_PCNSIFT_R_UNIV' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/flower_102/Fusion_New/dec_values_PCN_R_UNIV' dec_values

% 
%% New DITC soft try
save -v7.3 '/home/cic/fahad/Datasets/flower_102/DITC_Soft_try/dec_values_CN_orig' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/flower_102/DITC_Soft_try/dec_values_CN_new' dec_values
% save -v7.3 '/home/cic/fahad/Datasets/flower_102/DITC_Soft_try/dec_values_CN_nocompress' dec_values