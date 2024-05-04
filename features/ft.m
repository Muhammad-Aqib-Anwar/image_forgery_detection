% 2D FFT Demo to blur an image, and show spectra of both original and blurred images.
function [shiftedFFT]=ft(img)
% clc;    % Clear the command window.
% close all;  % Close all figures (except those of imtool.)
% imtool close all;  % Close all imtool figures.
% clear;  % Erase all existing variables.
% workspace;  % Make sure the workspace panel is showing.
% format longg;
% format compact;
 fontSize = 20;

% Change the current folder to the folder of this m-file.

% Read in a standard MATLAB gray scale demo image.

% Read in image.
% grayImage = imread('cameraman.tif');
[rows columns numberOfColorChannels] = size(img)
if numberOfColorChannels > 1
	grayImage = rgb2gray(img);
end

% Display original grayscale image.
% % subplot(2, 2, 1);
% % imshow(grayImage)
% % title('Original Gray Scale Image', 'FontSize', fontSize)

% Perform 2D FFTs
fftOriginal = fft2(double(grayImage));
shiftedFFT = fftshift(fftOriginal);
% % subplot(2, 2, 2);
scaledFFTr = 255 * mat2gray(real(shiftedFFT));
% % imshow(log(scaledFFTr), []);
% % title('Log of Real Part of Spectrum', 'FontSize', fontSize)
% % subplot(2, 2, 3);
scaledFFTi = mat2gray(imag(shiftedFFT));
% % imshow(log(scaledFFTi), []);
% % title('Log of Imaginary Part of Spectrum', 'FontSize', fontSize)

% Display magnitude and phase of 2D FFTs
% % subplot(2, 2, 4);
% % imshow(log(abs(shiftedFFT)),[]);
% % colormap gray
% % title('Log Magnitude of Spectrum', 'FontSize', fontSize)
% % % Enlarge figure to full screen.
% % set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Now convolve with a 2D rect function.

end

