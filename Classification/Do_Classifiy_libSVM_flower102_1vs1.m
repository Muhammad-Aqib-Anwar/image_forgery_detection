function [svm_score,best_CV]=Do_Classifiy_libSVM_flower102_1vs1(opts,classification_opts)

if nargin<2
    classification_opts=[];
end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end

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
     histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
     histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
     histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
     histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
     histogram=[(0.99).*histogram1;(0.0001).*histogram2;(0.0001).*histogram3;(0.0001).*histogram4]; 
% histogram=sqrt(histogram);
  acc_class=[];
  dec_values_all=[];
  predict_labels_all=[];

  histogram_train=histogram(:,trainset>0);
  histogram_test=histogram(:,testset>0);
 
  [max1,labels_index]=max(labels,[],2);
  train_truth=labels_index(trainset>0);
  test_truth=labels_index(testset>0);
 
  size(histogram)
  size(histogram_train)
  size(histogram_test)

 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
%                        [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
   
                         best_C=5000;
                         best_G=0.01;
              
                         [predict_labels,svm_score, dec_values]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G); 
      
          %% for computing the product of different kernel responses

save -v7.3 '/home/fahad/Datasets/flower_102/prob_Features/Fusion/predict_labels_class24' predict_labels
save -v7.3 '/home/fahad/Datasets/flower_102/prob_Features/Fusion/dec_values_class24' dec_values
display('Final Prediction and probability matrix computed');










