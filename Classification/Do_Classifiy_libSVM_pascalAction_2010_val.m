function [svm_score,best_CV]=Do_Classifiy_libSVM_pascalAction_2010_val(opts,classification_opts,rng)
VOCINIT2010_Action
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
%  load(opts.trainset)
%  load(opts.testset)
labels=getfield(load(opts.labels),'labels');
nclasses=opts.nclasses;
counter=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Val set %%%

labels=[];
%%%%%%%%%%%%%%%% To check on the valuidation set , add these additonal lines
labels_train=zeros(301,9); %%%% Pascal 2007 have total 9963 images across 20 classes

imgset='train'; %%%% for training images

for i=1:opts.nclasses %%%% Number of classes in Pascal
    
    cls=opts.classes{i}; %%%% the current class
    
    [imgids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
    
    abcd=find(gt==1); %%%% find where 1 exists in gt
    
    labels_train(abcd,i)=1;  %%%% substitute 1 on all the places (abcd) in labels
    
end

%%%%%%%%%%%%%%%%% the same process should be repeated for test images %%%%%%%%%%%%%%%%%

labels_test=zeros(307,9); %%%% Pascal 2007 have total 9963 images across 20 classes
imgset='val'; %%%% for training images

for i=1:opts.nclasses %%%% Number of classes in Pascal
    
    cls=opts.classes{i}; %%%% the current class
    
    [imgids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
    
    abcd=find(gt==1); %%%% find where 1 exists in gt
    
    labels_test(abcd,i)=1;  %%%% substitute 1 on all the places (abcd) in labels
    
end

labels=[labels_train;labels_test];

trainset=zeros(length(labels),1);
testset=zeros(length(labels),1);

imgset='train';
%     [ids,gt]=textread(sprintf(opts.imgsetpath,imgset),'%s %d');
[ids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');

imgset='trainval';
%     [ids_trainval,gt]=textread(sprintf(opts.imgsetpath,imgset),'%s %d');
[ids_trainval,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
final_train_truth=find(ismember(ids_trainval,ids)==1);
trainset(final_train_truth,:)=1;

imgset='val';
%     [ids,gt]=textread(sprintf(opts.imgsetpath,imgset),'%s %d');
[ids,gt]=textread(sprintf(opts.imgsetpath,imgset),'%s %d');
final_test_truth=find(ismember(ids_trainval,ids)==1);

testset(final_test_truth,:)=1;

%%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 
% histogram=sign(histogram).*sqrt(abs(histogram));
% histogram=histogram/norm(histogram);
% histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
% histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
% histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
% histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
% histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
% histogram7=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name7]),'All_hist');
% histogram8=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name8]),'All_hist');
% histogram1=histogram1(1:1000,:);
% histogram1=normalize(histogram1,1);
% histogram2=histogram2(1:500,:);
% histogram2=normalize(histogram2,1);

%   histogram=[histogram1;histogram2];

% histogram=histogram(1:500,:);
% histogram=normalize(histogram,1);
%   size(histogram)

%    histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
%    histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
%    histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
%     histogram7=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name7]),'All_hist');
%      histogram8=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name8]),'All_hist');
%       histogram=[histogram1;histogram2;histogram3;histogram4;histogram5;histogram6;histogram7;histogram8];
%    histogram=[histogram2;histogram3;histogram4;histogram5;histogram6;histogram7;histogram8];
%   histogram=[(0.9).*histogram1;(0.05).*histogram2;(0.05).*histogram3;(0.9).*histogram4;(0.05).*histogram5;(0.05).*histogram6];
%  histogram=[histogram1;histogram2;histogram3;histogram4;histogram5;histogram6];
% histogram=[(0.9).*histogram1;(0.05).*histogram2;(0.05).*histogram3];
% histogram=[histogram1;histogram2;histogram3;histogram4;histogram5;histogram6;histogram7;histogram8];
% histogram=sqrt(histogram);
%%%%% start here again %%%%
histogram_train=histogram(:,trainset>0);
histogram_test=histogram(:,testset>0);

size(histogram_train)
size(histogram_test)
for i=rng
    cls=opts.classes{i};
    
    %  %%%%%%%%% for Training  GroundTruth %%%%%%%%%%%%%
    train_truth=zeros(301,1);
    imgset='train';
    cls=opts.classes{i}; %%%% the current class
    %  [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
    [imgids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
    abcd=find(gt==1); %%%% find where 1 exists in gt
    train_truth(abcd,:)=1;
    
    %  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
    test_truth=zeros(307,1);
    imgset='val';
    cls=opts.classes{i}; %%%% the current class
    %  [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
    [imgids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
    abcd=find(gt==1); %%%% find where 1 exists in gt
    test_truth(abcd,:)=1;
    
    %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
    
    %%%%%%% Cross Validation %%%%%%%%
    %                            [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);
    
    best_C=5000;
    best_G=0.01;
                  [predict_label,svm_score,prob_out,weights]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
    %              [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);
%     [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);
    if(i==7)
        prob_class=prob_out(:,1);
    else
        prob_class=prob_out(:,2);
    end
    %%%%% save the probabilities with the class name to the results folder
    fid=fopen(sprintf(opts.clsrespath,cls),'w');
    imgset='val';
    %             [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
    [ids,objids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
    for jk=1:length(ids)
        fprintf(fid,'%s %d %f\n',ids{jk},objids(jk),prob_class(jk));
    end
    fclose(fid);
    %
    [recall,prec,ap]=VOCevalaction(opts,cls,true);
    collect_ap{counter}=ap
    %             clas_score{counter}=ap
    class_ap{i}=ap
    
end
aa=mean(cell2mat(class_ap))
display('done');