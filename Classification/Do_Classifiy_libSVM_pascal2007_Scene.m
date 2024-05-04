function [svm_score,best_CV]=Do_Classifiy_libSVM_pascal2007_Scene(opts,classification_opts,rng)

display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';                 end


 %%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
 load(opts.testset)
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
counter=1;
 
%% only now
% histogram=ones(1000,9963);
% rng=nclasses;
          histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
         
                    histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%                  histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%                  histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
%               histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
%            size(histogram)
          display('classification.. started')
%           pause
%          histogram=sqrt(histogram);
%         histogram=normalize(histogram,2);
%         histogram=normalize(histogram,1);
              histogram=[histogram1;histogram2];

for i=rng
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

 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
%    switch (classification_opts.num_histogram)
%        case 1
            %%%%%%% Cross Validation %%%%%%%%
            size(histogram)
            size(histogram_train)
            size(histogram_test)
           
%                         
            best_C=5000;best_CV=0;best_G=0.1;
            [predict_labels,svm_score, dec_values]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G); 
%                     [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);      
               
save -v7.3 '/home/fahad/Labelsforscene/prob_Column3' dec_values
display('Done for this Class');
end    %%%% end for
% ant=collect_ap;
