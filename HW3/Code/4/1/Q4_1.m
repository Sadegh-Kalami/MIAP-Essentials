clear; close all; clc

image_data = im2double(rgb2gray(imread('..\..\..\chest-ct-scan.jpg')));

noisy_10db = awgn(image_data, 10);
noisy_15db = awgn(image_data, 15);
noisy_20db = awgn(image_data, 20);

psnr_10db = psnr(noisy_10db, image_data);
psnr_15db = psnr(noisy_15db, image_data);
psnr_20db = psnr(noisy_20db, image_data);

noise_type = 'g0';
noise_var_10 = 0.1;
noise_var_15 = 0.05;
noise_var_20 = 0.0095;
seed = 0;

[~, PSD_10, ~] = getExperimentNoise(noise_type, noise_var_10, seed, size(noisy_10db));
BM3D_result_10db = BM3D(noisy_10db, PSD_10);
psnr_bm3d_10db = psnr(BM3D_result_10db, image_data);

[~, PSD_15, ~] = getExperimentNoise(noise_type, noise_var_15, seed, size(noisy_15db));
BM3D_result_15db = BM3D(noisy_15db, PSD_15);
psnr_bm3d_15db = psnr(BM3D_result_15db, image_data);

[~, PSD_20, ~] = getExperimentNoise(noise_type, noise_var_20, seed, size(noisy_20db));
BM3D_result_20db = BM3D(noisy_20db, PSD_20);
psnr_bm3d_20db = psnr(BM3D_result_20db, image_data);

figure;
subplot(3, 3, 1); imshow(image_data); title('Original');
subplot(3, 3, 2); imshow(noisy_10db); title(['Noisy (PSNR: ', num2str(psnr_10db), ')']);
subplot(3, 3, 3); imshow(BM3D_result_10db); title(['BM3D (PSNR: ', num2str(psnr_bm3d_10db), ')']);

subplot(3, 3, 4); imshow(image_data); title('Original');
subplot(3, 3, 5); imshow(noisy_15db); title(['Noisy (PSNR: ', num2str(psnr_15db), ')']);
subplot(3, 3, 6); imshow(BM3D_result_15db); title(['BM3D (PSNR: ', num2str(psnr_bm3d_15db), ')']);

subplot(3, 3, 7); imshow(image_data); title('Original');
subplot(3, 3, 8); imshow(noisy_20db); title(['Noisy (PSNR: ', num2str(psnr_20db), ')']);
subplot(3, 3, 9); imshow(BM3D_result_20db); title(['BM3D (PSNR: ', num2str(psnr_bm3d_20db), ')']);
