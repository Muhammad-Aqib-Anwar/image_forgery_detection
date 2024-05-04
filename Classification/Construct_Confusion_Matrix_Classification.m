%% To construct confusion matrix using 1 vs 1 classifier ( in this case the prediction of all classes are available in 1 matrix)
Cf = cfmatrix2(test_truth, predict_labels, [1 2 3 4 5 6 7 8 ], 1, 1); % 8 are the number of categories
figure(2); imagesc(Cf./repmat(sum(Cf,1),[8 1]))

%% To construct confusion matrix using 1 Vs all classifier ( in this case we first have to make predict labels by picking the max)
[drop, imageEstClass] = max(dec_values_SIFT', [], 1) ;
imageEstClass1=imageEstClass';

Cf = cfmatrix2(test_truth, imageEstClass1, [1 2 3 4 5 6 7 8 9 10 11 12 13], 1, 1); 
figure(2); imagesc(Cf./repmat(sum(Cf,1),[13 1]))