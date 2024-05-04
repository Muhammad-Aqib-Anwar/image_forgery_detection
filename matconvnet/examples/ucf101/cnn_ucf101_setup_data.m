function imdb = cnn_ucf101_setup_data(opts,split_ind)
% opts.dataDir = fullfile('/triton/ics/project/imagedb/anwerr1/Datasets/UCF101/') ;
% opts.lite = false ;
% opts = vl_argparse(opts, varargin) ;
dataDir = '/triton/ics/project/imagedb/anwerr1/Datasets/UCF101/UCF-101/';
% classes_name = {'ApplyEyeMakeup';'ApplyLipstick';'Archery';'BabyCrawling';...
%     'BalanceBeam';'BandMarching';'BaseballPitch';'Basketball';'BasketballDunk';...
%     'BenchPress';'Biking';'Billiards';'BlowDryHair';'BlowingCandles';...
%     'BodyWeightSquats';'Bowling';'BoxingPunchingBag';'BoxingSpeedBag';...
%     'BreastStroke';'BrushingTeeth';'CleanAndJerk';'CliffDiving';'CricketBowling';...
%     'CricketShot';'CuttingInKitchen';'Diving';'Drumming';'Fencing';'FieldHockeyPenalty';...
%     'FloorGymnastics';'FrisbeeCatch';'FrontCrawl';'GolfSwing';'Haircut';'HammerThrow';...
%     'Hammering';'HandstandPushups';'HandstandWalking';'HeadMassage';'HighJump';'HorseRace';...
%     'HorseRiding';'HulaHoop';'IceDancing';'JavelinThrow';'JugglingBalls';'JumpRope';...
%     'JumpingJack';'Kayaking';'Knitting';'LongJump';'Lunges';'MilitaryParade';'Mixing';...
%     'MoppingFloor';'Nunchucks';'ParallelBars';'PizzaTossing';'PlayingCello';'PlayingDaf';...
%     'PlayingDhol';'PlayingFlute';'PlayingGuitar';'PlayingPiano';'PlayingSitar';'PlayingTabla';...
%     'PlayingViolin';'PoleVault';'PommelHorse';'PullUps';'Punch';'PushUps';'Rafting';...
%     'RockClimbingIndoor';'RopeClimbing';'Rowing';'SalsaSpin';'ShavingBeard';'Shotput';...
%     'SkateBoarding';'Skiing';'Skijet';'SkyDiving';'SoccerJuggling';'SoccerPenalty';...
%     'StillRings';'SumoWrestling';'Surfing';'Swing';'TableTennisShot';'TaiChi';...
%     'TennisSwing';'ThrowDiscus';'TrampolineJumping';'Typing';'UnevenBars';'VolleyballSpiking';...
%     'WalkingWithDog';'WallPushups';'WritingOnBoard';'YoYo'};
% /triton/ics/project/imagedb/anwerr1/Datasets/UCF101/ucfTrainTestlist
[id,class] = textread(sprintf(fullfile(opts.dataDir,'ucfTrainTestlist','classInd.txt')),'%d%s');
%% Create images for each class video
% base = '/triton/ics/project/imagedb/anwerr1/Datasets/UCF101/Images/';  % images directrory
imdb.classes.name = class;
imdb.classes.description = id;  %% description is same as classes name
imdb.imageDir = fullfile(opts.dataDir, 'Images') ;
% imdb.imageDir = fullfile(opts.dataDir) ;
% -------------------------------------------------------------------------
%                                                           Training images
% -------------------------------------------------------------------------
fprintf('searching training images ...\n') ;
names = {} ;
labels = {};
%% According to splits_ind for training using split 1
[video_class,video_class_id] = textread(sprintf(fullfile(opts.dataDir,'ucfTrainTestlist','trainlist0%d.txt'),split_ind),'%s%d');
% list = clean_dir(imdb.imageDir);
for i = 1:length(video_class)
    ims=  dir(fullfile(opts.dataDir, 'Images', video_class{i}(1:end-4),filesep,'*.jpg'));
    names{end+1} = strcat([video_class{i}(1:end-4), filesep], {ims.name}) ;
    labels{end+1} = ones(1, numel(ims)) *video_class_id(i) ;
    fprintf('.') ;
    if mod(numel(names), 50) == 0, fprintf('\n') ; end
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
%% Just taking few videos out of all 101 class using split 2 or 3 
[video_class_val,video_class_id_val] = textread(sprintf(fullfile(opts.dataDir,'ucfTrainTestlist','trainlist0%d.txt'),split_ind+1),'%s%d');
video_class_id_val = video_class_id_val(1:25:end);
video_class_val = video_class_val(1:25:end);
fprintf('searching val images ...\n') ;
names = {} ;
labels = {};
for i = 1:length(video_class_val)
    ims=  dir(fullfile(opts.dataDir, 'Images', video_class_val{i}(1:end-4),filesep,'*.jpg'));
    names{end+1} = strcat([video_class_val{i}(1:end-4), filesep], {ims.name}) ;
    labels{end+1} = ones(1, numel(ims)) *video_class_id_val(i) ;
    fprintf('.') ;
    if mod(numel(names), 50) == 0, fprintf('\n') ; end
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

