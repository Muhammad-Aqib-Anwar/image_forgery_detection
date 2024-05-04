function convertpngtojpg_opp_depth1
opts.dataDir_rgb = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012/';
save_dir = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_copp_depth/'; save_dir1 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_opp-depth/';
save_dir2 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_opp_only/'; save_dir3 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_copp_only/';
%% Train images
%  parpool(12);
d = dir(fullfile(opts.dataDir_rgb, 'images', 'train', 'n*'))';
for a = 1:length(d)
    fprintf('processing image dir train (%d of %d)\n', a, length(d));
    ims = dir(fullfile(opts.dataDir_rgb, 'images', 'train', d(a).name,  '*.JPEG')) ;
    names_train = strcat([opts.dataDir_rgb,'images/train/',d(a).name, filesep], {ims.name}) ;
    if exist([save_dir,'images/train/',d(a).name],'dir'); else mkdir([save_dir,'images/train/',d(a).name]);  end; if exist([save_dir1,'images/train/',d(a).name],'dir');else mkdir([save_dir1,'images/train/',d(a).name]);end
    if exist([save_dir2,'images/train/',d(a).name],'dir');else mkdir([save_dir2,'images/train/',d(a).name]); end; if exist([save_dir3,'images/train/',d(a).name],'dir');else mkdir([save_dir3,'images/train/',d(a).name]);end
    cur_dir_name = d(a).name;
    for i = 1:length(names_train)
        i
        [img_dir, img_name]=fileparts(names_train{i});
        one_cache_file=strcat([img_name,'.jpg']);
        imsave = fullfile(save_dir,cur_dir_name,one_cache_file);
        if exist(imsave,'file') ; continue ; end
        img = imread(names_train{i});
        [c_opp_Depth_image,O_Depth_image,op,op_c]=do_depth_opp(img);
        imwrite(c_opp_Depth_image*255 , fullfile(save_dir,'images/train/',cur_dir_name,one_cache_file));
        imwrite(O_Depth_image , fullfile(save_dir1,'images/train/',cur_dir_name,one_cache_file));
        imwrite(op , fullfile(save_dir2,'images/train/',cur_dir_name,one_cache_file));
        imwrite(op_c, fullfile(save_dir3,'images/train/',cur_dir_name,one_cache_file));
    end
end
display('done')
%% Validation images
ims_depth = dir(fullfile(opts.dataDir, 'images', 'val', '*.png')) ;
names_val_depth = strcat([opts.dataDir,'images/val/'], {ims_depth.name}) ;
ims = dir(fullfile(opts.dataDir_rgb, 'images', 'val',  '*.JPEG')) ;
names_val = strcat([opts.dataDir_rgb,'images/val/'], {ims.name}) ;
if exist([save_dir,'images/val/'],'dir') ;else mkdir([save_dir,'images/val/']); end; if exist([save_dir1,'images/val/'],'dir'); else     mkdir([save_dir1,'images/val/']); end
if exist([save_dir2,'images/val/'],'dir');else mkdir([save_dir2,'images/val/']); end; if exist([save_dir3,'images/val/'],'dir'); else     mkdir([save_dir3,'images/val/']); end
parfor ii = 1:length(names_val)
    fprintf('processing image  val (%d of %d)\n', ii, length(names_val));    
    [img_dir, img_name]=fileparts(names_val{ii});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(save_dir,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    [c_opp_Depth_image,O_Depth_image,op,op_c]=do_depth_opp(img);
    imwrite(c_opp_Depth_image*255 , fullfile(save_dir,'images/val/',one_cache_file));
    imwrite(O_Depth_image , fullfile(save_dir1,'images/val/',one_cache_file));
    imwrite(op , fullfile(save_dir2,'images/val/',one_cache_file));
    imwrite(op_c, fullfile(save_dir3,'images/val/',one_cache_file));    
end
display('done')
%% Test images
ims_depth = dir(fullfile(opts.dataDir, 'images', 'test', '*.png')) ;
names_test_depth = strcat([opts.dataDir,'images/test/'], {ims_depth.name}) ;
ims = dir(fullfile(opts.dataDir_rgb, 'images', 'test',  '*.JPEG')) ;
names_test = strcat([opts.dataDir_rgb,'images/test/'], {ims.name}) ;
if exist([save_dir,'images/test/'],'dir') ;else     mkdir([save_dir,'images/test/']); end; if exist([save_dir1,'images/test/'],'dir'); else     mkdir([save_dir1,'images/test/']); end
if exist([save_dir2,'images/test/'],'dir') ;else     mkdir([save_dir2,'images/test/']); end; if exist([save_dir3,'images/test/'],'dir'); else     mkdir([save_dir3,'images/test/']); end
parfor ii = 1:length(names_test)
    fprintf('processing image  test (%d of %d)\n', ii, length(names_test));   
    [img_dir, img_name]=fileparts(names_test{ii});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(save_dir,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    [c_opp_Depth_image,O_Depth_image,op,op_c]=do_depth_opp(img)
    imwrite(c_opp_Depth_image*255 , fullfile(save_dir,'images/test/',one_cache_file));
    imwrite(O_Depth_image , fullfile(save_dir1,'images/test/',one_cache_file));
    imwrite(op , fullfile(save_dir2,'images/test/',one_cache_file));
    imwrite(op_c, fullfile(save_dir3,'images/test/',one_cache_file));
end
display('done')