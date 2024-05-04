function imdb = cnn_ucf_setup_data(varargin)
opts.dataDir = fullfile('data','ucf_sports_actions') ;
opts.lite = false ;
opts = vl_argparse(opts, varargin) ;
devkitPath = fullfile(opts.dataDir) ;
classes_name = {'Diving-Side','Golf-Swing-Back','Golf-Swing-Front','Golf-Swing-Side','Kicking-Front',...
    'Kicking-Side','Lifting','Riding-Horse','Run-Side','SkateBoarding-Front','Swing-Bench',...
    'Swing-SideAngle','Walk-Front'};

imdb.classes.name = classes_name;
imdb.classes.description = classes_name;  %% description is same as classes name
% imdb.imageDir = dataDir;
imdb.imageDir = fullfile(opts.dataDir) ;
fprintf('searching training images ...\n') ;
names = {} ;
labels = {};
for i = 1: length(classes_name)
    % ims = dir(fullfile(dataDir,  classes_name{i}, '*.JPEG')) ;
    ims=  dir(fullfile(opts.dataDir,  classes_name{i},filesep,'*.jpg'));
    %% last 20 images in each folder as validation
     ims =  ims(1:end-20);
    names{end+1} = strcat([classes_name{i}, filesep], {ims.name}) ;
    labels{end+1} = ones(1, numel(ims)) * i ;
    fprintf('.') ;
end
names = horzcat(names{:}) ;
labels = horzcat(labels{:}) ;

imdb.images.id = 1:numel(names) ;
imdb.images.name = names ;
imdb.images.set = ones(1, numel(names)) ;
imdb.images.label = labels ;
% -------------------------------------------------------------------------
%                                                         Validation images
% -------------------------------------------------------------------------
fprintf('searching val images ...\n') ;
names = {} ;
labels = {};
for i = 1: length(classes_name)
    % ims = dir(fullfile(dataDir,  classes_name{i}, '*.JPEG')) ;
    ims=  dir(fullfile(opts.dataDir,  classes_name{i},filesep,'*.jpg'));
    %% last 20 images in each folder as validation
 ims = ims(end-19:end);
    names{end+1} = strcat([classes_name{i}, filesep], {ims.name}) ;
    labels{end+1} = ones(1, numel(ims)) * i ;
    fprintf('.') ;
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