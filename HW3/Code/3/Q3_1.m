clc; clear; close all;

% Load and preprocess image
input_img = im2double(imread('..\..\chest-ct-scan.jpg'));
if ndims(input_img) == 3
    gray_img = rgb2gray(input_img);
else
    gray_img = input_img;
end

% Add Gaussian noise at different levels
noisy_img_10db = awgn(gray_img, 10);
noisy_img_15db = awgn(gray_img, 15);
noisy_img_20db = awgn(gray_img, 20);

% Calculate PSNR for noisy images
psnr_10db = psnr(noisy_img_10db, gray_img);
psnr_15db = psnr(noisy_img_15db, gray_img);
psnr_20db = psnr(noisy_img_20db, gray_img);

% Soft Thresholding
[thr1, sorh1, keepapp1] = ddencmp('den', 'wv', noisy_img_10db);
soft_thresh_10db = wdencmp('gbl', noisy_img_10db, 'sym4', 2, thr1, sorh1, keepapp1);
psnr_soft_10db = psnr(soft_thresh_10db, gray_img);

[thr2, sorh2, keepapp2] = ddencmp('den', 'wv', noisy_img_15db);
soft_thresh_15db = wdencmp('gbl', noisy_img_15db, 'sym4', 2, thr2, sorh2, keepapp2);
psnr_soft_15db = psnr(soft_thresh_15db, gray_img);

[thr3, sorh3, keepapp3] = ddencmp('den', 'wv', noisy_img_20db);
soft_thresh_20db = wdencmp('gbl', noisy_img_20db, 'sym4', 2, thr3, sorh3, keepapp3);
psnr_soft_20db = psnr(soft_thresh_20db, gray_img);

% Display results for soft thresholding
figure;
subplot(2, 3, 1); imshow(noisy_img_10db); title(['Noisy (10 dB, PSNR: ', num2str(psnr_10db), ')']);
subplot(2, 3, 4); imshow(soft_thresh_10db); title(['Soft Thresh (PSNR: ', num2str(psnr_soft_10db), ')']);

subplot(2, 3, 2); imshow(noisy_img_15db); title(['Noisy (15 dB, PSNR: ', num2str(psnr_15db), ')']);
subplot(2, 3, 5); imshow(soft_thresh_15db); title(['Soft Thresh (PSNR: ', num2str(psnr_soft_15db), ')']);

subplot(2, 3, 3); imshow(noisy_img_20db); title(['Noisy (20 dB, PSNR: ', num2str(psnr_20db), ')']);
subplot(2, 3, 6); imshow(soft_thresh_20db); title(['Soft Thresh (PSNR: ', num2str(psnr_soft_20db), ')']);

sgtitle('Wavelet Denoising with Soft Thresholding');

% Hard Thresholding
[thr1, sorh1, keepapp1] = ddencmp('den', 'wp', noisy_img_10db);
hard_thresh_10db = wdencmp('gbl', noisy_img_10db, 'sym4', 2, thr1, sorh1, keepapp1);
psnr_hard_10db = psnr(hard_thresh_10db, gray_img);

[thr2, sorh2, keepapp2] = ddencmp('den', 'wp', noisy_img_15db);
hard_thresh_15db = wdencmp('gbl', noisy_img_15db, 'sym4', 2, thr2, sorh2, keepapp2);
psnr_hard_15db = psnr(hard_thresh_15db, gray_img);

[thr3, sorh3, keepapp3] = ddencmp('den', 'wp', noisy_img_20db);
hard_thresh_20db = wdencmp('gbl', noisy_img_20db, 'sym4', 2, thr3, sorh3, keepapp3);
psnr_hard_20db = psnr(hard_thresh_20db, gray_img);

% Display results for hard thresholding
figure;
subplot(2, 3, 1); imshow(noisy_img_10db); title(['Noisy (10 dB, PSNR: ', num2str(psnr_10db), ')']);
subplot(2, 3, 4); imshow(hard_thresh_10db); title(['Hard Thresh (PSNR: ', num2str(psnr_hard_10db), ')']);

subplot(2, 3, 2); imshow(noisy_img_15db); title(['Noisy (15 dB, PSNR: ', num2str(psnr_15db), ')']);
subplot(2, 3, 5); imshow(hard_thresh_15db); title(['Hard Thresh (PSNR: ', num2str(psnr_hard_15db), ')']);

subplot(2, 3, 3); imshow(noisy_img_20db); title(['Noisy (20 dB, PSNR: ', num2str(psnr_20db), ')']);
subplot(2, 3, 6); imshow(hard_thresh_20db); title(['Hard Thresh (PSNR: ', num2str(psnr_hard_20db), ')']);

sgtitle('Wavelet Denoising with Hard Thresholding');