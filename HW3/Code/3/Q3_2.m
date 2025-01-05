clc; clear; close all;

% Load and preprocess image
img = imread('..\..\chest-ct-scan.jpg');
if ndims(img) == 3
    gray_img = im2double(rgb2gray(img));
else
    gray_img = im2double(img);
end

% Add Gaussian noise at different levels
noisy_img_10db = awgn(gray_img, 10);
noisy_img_15db = awgn(gray_img, 15);
noisy_img_20db = awgn(gray_img, 20);

% Calculate PSNR for noisy images
psnr_10db = psnr(noisy_img_10db, gray_img);
psnr_15db = psnr(noisy_img_15db, gray_img);
psnr_20db = psnr(noisy_img_20db, gray_img);

% DCT and Thresholding for 10 dB Noise
dct_10db = dct2(noisy_img_10db);
hard_thresh_10db = idct2(wthresh(dct_10db, 'h', 0.85));
soft_thresh_10db = idct2(wthresh(dct_10db, 's', 0.4));
psnr_hard_10db = psnr(hard_thresh_10db, gray_img);
psnr_soft_10db = psnr(soft_thresh_10db, gray_img);

% DCT and Thresholding for 15 dB Noise
dct_15db = dct2(noisy_img_15db);
hard_thresh_15db = idct2(wthresh(dct_15db, 'h', 0.45));
soft_thresh_15db = idct2(wthresh(dct_15db, 's', 0.2));
psnr_hard_15db = psnr(hard_thresh_15db, gray_img);
psnr_soft_15db = psnr(soft_thresh_15db, gray_img);

% DCT and Thresholding for 20 dB Noise
dct_20db = dct2(noisy_img_20db);
hard_thresh_20db = idct2(wthresh(dct_20db, 'h', 0.25));
soft_thresh_20db = idct2(wthresh(dct_20db, 's', 0.1));
psnr_hard_20db = psnr(hard_thresh_20db, gray_img);
psnr_soft_20db = psnr(soft_thresh_20db, gray_img);

% Display results
figure;
subplot(3, 3, 1); imshow(noisy_img_10db); title(['Noisy (10 dB, PSNR: ', num2str(psnr_10db), ')']);
subplot(3, 3, 4); imshow(hard_thresh_10db); title(['Hard Thresh (PSNR: ', num2str(psnr_hard_10db), ')']);
subplot(3, 3, 7); imshow(soft_thresh_10db); title(['Soft Thresh (PSNR: ', num2str(psnr_soft_10db), ')']);

subplot(3, 3, 2); imshow(noisy_img_15db); title(['Noisy (15 dB, PSNR: ', num2str(psnr_15db), ')']);
subplot(3, 3, 5); imshow(hard_thresh_15db); title(['Hard Thresh (PSNR: ', num2str(psnr_hard_15db), ')']);
subplot(3, 3, 8); imshow(soft_thresh_15db); title(['Soft Thresh (PSNR: ', num2str(psnr_soft_15db), ')']);

subplot(3, 3, 3); imshow(noisy_img_20db); title(['Noisy (20 dB, PSNR: ', num2str(psnr_20db), ')']);
subplot(3, 3, 6); imshow(hard_thresh_20db); title(['Hard Thresh (PSNR: ', num2str(psnr_hard_20db), ')']);
subplot(3, 3, 9); imshow(soft_thresh_20db); title(['Soft Thresh (PSNR: ', num2str(psnr_soft_20db), ')']);

sgtitle('DCT Thresholding: Hard vs Soft Thresholding at Different Noise Levels');
