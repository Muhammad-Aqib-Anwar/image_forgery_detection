function compress_histogram=Do_PLS_compression(histogram,labels,trainset,testset)
%% Compress a histogram based on PLS technique 
histogram_train=histogram(:,trainset>0);
histogram_test=histogram(:,testset>0);

X=histogram_train';
histogram_test_temp=histogram_test';
att=find(trainset>0);
Y=labels(att,:);

% xmean = mean(X);
% xstd = std(X);
% ymean = mean(Y);
% ystd = std(Y);
% X = (X - xmean(ones(size(histogram_train,2),1),:))./xstd(ones(size(histogram_train,2),1),:);
% Y = (Y - ymean(ones(size(histogram_train,2),1),:))./ystd(ones(size(histogram_train,2),1),:);
tol = 1e-15; %%% Change this value to obtain different sizes of compress histograms
[T,P,U,Q,B,W] = pls(X,Y);

%% project each image histogram onto the weight vectors W to obtain the compress histogram
compress_histogram=zeros(size(W,2),size(histogram_test_temp,1));
for i=1:size(histogram,2)
yX1=(W')*histogram(:,i);
compress_histogram(:,i)=yX1;
end

%% Do the Classification
display('The Size of Compress Histogram is :');
size(compress_histogram)
compress_histogram_train=compress_histogram(:,trainset>0);
compress_histogram_test=compress_histogram(:,testset>0);
 
[max1,labels_index]=max(labels,[],2);
train_truth=labels_index(trainset>0);
test_truth=labels_index(testset>0);
best_C=20;
[predict_labels,svm_score, dec_values]=Do_libSVM_fast_multi(compress_histogram_train',compress_histogram_test',train_truth,test_truth,best_C);