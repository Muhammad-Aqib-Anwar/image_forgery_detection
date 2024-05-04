% function compute-binary_classification(VOCopts)
% VOCinit ; 

addpath '/Users/Shared/Relocated Items/Security/thesis/libsvm-3.22/matlab'
addpath  '/Users/Shared/Relocated Items/Security/thesis/Classification'

% fname = '/Users/Shared/Relocated Items/Security/thesis/Dataset/all_images/Ex1/';  %korus dataset
 fname = '/Users/Shared/Relocated Items/Security/thesis/casia_label/Ex5'; %%DVMM
%  fname = '/Users/Shared/Relocated Items/Security/thesis/casai_label/Ex5'; %Casia
image_names=getfield(load([fname,'/','image_names.mat']),'image_names');
labels = getfield(load([fname,'/','labels']),'labels');
% classes_name =  getfield(load([fname, '/', 'classes_name']),'classes_name');
trainset = getfield(load([fname,'/','trainset']),'trainset');
testset = getfield(load([fname,'/','testset']),'testset');
% pos_dir = '/thesis/Dataset/all_images/pristine';
% neg_dir = '/thesis/Dataset/all_images/tempered';

% opts = VOCopts;
% load(opts.image_names)
% load(opts.trainset)
% load(opts.testset)
% load(opts.labels)

%% classification load histogram human action Recognition
% hist_dir = '/Users/Shared/Relocated Items/Security/thesis/Korus_histogram' ;
hist_dir='/Users/Shared/Relocated Items/Security/thesis/casia_histogram'; %DVMM dataset histogram
% hist_dir='/Users/Shared/Relocated Items/Security/thesis/casia_histogram'; %casia datasets histogram
% histogram = getfield(load([hist_dir,'/','PRNU_HandCrafted_all.mat']),'All_hist');
 histogram1 = getfield(load([hist_dir,'/','ycbcr_HandCrafted_all.mat']),'All_hist');
 histogram2 = getfield(load([hist_dir,'/','silency_HandCrafted_all_neg.mat']),'All_hist');
 histogram3 = getfield(load([hist_dir,'/','energy_HandCrafted_all.mat']),'All_hist');
 histogram4 = getfield(load([hist_dir,'/','dwt_HandCrafted_all.mat']),'All_hist');
% % % % histogram3 = getfield(load([hist_dir,'/','PRNU_400*400.mat']),'All_hist');
% % % % histogram4 = getfield(load([hist_dir,'/','dwt_400*400.mat']),'All_hist');
% % % % histogram5 = getfield(load([hist_dir,'/','fingerprint_400*400.mat']),'All_hist');
histogram=[histogram1;histogram2;histogram3;histogram4] ;
% histogram=normalize(histogram,1);
%   histogram=sign(histogram).*sqrt(abs(histogram));
%  histogram=sqrt(histogram);
%   histogram=sparse(histogram);
%  histogram=histogram./norm(histogram);
% histogram=vertcat(histogram{:}) ;
% histogram=cell2mat(histogram);
% histogram = histogram';
%%
histogram_train =histogram(:,trainset>0);
histogram_test =histogram(:,testset>0);
size(histogram)
size(histogram_train)
size(histogram_test)

class_ap = [];
for i= 1:2
%     cls=classes_name{i};
    
    %%%%%%% For Training Groundtruth %%%%%%%%
train_truth=zeros(size(labels,1),1);
a=(trainset.*(labels(:,i)==1))>0;
bcd=find(a==1);
train_truth(bcd,:)=1;
train_truth=train_truth(trainset>0,:);
 %%%%%%% For Groundtruth test %%%%%%%%
test_truth=zeros(size(labels,1),1);
a=(testset.*(labels(:,i)==1))>0;
bcd=find(a==1);
test_truth(bcd,:)=1;
test_truth=test_truth(testset>0,:);

%%%%% Do Classification %%%%%%%
best_C=5 ;
    best_G=0.01;
%     [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);
% [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);
               [predict_label,svm_score,prob_out]= Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
              
              
%               if(i==1)
%                   prob_out=prob_out(:,1);
%               else
%                    prob_out=prob_out(:,2);
%               end
% [ap,prec,recall]= pascal_eval(cls,prob_out);
% class_ap{i} = ap ;
 
end %% end for loop
% ap = mean(cell2mat(class_ap))
 C = confusionmat(test_truth,predict_label) ;
 %  display(C);
 tp=C(1,1) ;
 fp=C(1,2) ;
 fn=C(2,1) ;
 tn=C(2,2) ;
fprintf('true positive : %.1f \n', tp);
fprintf('false positive : %.1f \n', fp);
fprintf('false negative : %.1f \n', fn);
fprintf('true negative : %.1f  \n', tn);

precision = tp / (tp + fp) ;
recall = tp / (tp + fn);
accuracy=(tp + tn)/(tp + tn + fp + fn) ;
fprintf('accuracy : %.1f .\n', accuracy*100);
fprintf('precision : %.1f \n', precision*100);
fprintf('recall : %.1f \n', recall*100);

f_measure = (2 * recall * precision) / (recall + precision) ;
fprintf('f_measure : %.1f \n', f_measure*100);
disp('Done');