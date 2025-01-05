clc; clear; close all;

% Load and preprocess image
image = im2double(rgb2gray(imread('..\..\chest-ct-scan.jpg')));

% Add noise with varying PSNR levels
image_10db = awgn(image, 10);
image_15db = awgn(image, 15);
image_20db = awgn(image, 20);

% Compute PSNR for noisy images
psnr_10db = psnr(image_10db, image);
psnr_15db = psnr(image_15db, image);
psnr_20db = psnr(image_20db, image);

% Display original and noisy images
figure;
subplot(1, 3, 1); imshow(image_10db); title(['Noisy (PSNR: ', num2str(psnr_10db), ')']);
subplot(1, 3, 2); imshow(image_15db); title(['Noisy (PSNR: ', num2str(psnr_15db), ')']);
subplot(1, 3, 3); imshow(image_20db); title(['Noisy (PSNR: ', num2str(psnr_20db), ')']);

% Wiener filtering for 10 dB
fft_original = fft2(image);
fft_noisy_10db = fft2(image_10db);
noise_fft_10db = fft_noisy_10db - fft_original;
signal_power = abs(fft_original).^2;
noise_power = abs(noise_fft_10db).^2;
filter_10db = signal_power ./ (signal_power + noise_power);
wiener_10db = ifft2(filter_10db .* fft_noisy_10db);
psnr_wiener_10db = psnr(wiener_10db, image);

% Wiener filtering for 15 dB
fft_noisy_15db = fft2(image_15db);
noise_fft_15db = fft_noisy_15db - fft_original;
filter_15db = signal_power ./ (signal_power + noise_power);
wiener_15db = ifft2(filter_15db .* fft_noisy_15db);
psnr_wiener_15db = psnr(wiener_15db, image);

% Wiener filtering for 20 dB
fft_noisy_20db = fft2(image_20db);
noise_fft_20db = fft_noisy_20db - fft_original;
filter_20db = signal_power ./ (signal_power + noise_power);
wiener_20db = ifft2(filter_20db .* fft_noisy_20db);
psnr_wiener_20db = psnr(wiener_20db, image);

% Display original, noisy, and filtered images in a single figure
figure;

subplot(3, 3, 1); imshow(image); title('Original');
subplot(3, 3, 2); imshow(image_10db); title(['Noisy (10 dB)']);
subplot(3, 3, 3); imshow(wiener_10db); title(['Filtered (PSNR: ', num2str(psnr_wiener_10db), ')']);

subplot(3, 3, 4); imshow(image); title('Original');
subplot(3, 3, 5); imshow(image_15db); title(['Noisy (15 dB)']);
subplot(3, 3, 6); imshow(wiener_15db); title(['Filtered (PSNR: ', num2str(psnr_wiener_15db), ')']);

subplot(3, 3, 7); imshow(image); title('Original');
subplot(3, 3, 8); imshow(image_20db); title(['Noisy (20 dB)']);
subplot(3, 3, 9); imshow(wiener_20db); title(['Filtered (PSNR: ', num2str(psnr_wiener_20db), ')']);

sgtitle('Wiener Filtering: Noise Reduction Across PSNR Levels');
