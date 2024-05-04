function [svm_score,best_CV]=Do_Classifiy_libSVM_pascalAction_2012_val(opts,classification_opts,rng)
VOCINIT2012_Action
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

%% Note that for jumping there is a shit remove all the 2010 first images from the list so the histograms and labels should be less this is true for train val and test
%% for train remove 1:301 first instances
%% for val remove 1:307 instances from "val labels"
%% for test remove 1:613 instances from "test labels"


%%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
load(opts.trainset)
load('/home/cic/fahad/Datasets/PASCAL_action2012/VOCdevkit/VOC2012//Labels//testset.mat');
% testset=test;
% load(opts.testset)
labels=getfield(load(opts.labels),'labels');
nclasses=opts.nclasses;
counter=1;


%%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');

histogram7=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name7]),'All_hist');
histogram8=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name8]),'All_hist');
histogram9=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name9]),'All_hist');

histogram111=[histogram1,histogram2,histogram3;histogram7,histogram8,histogram9];

histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');

histogram10=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name10]),'All_hist');
histogram11=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name11]),'All_hist');
histogram12=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name12]),'All_hist');

histogram222=[histogram4,histogram5,histogram6;histogram10,histogram11,histogram12];

histogram=[histogram111;histogram222];
histogram=double(histogram);
% histogram=sqrt(histogram);

%% Grand shit to encounter low number of instances  (imbalance) for jumping class
 if(rng==10)
     labels_train=labels(1:3134,:);
     labels_val=labels(3135:6278,:);
     labels_test=labels(6279:end,:);
     
     labels_train_jump=labels_train(302:end,:);
     labels_val_jump=labels_val(308:end,:);
     labels_test_jump=labels_test(614:end,:);
     
     labels=[labels_train_jump ;labels_val_jump; labels_test_jump];
     
     trainset=zeros(11340,1);
     trainset(1:2833,1)=1;
     
     testset=zeros(11340,1);
     testset(2834:5670,1)=1;
     
     histogram111=[histogram1(:,302:end),histogram2(:,308:end),histogram3(:,614:end);histogram7(:,302:end),histogram8(:,308:end),histogram9(:,614:end)];
     histogram222=[histogram4(:,302:end),histogram5(:,308:end),histogram6(:,614:end);histogram10(:,302:end),histogram11(:,308:end),histogram12(:,614:end)];
    
 histogram=[histogram111;histogram222];
histogram=double(histogram);

% histogram=sqrt(histogram);
 end
    
    
%%%%% start here again %%%%
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
    %                            [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);
    
    best_C=5000;
    best_G=0.01;
    %               [predict_label,svm_score,prob_out,weights]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
    %              [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);
    [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);
    
%     if(i==10)
%         load('/home/cic/fahad/Datasets/PASCAL_action2012/VOCdevkit/VOC2012/Labels//val');
%          
%         imgset='val';
%         [imgids_jumping_val,objids_jumping_val,gt_jumping_val]=textread(sprintf(VOCopts.clsimgsetpath,cls,imgset),'%s %d %d');
%         [imgids_phoning_val,objids_phoning_val,gt_phoning_val]=textread(sprintf(VOCopts.clsimgsetpath,'phoning',imgset),'%s %d %d');
%     end
    
    if(i==7  )
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