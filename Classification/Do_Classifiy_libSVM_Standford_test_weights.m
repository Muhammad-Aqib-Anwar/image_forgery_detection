function [svm_score,best_CV]=Do_Classifiy_libSVM_Standford_test_weights(opts,classification_opts,rng)
VOCINIT2010_Action
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
 counter=1;
 
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
  histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
%      histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%    histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%    histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
%   histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
% histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
% histogram7=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name7]),'All_hist');
% histogram8=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name8]),'All_hist');
% histogram9=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name9]),'All_hist');
%  histogram=[(0.1).*histogram1;(0.1).*histogram2;(0.5).*histogram3;(0.9).*histogram4;(0.01).*histogram5;(0.02).*histogram6;(0.01).*histogram7;(0.02).*histogram8;(0.05).*histogram9];
% histogram=[(0.15).*histogram1;(0.15).*histogram2;(0.7).*histogram3];
% histogram=[histogram1;histogram2];
% histogram=sqrt(histogram);
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 size(histogram)
 size(histogram_train)
 size(histogram_test)
for i=rng
    cls=opts.classes{i};


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
  
            %%%%%%% Cross Validation %%%%%%%%
%                      [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);

%                     best_C=20;
 best_C=200;
             best_G=0.01;
             [predict_label,svm_score,prob_out,weights]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
%              [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);
%             [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);           
            if(i==1)
                   prob_class=prob_out(:,1);
               else
               prob_class=prob_out(:,2);
               end
            
            %%%%% save the probabilities with the class name to the results folder 
            fid=fopen(sprintf(opts.clsrespath,cls),'w');
            imgset='test';
             [ids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
            for jk=1:length(ids)
                fprintf(fid,'%s %d %f\n',ids{jk},objids(jk),prob_class(jk));
            end
            fclose(fid);
            

           [recall,prec,ap]=VOCevalaction(opts,cls,true);
          collect_ap{counter}=ap
  %             clas_score{counter}=ap
             class_ap{i}=ap
   
end    %%%% end for

