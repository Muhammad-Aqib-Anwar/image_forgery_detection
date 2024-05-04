function convertpngtojpg_opp_depth
% opts.dataDir = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_depth_indoor/';
opts.dataDir_rgb = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012/';
save_dir = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_copp_depth/';
save_dir1 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_opp-depth/';
save_dir2 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_opp_only/';
save_dir3 = '/scratch/cs/imagedb/anwerr1/Datasets/Imagenet_2012_copp_only/';
%% Train images
%  parpool(12);
d = dir(fullfile(opts.dataDir_rgb, 'images', 'train', 'n*'))';
for a = 1:length(d)
    fprintf('processing image dir train (%d of %d)\n', a, length(d));
    ims_depth = dir(fullfile(opts.dataDir, 'images', 'train', d(a).name,  '*.png')) ;
    %     ims_depth = dir(fullfile(opts.dataDir, 'images', 'train', d(a).name,  '*_rgb.jpg')) ;
    names_train_depth =  strcat([opts.dataDir,'images/train/',d(a).name, filesep], {ims_depth.name}) ;
    ims = dir(fullfile(opts.dataDir_rgb, 'images', 'train', d(a).name,  '*.JPEG')) ;
    names_train = strcat([opts.dataDir_rgb,'images/train/',d(a).name, filesep], {ims.name}) ;
    if exist([save_dir,'images/train/',d(a).name],'dir');  else    mkdir([save_dir,'images/train/',d(a).name]);     end
    if exist([save_dir1,'images/train/',d(a).name],'dir'); else    mkdir([save_dir1,'images/train/',d(a).name]);     end
    if exist([save_dir2,'images/train/',d(a).name],'dir'); else    mkdir([save_dir2,'images/train/',d(a).name]);     end
    if exist([save_dir3,'images/train/',d(a).name],'dir'); else    mkdir([save_dir3,'images/train/',d(a).name]);     end
    cur_dir_name = d(a).name;
    for i = 1:length(names_train)
        i
        [img_dir, img_name]=fileparts(names_train{i});
        [img_dir_depth, img_name_depth]=fileparts(names_train_depth{i});
        one_cache_file=strcat([img_name,'.jpg']);
        imsave = fullfile(save_dir,cur_dir_name,one_cache_file);
        if exist(imsave,'file') ; continue ; end
        %         if isequal(img_name_depth(1:end-22),img_name)
        %         if isequal(img_name_depth(1:end-10),img_name)
%         if isequal(img_name_depth(1:end-11),img_name)
        if strfind(img_name_depth,img_name)
            img = imread(names_train{i});
            [O1,O2,O3] = RGB2O(img);
            w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;
            img_data=imread(names_train_depth{i});
          %  if isequal(size(img_data )
            c_opp_Depth_image = cat(3,w1,w2,img_data); %copp_depth
            O_Depth_image = cat(3,O1,O2,img_data);% opp-depth
            op = cat(3,O1,O2,O3); % opp only
            op_c = cat(3,w1,w2,O3); % copp only
            imwrite(c_opp_Depth_image*255 , fullfile(save_dir,'images/train/',cur_dir_name,one_cache_file));
            imwrite(O_Depth_image , fullfile(save_dir1,'images/train/',cur_dir_name,one_cache_file));
            imwrite(op , fullfile(save_dir2,'images/train/',cur_dir_name,one_cache_file));
            imwrite(op_c, fullfile(save_dir3,'images/train/',cur_dir_name,one_cache_file));
        else
            display ('error on this image as both images are not same');
            img_name
            img_name_depth
        end
    end
end
display('done')
%% Validation images
ims_depth = dir(fullfile(opts.dataDir, 'images', 'val', '*.png')) ;
% ims.nam = sort({ims.name}) ;
names_val_depth = strcat([opts.dataDir,'images/val/'], {ims_depth.name}) ;
ims = dir(fullfile(opts.dataDir_rgb, 'images', 'val',  '*.JPEG')) ;
names_val = strcat([opts.dataDir_rgb,'images/val/'], {ims.name}) ;
if exist([save_dir,'images/val/'],'dir') ; else     mkdir([save_dir,'images/val/']); end
if exist([save_dir1,'images/val/'],'dir'); else     mkdir([save_dir1,'images/val/']); end
if exist([save_dir2,'images/val/'],'dir'); else     mkdir([save_dir2,'images/val/']); end
if exist([save_dir3,'images/val/'],'dir'); else     mkdir([save_dir3,'images/val/']); end

parfor ii = 1:length(names_val)
    fprintf('processing image  val (%d of %d)\n', ii, length(names_val));
    [img_dir_depth, img_name_depth]=fileparts(names_val_depth{ii});
    [img_dir, img_name]=fileparts(names_val{ii});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(save_dir,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    %         if isequal(img_name_depth(1:end-22),img_name)
    %         if isequal(img_name_depth(1:end-10),img_name)
    %if isequal(img_name_depth(1:end-11),img_name)
    if strfind(img_name_depth,img_name)
        img = imread(names_val{ii});
        [O1,O2,O3] = RGB2O(img);
        w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;
        %C_image=cat(3,w1,w2,w3);
        img_data=imread(names_val_depth{ii});
        c_opp_Depth_image = cat(3,w1,w2,img_data); %copp_depth
        O_Depth_image = cat(3,O1,O2,img_data);% opp-depth
        op = cat(3,O1,O2,O3); % opp only
        op_c = cat(3,w1,w2,O3); % copp only
        imwrite(c_opp_Depth_image*255 , fullfile(save_dir,'images/val/',one_cache_file));
        imwrite(O_Depth_image , fullfile(save_dir1,'images/val/',one_cache_file));
        imwrite(op , fullfile(save_dir2,'images/val/',one_cache_file));
        imwrite(op_c, fullfile(save_dir3,'images/val/',one_cache_file));
    else
        display ('error on this image as both images are not same');
        img_name
        img_name_depth
        
    end
end
display('done')
%% Test images
ims_depth = dir(fullfile(opts.dataDir, 'images', 'test', '*.png')) ;
names_test_depth = strcat([opts.dataDir,'images/test/'], {ims_depth.name}) ;
ims = dir(fullfile(opts.dataDir_rgb, 'images', 'test',  '*.JPEG')) ;
names_test = strcat([opts.dataDir_rgb,'images/test/'], {ims.name}) ;
if exist([save_dir,'images/test/'],'dir') ;else     mkdir([save_dir,'images/test/']); end
if exist([save_dir1,'images/test/'],'dir'); else     mkdir([save_dir1,'images/test/']); end
if exist([save_dir2,'images/test/'],'dir') ;else     mkdir([save_dir2,'images/test/']); end
if exist([save_dir3,'images/test/'],'dir'); else     mkdir([save_dir3,'images/test/']); end
parfor ii = 1:length(names_test)
    fprintf('processing image  test (%d of %d)\n', ii, length(names_test));
    [img_dir_depth, img_name_depth]=fileparts(names_test_depth{ii});
    [img_dir, img_name]=fileparts(names_test{ii});
    one_cache_file=strcat([img_name,'.jpg']);
    imsave = fullfile(save_dir,one_cache_file);
    if exist(imsave,'file') ; continue ; end
    %         if isequal(img_name_depth(1:end-22),img_name)
    %         if isequal(img_name_depth(1:end-10),img_name)
%     if isequal(img_name_depth(1:end-11),img_name)
     if strfind(img_name_depth,img_name)
        img = imread(names_test{ii});
        [O1,O2,O3] = RGB2O(color(img));
        w1 = O1./(O3+eps);   w2 = O2./(O3+eps);  w3 = O3;
        %C_image=cat(3,w1,w2,w3);
        img_data=imread(names_test_depth{ii});
        c_opp_Depth_image = cat(3,w1,w2,img_data); %copp_depth
        O_Depth_image = cat(3,O1,O2,img_data);% opp-depth
        op = cat(3,O1,O2,O3); % opp only
        op_c = cat(3,w1,w2,O3); % copp only
        imwrite(c_opp_Depth_image*255 , fullfile(save_dir,'images/test/',one_cache_file));
        imwrite(O_Depth_image , fullfile(save_dir1,'images/test/',one_cache_file));
        imwrite(op , fullfile(save_dir2,'images/test/',one_cache_file));
        imwrite(op_c, fullfile(save_dir3,'images/test/',one_cache_file));
    else
        display ('error on this image as both images are not same');
        img_name
        img_name_depth
    end
end
display('done')