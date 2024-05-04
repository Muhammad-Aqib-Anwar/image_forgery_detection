function imdb = cnn_ucf101_setup_data_new_OFRGB(opts,split_ind)
[id,class] = textread(sprintf(fullfile(opts.dataDir,'ucfTrainTestlist','classInd.txt')),'%d%s');
imdb.classes.name = class;
imdb.classes.description = id;  %% description is same as classes name
imdb.imageDir = fullfile(opts.dataDir, 'OFandRGBImages') ;
% -------------------------------------------------------------------------
%                                                           Training images
% -------------------------------------------------------------------------
fprintf('searching training images ...\n') ;
%% According to splits_ind for training using split 1
[video_class,video_class_id] = textread(sprintf(fullfile(opts.dataDir,'ucfTrainTestlist','trainlist0%d.txt'),split_ind),'%s%d');
num_id = length(video_class);
names = cell(1,num_id) ;
names_OF = cell(1,num_id) ;
labels = cell(1,num_id);%{};
% /triton/ics/project/imagedb/anwerr1/Datasets/UCF101/OpticalFlowImages
for i = 1:length(video_class)
    i
    ims=  dir(fullfile(opts.dataDir, 'OFandRGBImages', video_class{i}(1:end-4),filesep,'*.jpg'));
    %% for separate image names 
    ims1=  dir(fullfile(opts.dataDir, 'OFandRGBImages', video_class{i}(1:end-4),filesep,'RGB_*.jpg'));
    ims2=  dir(fullfile(opts.dataDir, 'OFandRGBImages', video_class{i}(1:end-4),filesep,'OF_*.jpg'));
    
    names{i} = strcat([video_class{i}(1:end-4), filesep], {ims1.name}) ;
    names_OF{i} = strcat([video_class{i}(1:end-4), filesep], {ims2.name}) ;
    labels{i} = ones(1, numel(ims)) *video_class_id(i) ;
    %     fprintf('.') ;
    %     if mod(numel(names), 50) == 0, fprintf('\n') ; end
end
names = horzcat(names{:}) ;
names_OF = horzcat(names_OF{:}) ;
labels = horzcat(labels{:}) ;

imdb.images.id = 1:numel(names) ;
imdb.images.name = names ;
imdb.images.name_OF = names_OF ;

imdb.images.set = ones(1, numel(names)) ;
imdb.images.label = labels ;
% -------------------------------------------------------------------------
%                                                         Validation images
% -------------------------------------------------------------------------
%% Just taking few videos out of all 101 class using split 2 or 3
[video_class_val,video_class_id_val] = textread(sprintf(fullfile(opts.dataDir,'ucfTrainTestlist','trainlist0%d.txt'),split_ind+1),'%s%d');
video_class_id_val = video_class_id_val(1:25:end);
video_class_val = video_class_val(1:25:end);
fprintf('searching val images ...\n') ;
num_id_val = length(video_class_id_val);
names = cell(1,num_id_val);%{} ;
labels =cell(1,num_id_val);% {};
parfor i = 1:length(video_class_val)
    i
    ims=  dir(fullfile(opts.dataDir, 'OFandRGBImages', video_class_val{i}(1:end-4),filesep,'*.jpg'));
    names{i} = strcat([video_class_val{i}(1:end-4), filesep], {ims.name}) ;
    labels{i} = ones(1, numel(ims)) *video_class_id_val(i) ;
    %     fprintf('.') ;
    %     if mod(numel(names), 50) == 0, fprintf('\n') ; end
end

names = horzcat(names{:}) ;
labels = horzcat(labels{:}) ;

imdb.images.id = horzcat(imdb.images.id, (1:numel(names)) + 1e7 - 1) ;
imdb.images.name = horzcat(imdb.images.name, names) ;
imdb.images.set = horzcat(imdb.images.set, 2*ones(1,numel(names))) ;
imdb.images.label = horzcat(imdb.images.label, labels) ;
% sort categories by WNID (to be compatible with other implementations)
[imdb.classes.name,perm] = sort(imdb.classes.name) ;
imdb.classes.description = imdb.classes.description(perm) ;
relabel(perm) = 1:numel(imdb.classes.name) ;
ok = imdb.images.label >  0 ;
imdb.images.label(ok) = relabel(imdb.images.label(ok)) ;

if opts.lite
    % pick a small number of images for the first 10 classes
    % this cannot be done for test as we do not have test labels
    clear keep ;
    for i=1:10
        sel = find(imdb.images.label == i) ;
        train = sel(imdb.images.set(sel) == 1) ;
        val = sel(imdb.images.set(sel) == 2) ;
        train = train(1:256) ;
        val = val(1:40) ;
        keep{i} = [train val] ;
    end
    test = find(imdb.images.set == 3) ;
    keep = sort(cat(2, keep{:}, test(1:1000))) ;
    imdb.images.id = imdb.images.id(keep) ;
    imdb.images.name = imdb.images.name(keep) ;
    imdb.images.set = imdb.images.set(keep) ;
    imdb.images.label = imdb.images.label(keep) ;
end

% function files = clean_dir(base)
% %clean_dir just runs dir and eliminates files in a foldr
% files = dir(base);
% files_tmp = {};
% for i = 1:length(files)
%     if strncmpi(files(i).name, '.',1) == 0
%         files_tmp{length(files_tmp)+1} = files(i).name;
%     end
% end
% files = files_tmp;

