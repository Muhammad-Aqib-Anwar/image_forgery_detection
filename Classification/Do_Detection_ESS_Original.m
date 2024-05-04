
function Do_Detection_ESS_Original(opts, classification_opts,settings,weights)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display Message %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('Starting the ESS based Detection:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Some Baseline Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VOCINIT2007
 load(opts.trainset)
 temp.annotationpath1=opts.annotationpath;
 temp.minoverlap=opts.minoverlap;
 load(opts.data_locations);
 opts.annotationpath=temp.annotationpath1;
 opts.minoverlap=temp.minoverlap;
%  load(opts.testset)
 testset=getfield(load(opts.testset),'testset');
 image_names=getfield(load(opts.image_names),'image_names');
%  load(opts.image_names)
 nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
 clst_name='ikmeansSIFT_DorkoGrid_Dorko12000_aib300';
 opts.resultfolder='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Results_ESS/';
 opts.clstfolder='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/';
 opts.detrespath='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007//%s_det_val2_%s.txt';
 opts.dettemprespath='/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Results_ESS/';               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% image_sizes=getfield(load(sprintf('%s/image_sizes.mat',opts.bbpath)),'image_sizes');      % load image_size
image_size=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Labels/image_size'),'image_size');
CA_CN=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/ESS_Prob_CN/CA_CN_motorbike'),'CA_CN_motorbike');
CA_LBP=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/ESS_Prob_LBP/CA_LBP_500_motorbike'),'CA_LBP_500_motorbike');
index_list=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/Assignment/KmeansColorNMGrid_Dorko500_hybrid_index'),'index_list');
index_list_lbp=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/Assignment/ikmeansTexture_PatchGrid_Dorko5000_aib500_hybrid_index'),'index_list');
fid=fopen(sprintf(opts.detrespath, 'comp3',classification_opts.cls_name),'w');
fid=8;
parfor ii=1:length(labels)  %%% when using val as test set for VOC 2007, there are 5011 images
    if(testset(ii)==1)
        ii
        
            imt=sprintf('%s/%s',opts.imgpath,image_names{ii});
            imi=imread(imt);
            [h w nchan]=size(imi);
            w=w-1;
            h=h-1;
            img_name1=image_names{ii};
            img_name=img_name1(1:end-4);
            index=imt(1:end-4);
           
            
             clst=load([data_locations{ii},'/',classification_opts.index_name,'.clst']);
            numfeat = size(clst, 1);

            % From the cluster file we get position, word and max extent.
            x = clst(:,1); % x position
            y = clst(:,2); % y position
            c = clst(:,3); % cluster number
            numbins   = size(weights, 1);
            numlevels = 1;
            
    %%%%%%%%%%%%%%%%%%%%%%% use the next 2 lines for incorporating CA %%%%
    if(classification_opts.CA_flag)
        switch (classification_opts.CA_cues)
            case 1
                CA_weights=Do_CA_Weights_ESS(CA_CN,index_list{ii}, classification_opts.cls_num);
                box = ess_pyramid(numfeat, w, h, x, y, c, numbins, numlevels, weights,CA_weights);
            case 2
                CA_weights1=Do_CA_Weights_ESS(CA_CN,index_list{ii}, classification_opts.cls_num);
                CA_weights1=CA_weights1.^0.5;
                CA_weights2=Do_CA_Weights_ESS(CA_LBP,index_list_lbp{ii}, classification_opts.cls_num); %% in case of 2 attention cues
                CA_weights2=CA_weights2.^0.5;
%                 CA_weights=(CA_weights1.*CA_weights2);
                CA_weights=(CA_weights1.^5.0).*(CA_weights2.^3.0);
%                 CA_weights=(CA_weights1.^1.0).*(CA_weights2.^4.0);  %%%Weighting for different cues d
                box = ess_pyramid(numfeat, w, h, x, y, c, numbins, numlevels, weights,CA_weights);
        end
    else
        box = ess_pyramid(numfeat, w, h, x, y, c, numbins, numlevels, weights,ones(length(x),1)); %% for conventional use (with SIFT, ColorSIFT)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              box = ess_pyramid(numfeat, w, h, x, y, c, numbins, numlevels, weights);
%                box = ess_pyramid(numfeat, w, h, x, y, c, numbins, numlevels, weights,ones(length(x),1)); %% for conventional use (with SIFT, ColorSIFT)
%            box = ess_pyramid(numfeat, w, h, x, y, c, numbins, numlevels, weights,CA_CN(:,8));
            
            
            %%%%%%%%%%%%%% Main Line for running ESS %%%%%%%%%%%%%%%%%%
           

            % read the results file from the './ess' execution and store the informations
%             clear score; clear x1; clear y1; clear x2; clear y2;
%             [score, x1, y1, x2, y2]=textread(sprintf('%s%s%s',opts.dettemprespath, 'results',img_name), '%f %d %d %d %d');
            x1=box(1);y1=box(2);x2=box(3);y2=box(4);score=box(5);
            for jj=1:settings.number_det_test              
                x1(jj)=round((x1(jj)+1));       % do we need to round the values  ?
                y1(jj)=round((y1(jj)+1));
                x2(jj)=round((x2(jj)+1));
                y2(jj)=round((y2(jj)+1));
                
                % store the informations in the general results file
                fprintf(fid,'%s %f %d %d %d %d\n', img_name, score(jj), x1(jj), y1(jj), x2(jj), y2(jj));
                fprintf(' IMAGE NUMBER: %s      SCORE: %f       X1: %f   Y1: %f   X2: %f   y2: %f \n', img_name, score(jj), x1(jj), y1(jj), x2(jj), y2(jj));        
            end

% clear box
             system(sprintf('rm %sresults%s', opts.resultfolder,img_name));
     end
end
fclose(fid);
display('Detection is completed:');
pause
