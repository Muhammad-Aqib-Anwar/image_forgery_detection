function compress_histogram=Do_compression_Texture_Portmanteau_Global(textureopts,classification_opts,labels,trainset,testset)

histogram_color=getfield(load([textureopts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
histogram_shape=getfield(load([textureopts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');

compress_size=500;
[W,hist_compressed]=Do_Divisive_Portmanteau(histogram_color,histogram_shape,trainset,labels,compress_size);
% compress_histogram=sqrt(hist_compressed);
compress_histogram=(hist_compressed);

