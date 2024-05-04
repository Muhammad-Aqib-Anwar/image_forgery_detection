function histogram=Do_Compute_Disc_Scale_histogram(hist_cell)

histogram=[];
for jj=1:size(hist_cell,2)
    AB=hist_cell(:,jj);
AB1=cell2mat(AB);
AB1=AB1';
% All_hist=normalize(AB1,1);
All_hist=AB1;
histogram=[histogram;All_hist];
end

histogram=normalize(histogram,1);