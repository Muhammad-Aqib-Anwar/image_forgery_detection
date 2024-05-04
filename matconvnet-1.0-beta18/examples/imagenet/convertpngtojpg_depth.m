function convertpngtojpg_depth

opts.dataDir = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_depth_indoor/';
%% Train images
parpool(12);
% d = dir(fullfile(opts.dataDir, 'images', 'train', 'n*'))';
% for a = 1:length(d)
%     fprintf('processing image dir train (%d of %d)\n', a, length(d));
%     ims = dir(fullfile(opts.dataDir, 'images', 'train', d(a).name,  '*.png')) ;
%     names_train = strcat([opts.dataDir,'images/train/',d(a).name, filesep], {ims.name}) ;
%     %  one_cache_file=strcat([img_name,'_depth_gray.png']);
%     parfor i = 1:length(names_train)
%         %tic;
%         [img_dir, img_name]=fileparts(names_train{i});
%         img_data=read_img_rgb(names_train{i});
%         one_cache_file=strcat([img_name,'_depth_gray.jpg']);
%         imsave = fullfile(img_dir,one_cache_file);
%         if exist(imsave,'file') ; continue ; end
%         imwrite(img_data, fullfile(img_dir,one_cache_file));
%         %toc;
%     end
% end
% display('done')
%% Validation images
ims = dir(fullfile(opts.dataDir, 'images', 'val', '*.png')) ;
% ims.nam = sort({ims.name}) ;
names_val = strcat([opts.dataDir,'images/val/'], {ims.name}) ;

%save_dir = strcat([save_loc,'images/val', filesep]);
parfor ii = 1:length(names_val)
    fprintf('processing image  val (%d of %d)\n', ii, length(names_val));
    img_data=read_img_rgb(names_val{ii});
    [img_dir, img_name]=fileparts(names_val{ii});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(img_dir,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    imwrite(img_data, fullfile(img_dir,one_cache_file));
end
display('done')
%% Test images
ims = dir(fullfile(opts.dataDir, 'images', 'test', '*.png')) ;
names_test = strcat([opts.dataDir,'images/test/'], {ims.name}) ;
parfor i = 1:length(names_test)    
    fprintf('processing image dir test (%d of %d)\n', i, length(names_test));
    [img_dir, img_name]=fileparts(names_test{i});
    img_data=read_img_rgb(names_test{i});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(img_dir,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    imwrite(img_data, fullfile(img_dir,one_cache_file)); 
end
