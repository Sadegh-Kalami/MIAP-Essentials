clear; close all; clc

image_data = im2double(rgb2gray(imread('..\..\..\..\chest-ct-scan.jpg')));

noisy_10db = awgn(image_data, 10);
noisy_15db = awgn(image_data, 15);
noisy_20db = awgn(image_data, 20);

psnr_10db = psnr(noisy_10db, image_data);
psnr_15db = psnr(noisy_15db, image_data);
psnr_20db = psnr(noisy_20db, image_data);

temp_img = image_data * 255;
block_size = 8;
redundancy = 4;
num_atoms = redundancy * block_size^2;

noisy_temp_10db = noisy_10db * 255;
sigma_10 = 75;
[denoised_10db, ~] = denoiseImageKSVD(noisy_temp_10db, sigma_10, num_atoms);
psnr_denoised_10db = 20 * log10(255 / sqrt(mean((denoised_10db(:) - temp_img(:)).^2)));

noisy_temp_15db = noisy_15db * 255;
sigma_15 = 45;
[denoised_15db, ~] = denoiseImageKSVD(noisy_temp_15db, sigma_15, num_atoms);
psnr_denoised_15db = 20 * log10(255 / sqrt(mean((denoised_15db(:) - temp_img(:)).^2)));

noisy_temp_20db = noisy_20db * 255;
sigma_20 = 25;
[denoised_20db, ~] = denoiseImageKSVD(noisy_temp_20db, sigma_20, num_atoms);
psnr_denoised_20db = 20 * log10(255 / sqrt(mean((denoised_20db(:) - temp_img(:)).^2)));

figure;
subplot(3, 3, 1); imshow(image_data); title('Original');
subplot(3, 3, 2); imshow(noisy_10db); title(['Noisy (PSNR: ', num2str(psnr_10db), ')']);
subplot(3, 3, 3); imshow(denoised_10db / 255); title(['KSVD (PSNR: ', num2str(psnr_denoised_10db), ')']);

subplot(3, 3, 4); imshow(image_data); title('Original');
subplot(3, 3, 5); imshow(noisy_15db); title(['Noisy (PSNR: ', num2str(psnr_15db), ')']);
subplot(3, 3, 6); imshow(denoised_15db / 255); title(['KSVD (PSNR: ', num2str(psnr_denoised_15db), ')']);

subplot(3, 3, 7); imshow(image_data); title('Original');
subplot(3, 3, 8); imshow(noisy_20db); title(['Noisy (PSNR: ', num2str(psnr_20db), ')']);
subplot(3, 3, 9); imshow(denoised_20db / 255); title(['KSVD (PSNR: ', num2str(psnr_denoised_20db), ')']);