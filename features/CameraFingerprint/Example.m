% Camera identification example

function [Fingerprint,Noisex,C]=Example(im)
'Example - Do the three images represent the same camera that took the image Pxxx.jpg?';
addpath '/Users/Shared/Relocated Items/Security/thesis/code/CameraFingerprint/Filter' ;
addpath '/Users/Shared/Relocated Items/Security/thesis/code/CameraFingerprint/Functions'
% im1 = 'Images\P1.jpg',
% im2 = 'Images\P2.jpg',
% im3 = 'Images\P3.jpg',
% Images(1).name = im1;  Images(2).name = im2;  Images(3).name = im3; 
Images=im ;
RP = getFingerprint(Images);
RP = rgb2gray1(RP);
    sigmaRP = std2(RP);
Fingerprint = WienerInDFT(RP,sigmaRP);

% imx = 'Images\Pxxx.jpg',
imx= im ;
Noisex = NoiseExtractFromImage(imx,2);
Noisex = WienerInDFT(Noisex,std2(Noisex));

% The optimal detector (see publication "Large Scale Test of Sensor Fingerprint Camera Identification")
% Ix = double(rgb2gray(imread(imx)));
Ix = double(imread(imx));
C = crosscorr(Noisex,Ix.*Fingerprint);
% detection = PCE(C)

end