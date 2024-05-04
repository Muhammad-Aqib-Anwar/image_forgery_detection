%% Object Fourier Transform 
 
% clear all ; clc ; close all ; 
% img1=imread('Object.tif');    %Read hologram image of Object 
% img1=imread('person_fake.jpg');
img1=imread('fake00014.png');
figure(1) ; imshow(img1) , title('Original Object hologram ')
img1=double(img1)/255;
im2=fftshift(fft2(img1));              %Frequency spectrum of hologram
%im3=abs(im2);                         %Absolute of the FT
figure(2);imagesc(log(abs(im2)));
[sy,sx]=size(im2);                   %Determining size of the array
max_o=0;                              %Assuming maximum value of array as zero
for kk=1:sy                         %Scanning to find the position of maximum value of the array
    for mm=1:round(sx/2)-30         %Leave out the DC part
        vpix=im2(kk,mm);
        if vpix>max_o
            max_o=vpix;
            rw=kk;
            cl=mm;
        end;
    end;
end;
wsize=50;                           %Size of the spectrum window
filt_spect_obj=im2(rw-wsize:rw+wsize,cl-wsize:cl+wsize);     %Filterd spetrcum containg the frequencies inside the window
shift_spect_obj=zeros(sy,sx);                               %Creating zero array having same size as hologram
shift_spect_obj(round(sy/2)-wsize:round(sy/2)+wsize,round(sx/2)-wsize:round(sx/2)+wsize)=filt_spect_obj;    %Placing the filtered wondow at teh center
figure(3);imagesc(log(abs(shift_spect_obj)));
%% Inverse of Fourier Transform of Object
Inv_FF_obj = ifft2(shift_spect_obj); 
figure(4);imagesc(log(abs(Inv_FF_obj)));
%% Reference Fourier Transform 
img2=imread('Reference.tif');    %Read hologram image of Reference 
figure(5) ; imshow(img2) , title('Original Reference hologram ')
img_r=double(img2)/255;
im2_r=fftshift(fft2(img_r));  
%im3_r=abs(im2_r);
figure(6);imagesc(log(abs(im2_r)));
[sy_r,sx_r]=size(im2_r);                   %Determining size of the array
max_r=0;  
for k=1:sy_r                         %Scanning to find the position of maximum value of the array
    for m=1:round(sx_r/2)-30         %Leave out the DC part
        vpix_r=im2_r(k,m);
        if vpix_r>max_r
            max_r=vpix_r;
            rw_r=k;
            cl_r=m;
        end;
    end;
end;
wsize_ref = 50 ; 
filt_spect_ref=im2_r(rw_r-wsize_ref:rw_r+wsize_ref,cl_r-wsize_ref:cl_r+wsize_ref);     %Filterd spetrcum containg the frequencies inside the window
shift_spect_ref=zeros(sy_r,sx_r);                               %Creating zero array having same size as hologram
shift_spect_ref(round(sy_r/2)-wsize_ref:round(sy_r/2)+wsize_ref,round(sx_r/2)-wsize_ref:round(sx_r/2)+wsize_ref)=filt_spect_ref;    %Placing the filtered wondow at teh center
figure(7);imagesc(log(abs(shift_spect_ref)));
%% Inverse of Fourier Transform of Object
Inv_FF_ref = ifft2(shift_spect_ref); 
figure(8);imagesc(log(abs(Inv_FF_ref)));
%% find out the phase of reference and object 
phase_ref=angle(Inv_FF_ref) ;
phase_obj=angle(Inv_FF_obj) ;
% Difference of phase
phase_diff=phase_obj-phase_ref ;
figure(9); imshow(abs(phase_diff)) ; title('wrapped Phase Difference') ;

