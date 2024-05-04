
%%
% n=randi(10,9,3) ;  % generate random number with required output 
% disp(n)
% temp=0 %temperory variable 
% sx = size(n);
% sy = size(temp);
% a = max(sx(1),sy(1)) ;
% z = [[n;zeros(abs([a 0]-sx))],[temp;zeros(abs([a,0]-sy))]]
% result=reshape(z,[],6) ;
% disp(result)
close all ; clc ; clear all ;
inpath= '/Users/apple/Downloads/data-images/Canon_60D/tampered-realistic' ;
%  outpath='/Users/apple/Downloads/data-images/crop_000' ;
% outpath = '/Users/apple/Downloads/data-images/Sony_A57/tempered_400*400/crop_000' ;
im_dir = dir(fullfile(inpath,'*.TIF'));
image_names= {im_dir.name};
counter = 1;
% for ij= 1:length(image_names)
%    im = fullfile(inpath,im_dir(ij).name);
    Im = imread('r36610622t.TIF');
%     figure,imshow(im)
% Im=rgb2gray(Im)
[M,N,~] = size(Im);
rr = 400; cc = 400; xx = 64; yy = 30 ;
% rr = 350; cc = 350; xx = 64; yy = 30 ;
numBlocksYY = numel(1:rr-xx:(M-(rr-1)));
numBlocksXX = numel(1:cc-yy:(N-(cc-1)));
[numBlocksYY, numBlocksXX]
C = cell(numBlocksYY*numBlocksXX,1);
% counter = 1;
for ii=1:rr-xx:(M-(rr-1))
    for jj=1:cc-yy:(N-(cc-1))
        fprintf('[%d:%d, %d:%d]\n',ii,ii+rr-1,jj,jj+cc-1);
       C{counter} =  Im(ii:(ii+rr-1), jj:(jj+cc-1), : );
%         C =  Im(ii:(ii+rr-1), jj:(jj+cc-1), : );
       counter = counter + 1;
%         newimagename = [outpath num2str(counter) '.png'];
%         imwrite(C,newimagename)
%         counter = counter + 1;
    end
    fprintf('\n');
end

figure;
for ii=1:numBlocksYY*numBlocksXX
    subplot(numBlocksYY,numBlocksXX,ii), imagesc( C{ii} ); axis image; colormap gray ;
    image=cell2mat(C(ii)) ;
%     newimagename = [outpath num2str(ii) '.png'];
%     imwrite(image,newimagename)
end

% end

% for in=1:length(C)
%     image=cell2mat(C(in)) ;
%     newimagename = [outpath num2str(in) '.png'];
%     imwrite(image,newimagename)
%     
%     
% end