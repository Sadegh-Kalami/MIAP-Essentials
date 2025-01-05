clear;close all;clc

MRI_data = imread('..\..\..\chest-ct-scan.jpg');
gray_data = im2double(rgb2gray(MRI_data));

noisy_10db = awgn(gray_data,10);
noisy_15db = awgn(gray_data,15);
noisy_20db = awgn(gray_data,20);

psnr_noisy_10db = psnr(noisy_10db,gray_data);
psnr_noisy_15db = psnr(noisy_15db,gray_data);
psnr_noisy_20db = psnr(noisy_20db,gray_data);

Bilateral_filtered_10db = imbilatfilt(noisy_10db, 'degreeOfSmoothing', 2);
psnr_Bilateral_10db = psnr(Bilateral_filtered_10db, gray_data);

Bilateral_filtered_15db = imbilatfilt(noisy_15db, 'degreeOfSmoothing', 1);
psnr_Bilateral_15db = psnr(Bilateral_filtered_15db, gray_data);

Bilateral_filtered_20db = imbilatfilt(noisy_20db, 'degreeOfSmoothing', 0.1);
psnr_Bilateral_20db = psnr(Bilateral_filtered_20db, gray_data);

figure;
subplot(3,3,1); imshow(gray_data); title('Original');
subplot(3,3,2); imshow(noisy_10db); title(['Noisy PSNR=',num2str(psnr_noisy_10db)]);
subplot(3,3,3); imshow(Bilateral_filtered_10db); title(['Filtered PSNR=',num2str(psnr_Bilateral_10db)]);

subplot(3,3,4); imshow(gray_data); title('Original');
subplot(3,3,5); imshow(noisy_15db); title(['Noisy PSNR=',num2str(psnr_noisy_15db)]);
subplot(3,3,6); imshow(Bilateral_filtered_15db); title(['Filtered PSNR=',num2str(psnr_Bilateral_15db)]);

subplot(3,3,7); imshow(gray_data); title('Original');
subplot(3,3,8); imshow(noisy_20db); title(['Noisy PSNR=',num2str(psnr_noisy_20db)]);
subplot(3,3,9); imshow(Bilateral_filtered_20db); title(['Filtered PSNR=',num2str(psnr_Bilateral_20db)]);
