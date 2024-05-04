function [svm_score,best_CV]=Do_Classifiy_libSVM_PCA(opts,classification_opts)

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
 load(opts.testset)
 labels=getfield(load(opts.labels),'labels');
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
 [max1,labels_index]=max(labels,[],2);
 train_truth=labels_index(trainset>0);
 test_truth=labels_index(testset>0);
 
% size(histogram)
% size(histogram_train)
% size(histogram_test) 
%%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
% Histogram intersection kernel cross validation
best_C=20; best_CV=0;
%size(histogram)
%display('origial hist size')
%[best_C,best_CV]=Do_libSVM_ikmmulti_noha(histogram_train',train_truth) ;  

%compress the histogram
display ('adding PCA compression path')
addpath(genpath('/home/fahad/Matlab_code/drtoolbox'))
display ('path added')

display ('next compression size:500')
compress_histogram6=compute_mapping(histogram', 'PCA', 500);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:450')
compress_histogram6=compute_mapping(histogram', 'PCA', 450);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:400')
compress_histogram6=compute_mapping(histogram', 'PCA', 400);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:350')
compress_histogram6=compute_mapping(histogram', 'PCA',350);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:300')
compress_histogram6=compute_mapping(histogram', 'PCA',300);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause



display ('next compression size:200')
compress_histogram6=compute_mapping(histogram', 'PCA', 200);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:150')
compress_histogram6=compute_mapping(histogram', 'PCA', 150);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:100')
compress_histogram6=compute_mapping(histogram', 'PCA', 100);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause


display ('next compression size:50')
compress_histogram6=compute_mapping(histogram', 'PCA', 50);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause



display ('next compression size:10,000')
compress_histogram0=compute_mapping(histogram', 'PCA', 10000);
display ('compress_histogram0 done')
size(compress_histogram0)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram0(trainset>0,:),compress_histogram0(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:5000')
compress_histogram1=compute_mapping(histogram', 'PCA', 5000);
display ('compress_histogram1 done')
size(compress_histogram1)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram1(trainset>0,:),compress_histogram1(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:2500')
compress_histogram2=compute_mapping(histogram', 'PCA', 2500);
size(compress_histogram2)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram2(trainset>0,:),compress_histogram2(testset>0,:),train_truth,test_truth,best_C);

display ('classification done.. press any key to continue')
pause

display ('next compression size:1000')
compress_histogram3=compute_mapping(histogram', 'PCA', 1000);
size(compress_histogram3)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram3(trainset>0,:),compress_histogram3(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:500')
compress_histogram5=compute_mapping(histogram', 'PCA', 500);
size(compress_histogram5)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram5(trainset>0,:),compress_histogram5(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause

display ('next compression size:250')
compress_histogram6=compute_mapping(histogram', 'PCA', 250);
size(compress_histogram6)
[predict_labels,svm_score]=Do_libSVM_fast_multi_noha(compress_histogram6(trainset>0,:),compress_histogram6(testset>0,:),train_truth,test_truth,best_C);
display ('classification done.. press any key to continue')
pause
end
