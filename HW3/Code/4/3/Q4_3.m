clear; close all; clc

image_data = im2double(rgb2gray(imread('..\..\..\chest-ct-scan.jpg')));

noisy_10db = awgn(image_data, 10);
noisy_15db = awgn(image_data, 15);
noisy_20db = awgn(image_data, 20);

psnr_10db = psnr(noisy_10db, image_data);
psnr_15db = psnr(noisy_15db, image_data);
psnr_20db = psnr(noisy_20db, image_data);

noisy_10db_resized = imresize(noisy_10db, [256 256]);
size_original = size(image_data);

lambda_10 = 3;
iterations_10 = 30;
alpha_10 = 0.245;
tv_10db = TV_Chambolle(zeros(256), zeros(256), noisy_10db_resized, lambda_10, alpha_10, iterations_10, 1e-2, 0);
tv_10db_resized = imresize(tv_10db, size_original);
psnr_tv_10db = psnr(tv_10db_resized, image_data);

noisy_15db_resized = imresize(noisy_15db, [256 256]);

lambda_15 = 6.5;
iterations_15 = 30;
alpha_15 = 0.24;
tv_15db = TV_Chambolle(zeros(256), zeros(256), noisy_15db_resized, lambda_15, alpha_15, iterations_15, 1e-2, 0);
tv_15db_resized = imresize(tv_15db, size_original);
psnr_tv_15db = psnr(tv_15db_resized, image_data);

noisy_20db_resized = imresize(noisy_20db, [256 256]);

lambda_20 = 17.5;
iterations_20 = 30;
alpha_20 = 0.248;
tv_20db = TV_Chambolle(zeros(256), zeros(256), noisy_20db_resized, lambda_20, alpha_20, iterations_20, 1e-2, 0);
tv_20db_resized = imresize(tv_20db, size_original);
psnr_tv_20db = psnr(tv_20db_resized, image_data);

figure;
subplot(3, 3, 1); imshow(image_data); title('Original');
subplot(3, 3, 2); imshow(noisy_10db); title(['Noisy (PSNR: ', num2str(psnr_10db), ')']);
subplot(3, 3, 3); imshow(tv_10db_resized); title(['TV (PSNR: ', num2str(psnr_tv_10db), ')']);

subplot(3, 3, 4); imshow(image_data); title('Original');
subplot(3, 3, 5); imshow(noisy_15db); title(['Noisy (PSNR: ', num2str(psnr_15db), ')']);
subplot(3, 3, 6); imshow(tv_15db_resized); title(['TV (PSNR: ', num2str(psnr_tv_15db), ')']);

subplot(3, 3, 7); imshow(image_data); title('Original');
subplot(3, 3, 8); imshow(noisy_20db); title(['Noisy (PSNR: ', num2str(psnr_20db), ')']);
subplot(3, 3, 9); imshow(tv_20db_resized); title(['TV (PSNR: ', num2str(psnr_tv_20db), ')']);