clc; clear; close all

% Load and preprocess image
input_img = im2double(rgb2gray(imread('..\..\chest-ct-scan.jpg')));

% Add Gaussian noise at different levels
noisy_img_10db = awgn(input_img, 10);
noisy_img_15db = awgn(input_img, 15);
noisy_img_20db = awgn(input_img, 20);

% Compute PSNR for noisy images
psnr_10db = psnr(noisy_img_10db, input_img);
psnr_15db = psnr(noisy_img_15db, input_img);
psnr_20db = psnr(noisy_img_20db, input_img);

% Display original and noisy images
figure;
subplot(1, 3, 1); imshow(noisy_img_10db); title(['Noisy Image (10 dB, PSNR: ', num2str(psnr_10db), ')']);
subplot(1, 3, 2); imshow(noisy_img_15db); title(['Noisy Image (15 dB, PSNR: ', num2str(psnr_15db), ')']);
subplot(1, 3, 3); imshow(noisy_img_20db); title(['Noisy Image (20 dB, PSNR: ', num2str(psnr_20db), ')']);

% Wiener filtering process for 10 dB
org_img_fft = fft2(input_img);
noisy_img_fft_10db = fft2(noisy_img_10db);
Noise = noisy_img_fft_10db - org_img_fft;
PFF = (abs(org_img_fft).^2);
PNN = (abs(Noise).^2);
W = PFF ./ (PFF + PNN);

for i = 1:200
    W = PFF ./ (PFF + PNN);
    F_hat = W .* noisy_img_fft_10db;
    PFF = (abs(F_hat).^2);
end
Wiener_10db = ifft2(W .* noisy_img_fft_10db);
psnr_Wiener_10db = psnr(Wiener_10db, input_img);

% Wiener filtering process for 15 dB
noisy_img_fft_15db = fft2(noisy_img_15db);
Noise = imnoise(noisy_img_15db, 'gaussian', 0, 0.1) - noisy_img_15db;
Noise = fft2(Noise);
PFF = (abs(noisy_img_fft_15db).^2);
PNN = (abs(Noise).^2);

for i = 1:200
    W = PFF ./ (PFF + PNN);
    F_hat = W .* noisy_img_fft_15db;
    PFF = (abs(F_hat).^2);
end
Wiener_15db = ifft2(W .* noisy_img_fft_15db);
psnr_Wiener_15db = psnr(Wiener_15db, input_img);

% Wiener filtering process for 20 dB
noisy_img_fft_20db = fft2(noisy_img_20db);
Noise = imnoise(noisy_img_20db, 'gaussian', 0, 0.01) - noisy_img_20db;
Noise = fft2(Noise);
PFF = (abs(noisy_img_fft_20db).^2);
PNN = (abs(Noise).^2);

for i = 1:200
    W = PFF ./ (PFF + PNN);
    F_hat = W .* noisy_img_fft_20db;
    PFF = (abs(F_hat).^2);
end
Wiener_20db = ifft2(W .* noisy_img_fft_20db);
psnr_Wiener_20db = psnr(Wiener_20db, input_img);

% Display all results in a single figure
figure;

subplot(3, 3, 1); imshow(input_img); title('Original Image');
subplot(3, 3, 2); imshow(noisy_img_10db); title(['Noisy (10 dB, PSNR: ', num2str(psnr_10db), ')']);
subplot(3, 3, 3); imshow(Wiener_10db); title(['Filtered (PSNR: ', num2str(psnr_Wiener_10db), ')']);

subplot(3, 3, 4); imshow(input_img); title('Original Image');
subplot(3, 3, 5); imshow(noisy_img_15db); title(['Noisy (15 dB, PSNR: ', num2str(psnr_15db), ')']);
subplot(3, 3, 6); imshow(Wiener_15db); title(['Filtered (PSNR: ', num2str(psnr_Wiener_15db), ')']);

subplot(3, 3, 7); imshow(input_img); title('Original Image');
subplot(3, 3, 8); imshow(noisy_img_20db); title(['Noisy (20 dB, PSNR: ', num2str(psnr_20db), ')']);
subplot(3, 3, 9); imshow(Wiener_20db); title(['Filtered (PSNR: ', num2str(psnr_Wiener_20db), ')']);

sgtitle('Wiener Filtering at Different Noise Levels');
