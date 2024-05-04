function [svm_score,best_CV]=Do_Classifiy_libSVM_Toon(opts,classification_opts,rng)

% if nargin<2
%     classification_opts=[];
% end
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
 load(opts.testset)
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
counter=1;
 
%% only now
% histogram=ones(1000,9963);
% rng=nclasses;
          histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
          
          
%           compress_histogram=Do_PLS_compression(histogram,labels,trainset,testset);
%           histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%           histogram=[histogram1;histogram2];
%           histogram=sqrt(histogram);
%           histogram=compress_histogram;
          display('classification.. started')
         
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
           
%                          [best_C,best_CV]=Do_CV_libSVM_pascal(histogram_train',train_truth);
%% to be used
%                                 [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);

%                          [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
%best_C=1141;
%      best_C=20;
%display('fixed c value')
                            best_C=5000;best_CV=0;
                            best_G=0.1;
%           best_C=2;best_CV=0;               
                    [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);      
               
%                       [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);            
             if(i==11)
                 prob_class=prob_out(:,1);
             else
                prob_class=prob_out(:,2);         %%%% for all classes its 2 except for chair class where its 1
             end
            %%%%% save the probabilities with the class name to the results folder 
               fid=fopen(sprintf(opts.clsrespath,cls),'w');
               imgset='test';
               [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
             for jk=1:length(ids)
                 fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
            end
             fclose(fid);
              [recall,prec,ap]=VOCevalcls(opts,cls,true);
             if i<opts.nclasses
%                 fprintf('press any key to continue with next class...\n');
                drawnow;
%                 pause;
             end %%% end if 

  collect_ap{counter}=ap*100
  %             clas_score{counter}=ap
             class_ap{i}=ap
            
%   counter=counter+1;           
%    end %%%% end switch 
end    %%%% end for
% ant=collect_ap;
cal_ap=cell2mat(class_ap);
display('The Mean AP is:');
mean(cal_ap)