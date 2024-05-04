
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
outpath = '/Users/apple/Downloads/data-images/all_images/400*400_t/t_000' ;
close all , clc , clear all
Im = imread('DPP0012.TIF');
% Im=rgb2gray(Im)
[M,N,~] = size(Im);
rr = 400; cc = 400; xx = 64; yy = 30 ;

numBlocksYY = numel(1:rr-xx:(M-(rr-1)));
numBlocksXX = numel(1:cc-yy:(N-(cc-1)));
[numBlocksYY, numBlocksXX]
C = cell(numBlocksYY*numBlocksXX,1);
counter = 1;
for ii=1:rr-xx:(M-(rr-1))
    for jj=1:cc-yy:(N-(cc-1))
        fprintf('[%d:%d, %d:%d]\n',ii,ii+rr-1,jj,jj+cc-1);
        C{counter} =  Im(ii:(ii+rr-1), jj:(jj+cc-1), : );
        counter = counter + 1;
    end
    fprintf('\n');
end

figure;
for ii=1:numBlocksYY*numBlocksXX
    subplot(numBlocksYY,numBlocksXX,ii), imagesc( C{ii} ); axis image; colormap gray ;
    image=cell2mat(C(ii)) ;
    newimagename = [outpath num2str(ii) '.png'];
    imwrite(image,newimagename)
end

% for in=1:length(C)
%     image=cell2mat(C(in)) ;
%     newimagename = [outpath num2str(in) '.png'];
%     imwrite(image,newimagename)
%     
%     
% end