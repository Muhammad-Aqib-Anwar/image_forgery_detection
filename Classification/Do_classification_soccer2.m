
function [svm1,max_score]=Do_classification_soccer2(All_hist)



% MULTICLASS SVM USING ONE AGAINST ALL 
%%%% to incorporate 10 classes
%-----------------------------------------------------
%   Learning and Learning Parameters

all_hist_C=All_hist;
numVOC=2;
% start_row=[1,51,851];
% end_row=[50,850,1450];
start_row=[1,801];
end_row=[800,1400];
epsilon = .000001;
kerneloption= 1;
kernel='gaussian';
verbose = 0;
nbclass=10;
numberIt=1;
svm1=zeros(numberIt,1);
svm2=zeros(numberIt,nbclass);
svm_score_flag=1;
all_list=[];
perclass_image=40;
total_image=400;
N=25;
yapp=[];
% For SVM_score, Craeting a class_list
for jj=1:nbclass
    class_list{jj}=[];
    yapp=[yapp; jj*ones(N,1)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cross validation 

list=1:40;
        all_histL=[];
for jj=1:nbclass
             all_histL=[all_histL;all_hist_C(:,list(1:N)+(jj-1)*perclass_image)'];
end
 [c,lambda,max_score]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose);
%c=100;lambda=0.001;
if(numVOC==2)
     [all_histL,all_hist_C,alpha]=learn_alpha(all_histL,all_hist_C,c,lambda,yapp,nbclass,kernel,kerneloption,verbose,start_row(1),end_row(1),start_row(2),end_row(2) );        

elseif (numVOC==3)
     [all_histL,all_hist_C,alpha]=learn_alpha(all_histL,all_hist_C,c,lambda,yapp,nbclass,kernel,kerneloption,verbose,start_row(1),end_row(1),start_row(2),end_row(2) );
%      [c,lambda,max_score]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose);
     [all_histL,all_hist_C,alpha2]=learn_alpha(all_histL,all_hist_C,c,lambda,yapp,nbclass,kernel,kerneloption,verbose,start_row(1),end_row(2),start_row(3),end_row(3) );
%       [c,lambda,max_score]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose);
end         
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [c,lambda,max_score]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose);
   [c,lambda,max_score]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose);

    num_test=perclass_image-N;
    total=total_image-N*nbclass;
    [xx,GT]=ndgrid(1:num_test,1:nbclass);
    fprintf(1,'\n');    
for ii=1:numberIt   
        fprintf(1,'\b%d',ii);
        all_histL=[];
        all_histT=[];

list=1:40;
for jj=1:nbclass
            all_histL=[all_histL;all_hist_C(:,list(1:N)+(jj-1)*perclass_image)'];
            all_histT=[all_histT;all_hist_C(:,list(N+1:perclass_image)+(jj-1)*perclass_image)'];            
end
        
        [xsup,w,b,nbsv]=svmmulticlassoneagainstall(all_histL,yapp,nbclass,c,lambda,kernel,kerneloption,verbose);
        [ypred,maxi] = svmmultival(all_histT,xsup,w,b,nbsv,kernel,kerneloption);
        svm2(ii,:)=( sum( reshape(ypred,size(GT,1),size(GT,2))==GT  ) )/num_test;
        svm1(ii)=( sum(ypred==GT(:)) )/total;
        %only works when the flag is set, used to calculate SVM_SCORE   
if(svm_score_flag)
                   list2=[];
for jj=1:nbclass
                   list2=[list2,list(N+1:perclass_image)+(jj-1)*perclass_image];
end
for jj=1:nbclass
                    temp=class_list{jj};
                    class_list{jj}=[temp,list2(ypred(1:nbclass*num_test)==jj)];
end
                    all_list=[all_list,list2];
end
end
% FOR DISPLAYING THE AVERAGE MEAN AND THE MEAN PER EACH CLASS
    disp(' ');
    disp('The MEAN IS = ');
    disp(mean(svm1))
    disp('The MEAN per class = ');
    disp(mean(svm2))
    disp(sprintf('The SVM settings: c=%f and lambda=%f and svm_score=%f',c,lambda,max_score));
if(numVOC==2)
        disp(sprintf('The results are obtained with alpha=%f',alpha));
end
if(numVOC==3)
        disp(sprintf('The results are obtained with alpha=%f for texture and alpha2=%f for color ',alpha,alpha2));
        disp(sprintf('SIFT= %f, LBP = %f, COLOR= %f',(1-alpha)*(1-alpha2),alpha*(1-alpha2),alpha2));

%         A1=sum(sum(distance( all_hist(1:600,:)', all_hist(1:600,:)' )));
%         A2=sum(sum(distance( all_hist(601:660,:)',all_hist(601:660,:)')));
%         A3=sum(sum(distance( all_hist(661:710,:)',all_hist(661:710,:)' )));
%         
        display(sprintf('distance based weight: SIFT=%f, LBP=%f, COLOR= %f',A1/(A1+A2+A3),A2/(A1+A2+A3),A3/(A1+A2+A3)));
end





