clear;close all;clc

MRI_data = imread('..\..\..\chest-ct-scan.jpg');
gray_data = im2double(rgb2gray(MRI_data));

noisy_10db = awgn(gray_data,10);
noisy_15db = awgn(gray_data,15);
noisy_20db = awgn(gray_data,20);

psnr_noisy_10db = psnr(noisy_10db,gray_data);
psnr_noisy_15db = psnr(noisy_15db,gray_data);
psnr_noisy_20db = psnr(noisy_20db,gray_data);

NLM_filtered_10db = imnlmfilt(noisy_10db);
psnr_NLM_10db = psnr(NLM_filtered_10db, gray_data);

NLM_filtered_15db = imnlmfilt(noisy_15db);
psnr_NLM_15db = psnr(NLM_filtered_15db, gray_data);

NLM_filtered_20db = imnlmfilt(noisy_20db, "ComparisonWindowSize",3,"SearchWindowSize", 9);
psnr_NLM_20db = psnr(NLM_filtered_20db, gray_data);

figure;
subplot(3,3,1); imshow(gray_data); title('Original');
subplot(3,3,2); imshow(noisy_10db); title(['Noisy PSNR=',num2str(psnr_noisy_10db)]);
subplot(3,3,3); imshow(NLM_filtered_10db); title(['Filtered PSNR=',num2str(psnr_NLM_10db)]);

subplot(3,3,4); imshow(gray_data); title('Original');
subplot(3,3,5); imshow(noisy_15db); title(['Noisy PSNR=',num2str(psnr_noisy_15db)]);
subplot(3,3,6); imshow(NLM_filtered_15db); title(['Filtered PSNR=',num2str(psnr_NLM_15db)]);

subplot(3,3,7); imshow(gray_data); title('Original');
subplot(3,3,8); imshow(noisy_20db); title(['Noisy PSNR=',num2str(psnr_noisy_20db)]);
subplot(3,3,9); imshow(NLM_filtered_20db); title(['Filtered PSNR=',num2str(psnr_NLM_20db)]);
