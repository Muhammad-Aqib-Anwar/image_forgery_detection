function [predict_label,accuracy,dec_values,weights]=Do_libSVM(traindata,testdata,labels_L,labels_T,best_C)
tic;
options=sprintf('-t 0 -b 1 -c %f',best_C);
model=svmtrain(labels_L,traindata,options);
%weights=full(model.SVs)'*model.sv_coef;
                       %    [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);
[predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model,'-b 1');

%weights=full(model.SVs)'*model.sv_coef;
toc;
