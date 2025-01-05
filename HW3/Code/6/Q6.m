clear;close all;clc

MRI_data = imread('..\..\chest-ct-scan.jpg');
gray_data = im2double(rgb2gray(MRI_data));

noisy_10db = awgn(gray_data,10);
noisy_15db = awgn(gray_data,15);
noisy_20db = awgn(gray_data,20);

psnr_noisy_10db = psnr(noisy_10db,gray_data);
psnr_noisy_15db = psnr(noisy_15db,gray_data);
psnr_noisy_20db = psnr(noisy_20db,gray_data);

filtered_5x5_10db = medfilt2(noisy_10db, [5 5]);
filtered_5x5_15db = medfilt2(noisy_15db, [5 5]);
filtered_5x5_20db = medfilt2(noisy_20db, [5 5]);

psnr_median_10db = psnr(filtered_5x5_10db, gray_data);
psnr_median_15db = psnr(filtered_5x5_15db, gray_data);
psnr_median_20db = psnr(filtered_5x5_20db, gray_data);

smoothed_10db = conv2(noisy_10db, fspecial('average', [5 5]), 'same');
smoothed_15db = conv2(noisy_15db, fspecial('average', [5 5]), 'same');
smoothed_20db = conv2(noisy_20db, fspecial('average', [5 5]), 'same');

psnr_avg_10db = psnr(smoothed_10db, gray_data);
psnr_avg_15db = psnr(smoothed_15db, gray_data);
psnr_avg_20db = psnr(smoothed_20db, gray_data);

figure;
subplot(3,4,1); imshow(gray_data); title('Original');
subplot(3,4,2); imshow(noisy_10db); title(['Noisy PSNR=',num2str(psnr_noisy_10db)]);
subplot(3,4,3); imshow(filtered_5x5_10db); title(['Median PSNR=',num2str(psnr_median_10db)]);
subplot(3,4,4); imshow(smoothed_10db); title(['Average PSNR=',num2str(psnr_avg_10db)]);

subplot(3,4,5); imshow(gray_data); title('Original');
subplot(3,4,6); imshow(noisy_15db); title(['Noisy PSNR=',num2str(psnr_noisy_15db)]);
subplot(3,4,7); imshow(filtered_5x5_15db); title(['Median PSNR=',num2str(psnr_median_15db)]);
subplot(3,4,8); imshow(smoothed_15db); title(['Average PSNR=',num2str(psnr_avg_15db)]);

subplot(3,4,9); imshow(gray_data); title('Original');
subplot(3,4,10); imshow(noisy_20db); title(['Noisy PSNR=',num2str(psnr_noisy_20db)]);
subplot(3,4,11); imshow(filtered_5x5_20db); title(['Median PSNR=',num2str(psnr_median_20db)]);
subplot(3,4,12); imshow(smoothed_20db); title(['Average PSNR=',num2str(psnr_avg_20db)]);
