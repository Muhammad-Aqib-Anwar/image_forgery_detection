function convertpngtojpg_opp
opts.dataDir_rgb = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012/';
save_dir2 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_opp_only/';
save_dir3 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_copp_only/';
%% Train images
 parpool(12);
% d = dir(fullfile(opts.dataDir_rgb, 'images', 'train', 'n*'))';
% for a = 1:length(d)
%     fprintf('processing image dir train (%d of %d)\n', a, length(d));
%     ims = dir(fullfile(opts.dataDir_rgb, 'images', 'train', d(a).name,  '*.JPEG')) ;
%     names_train = strcat([opts.dataDir_rgb,'images/train/',d(a).name, filesep], {ims.name}) ;
%     if exist([save_dir2,'images/train/',d(a).name],'dir');else mkdir([save_dir2,'images/train/',d(a).name]); end; if exist([save_dir3,'images/train/',d(a).name],'dir');else mkdir([save_dir3,'images/train/',d(a).name]);end
%     cur_dir_name = d(a).name;
%     parfor i = 1:length(names_train)
%         %i
%         [img_dir, img_name]=fileparts(names_train{i});
%         one_cache_file=strcat([img_name,'.jpg']);
%         imsave = fullfile(save_dir2,cur_dir_name,one_cache_file);
%         if exist(imsave,'file') ; continue ; end
%         img = imread(names_train{i});
%         [O1,O2,O3] = RGB2O(color(img)); w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;
%         op = cat(3,O1,O2,O3); % opp only
%         op_c = cat(3,w1,w2,O3); % copp only
%         imwrite(op , fullfile(save_dir2,'images/train/',cur_dir_name,one_cache_file));
%         imwrite(op_c, fullfile(save_dir3,'images/train/',cur_dir_name,one_cache_file));
%     end
% end
% display('done')
%% Validation images
% ims = dir(fullfile(opts.dataDir_rgb, 'images', 'val',  '*.JPEG')) ;
% names_val = strcat([opts.dataDir_rgb,'images/val/'], {ims.name}) ;
% if exist([save_dir2,'images/val/'],'dir');else mkdir([save_dir2,'images/val/']); end; if exist([save_dir3,'images/val/'],'dir'); else     mkdir([save_dir3,'images/val/']); end
% parfor ii = 1:length(names_val)
%     fprintf('processing image  val (%d of %d)\n', ii, length(names_val));
%     [img_dir, img_name]=fileparts(names_val{ii});
%     one_cache_file=strcat([img_name,'.jpg']);
%     imsave = fullfile(save_dir2,one_cache_file);
%     if exist(imsave,'file') ; continue ; end
%     img = imread(names_val{ii});
%     [O1,O2,O3] = RGB2O(color(img)); w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;
%     op = cat(3,O1,O2,O3); % opp only
%     op_c = cat(3,w1,w2,O3); % copp only
%     imwrite(op , fullfile(save_dir2,'images/val/',one_cache_file));
%     imwrite(op_c, fullfile(save_dir3,'images/val/',one_cache_file));
% end
% display('done')
%% Test images
ims = dir(fullfile(opts.dataDir_rgb, 'images', 'test',  '*.JPEG')) ;
names_test = strcat([opts.dataDir_rgb,'images/test/'], {ims.name}) ;
if exist([save_dir2,'images/test/'],'dir') ;else     mkdir([save_dir2,'images/test/']); end; if exist([save_dir3,'images/test/'],'dir'); else     mkdir([save_dir3,'images/test/']); end
parfor ii = 1:length(names_test)
    fprintf('processing image  test (%d of %d)\n', ii, length(names_test));
    [img_dir, img_name]=fileparts(names_test{ii});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(save_dir2,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    img = imread(names_test{ii});
    [O1,O2,O3] = RGB2O(color(img)); w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;
    op = cat(3,O1,O2,O3); % opp only
    op_c = cat(3,w1,w2,O3); % copp only
    imwrite(op , fullfile(save_dir2,'images/test/',one_cache_file));
    imwrite(op_c, fullfile(save_dir3,'images/test/',one_cache_file));
end
display('done')