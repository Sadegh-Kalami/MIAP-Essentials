clc; clear; close all;

% Load and preprocess the MRI image
input_img = im2double(rgb2gray(imread('..\..\chest-ct-scan.jpg')));

% Add Gaussian noise with different levels
noisy_img_10db = awgn(input_img, 10);
noisy_img_15db = awgn(input_img, 15);
noisy_img_20db = awgn(input_img, 20);

% Calculate PSNR for noisy images
psnr_10db = psnr(noisy_img_10db, input_img);
psnr_15db = psnr(noisy_img_15db, input_img);
psnr_20db = psnr(noisy_img_20db, input_img);

% Display noisy images with PSNR values
figure;
subplot(1, 3, 1); imshow(noisy_img_10db); title(['Noisy (10 dB, PSNR: ', num2str(psnr_10db), ')']);
subplot(1, 3, 2); imshow(noisy_img_15db); title(['Noisy (15 dB, PSNR: ', num2str(psnr_15db), ')']);
subplot(1, 3, 3); imshow(noisy_img_20db); title(['Noisy (20 dB, PSNR: ', num2str(psnr_20db), ')']);

% Apply Wiener2 filter to denoise the images
filtered_img_10db = wiener2(noisy_img_10db, [3 3]);
filtered_img_15db = wiener2(noisy_img_15db, [3 3]);
filtered_img_20db = wiener2(noisy_img_20db, [3 3]);

% Calculate PSNR for denoised images
psnr_filtered_10db = psnr(filtered_img_10db, input_img);
psnr_filtered_15db = psnr(filtered_img_15db, input_img);
psnr_filtered_20db = psnr(filtered_img_20db, input_img);

% Display results for denoised images
figure;
subplot(1, 3, 1); imshow(filtered_img_10db); title(['Denoised (10 dB, PSNR: ', num2str(psnr_filtered_10db), ')']);
subplot(1, 3, 2); imshow(filtered_img_15db); title(['Denoised (15 dB, PSNR: ', num2str(psnr_filtered_15db), ')']);
subplot(1, 3, 3); imshow(filtered_img_20db); title(['Denoised (20 dB, PSNR: ', num2str(psnr_filtered_20db), ')']);

sgtitle('Denoising Using Wiener2 Filter at Different Noise Levels');
