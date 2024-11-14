%%
% Homework Solution - HW1
% Mohammad Sadegh Kalami Yazdi
% Student ID: 402811068
close all; clear
%% 1 - Compute the 2D DFT using 1D DFTs
image_path = 'D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\cameraman.tif'; 
img = imread(image_path); 

if size(img, 3) == 3
    img = rgb2gray(img);
end

% Convert the image to double precision for computation
img = double(img);

% a) Compute the 1D DFT of each row
F_row = fft(img, [], 2);

% b) Compute the 1D DFT of each column of the result from step (a)
F = fft(F_row, [], 1);

% c) Transpose the result
F_transposed = F.';

figure;
subplot(1, 3, 1);
imshow(uint8(img));
title('Original Image');

subplot(1, 3, 2);
imshow(log(abs(F) + 1), []);
colormap(gca, jet); colorbar;
title('Magnitude Spectrum of 2D DFT');

subplot(1, 3, 3);
imshow(log(abs(F_transposed) + 1), []);
colormap(gca, jet); colorbar;
title('Magnitude Spectrum of Transposed DFT');

%% 2 - Swap the Phase Components of the DFTs of Two Images
img1 = imread('cameraman.tif'); % First image
img2 = imread('moon.tif');      % Second image

if size(img1, 3) == 3
    img1 = rgb2gray(img1);
end
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end

img2 = imresize(img2, size(img1));

img1 = double(img1);
img2 = double(img2);

% Compute the 2D DFTs of both images
F1 = fft2(img1);
F2 = fft2(img2);

mag1 = abs(F1);
phase1 = angle(F1);

mag2 = abs(F2);
phase2 = angle(F2);

F1_new = mag1 .* exp(1i * phase2);
F2_new = mag2 .* exp(1i * phase1);

img1_new = real(ifft2(F1_new));
img2_new = real(ifft2(F2_new));

figure;
subplot(2, 2, 1);
imshow(uint8(img1));
title('Original Image 1');

subplot(2, 2, 2);
imshow(uint8(img2));
title('Original Image 2');

subplot(2, 2, 3);
imshow(uint8(img1_new));
title('Image 1 with Phase of Image 2');

subplot(2, 2, 4);
imshow(uint8(img2_new));
title('Image 2 with Phase of Image 1');