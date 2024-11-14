%%
% Homework Solution - HW1
% Mohammad Sadegh Kalami Yazdi
% Student ID: 402811068
close all; clear; clc

%% 1 - JPEG Compression with DCT and Quantization

original_image = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\lena_color_orig.png'); 
gray_image = rgb2gray(original_image);  
gray_image = im2double(gray_image);

% Define block size and pad image for divisibility
block_dim = 8;
[image_rows, image_cols] = size(gray_image);
padded_rows = ceil(image_rows / block_dim) * block_dim;  
padded_cols = ceil(image_cols / block_dim) * block_dim;  
padded_image = padarray(gray_image, [padded_rows - image_rows, padded_cols - image_cols], 'post');

% Divide into 8x8 blocks and apply DCT
image_blocks = mat2cell(padded_image, repmat(block_dim, 1, padded_rows/block_dim), repmat(block_dim, 1, padded_cols/block_dim));
dct_coeff_blocks = cell(size(image_blocks));  
for k = 1:numel(image_blocks)
    dct_coeff_blocks{k} = dct2(image_blocks{k});
end

% Quantize DCT coefficients
quantization_level = 10;  
quantized_dct_blocks = cell(size(dct_coeff_blocks));  
for k = 1:numel(dct_coeff_blocks)
    quantized_dct_blocks{k} = round(dct_coeff_blocks{k} / quantization_level) * quantization_level; 
end

% Inverse DCT for reconstruction
reconstructed_blocks = cell(size(quantized_dct_blocks));  
for k = 1:numel(quantized_dct_blocks)
    reconstructed_blocks{k} = idct2(quantized_dct_blocks{k}); 
end

% Combine blocks into full image and crop to original size
compressed_image = cell2mat(reconstructed_blocks);  
compressed_image = compressed_image(1:image_rows, 1:image_cols);

% Display results
figure;
subplot(1, 2, 1);
imshow(gray_image, []);
title('Original Grayscale Image (Lena 512)');

subplot(1, 2, 2);
imshow(compressed_image, []);
title('Reconstructed Image after Basic JPEG Compression');
%% 2 - JPEG Compression with FFT and Quantization

original_image = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\lena_color_orig.png'); 
gray_image = rgb2gray(original_image);  
gray_image = im2double(gray_image);

% Define block size and pad image for divisibility
block_dim = 8;
[image_rows, image_cols] = size(gray_image);
padded_rows = ceil(image_rows / block_dim) * block_dim;  
padded_cols = ceil(image_cols / block_dim) * block_dim;  
padded_image = padarray(gray_image, [padded_rows - image_rows, padded_cols - image_cols], 'post');

% Divide into 8x8 blocks and apply FFT
image_blocks = mat2cell(padded_image, repmat(block_dim, 1, padded_rows/block_dim), repmat(block_dim, 1, padded_cols/block_dim));
fft_coeff_blocks = cell(size(image_blocks));  
for k = 1:numel(image_blocks)
    fft_coeff_blocks{k} = fft2(image_blocks{k});
end

% Quantize FFT coefficients
quantization_level = 10;  
quantized_fft_blocks = cell(size(fft_coeff_blocks));  
for k = 1:numel(fft_coeff_blocks)
    quantized_fft_blocks{k} = round(fft_coeff_blocks{k} / quantization_level) * quantization_level; 
end

% Inverse FFT for reconstruction
reconstructed_blocks = cell(size(quantized_fft_blocks));  
for k = 1:numel(quantized_fft_blocks)
    reconstructed_blocks{k} = ifft2(quantized_fft_blocks{k}, 'symmetric'); 
end

% Combine blocks into full image and crop to original size
compressed_image_fft = cell2mat(reconstructed_blocks);  
compressed_image_fft = compressed_image_fft(1:image_rows, 1:image_cols);

figure;
subplot(1, 2, 1);
imshow(gray_image, []);
title('Original Grayscale Image (Lena 512)');

subplot(1, 2, 2);
imshow(compressed_image_fft, []);
title('Reconstructed Image using FFT-based Compression');
% Calculate PSNR and SSIM for quality assessment
psnr_value = psnr(compressed_image_fft, gray_image);
ssim_value = ssim(compressed_image_fft, gray_image);

fprintf('PSNR (FFT Compression): %.4f dB\n', psnr_value);
fprintf('SSIM (FFT Compression): %.4f\n', ssim_value);
%% 3 - Direct Quantization JPEG Compression

original_image = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\lena_color_orig.png');
gray_image = rgb2gray(original_image);
gray_image = im2double(gray_image);

% Define block size and pad the image to ensure divisibility by 8
block_size = 8;
[rows, cols] = size(gray_image);
padded_rows = ceil(rows / block_size) * block_size;
padded_cols = ceil(cols / block_size) * block_size;
padded_image = padarray(gray_image, [padded_rows - rows, padded_cols - cols], 'post');

% Divide the padded image into 8x8 blocks
blocks = mat2cell(padded_image, repmat(block_size, 1, padded_rows / block_size), repmat(block_size, 1, padded_cols / block_size));

% Apply direct quantization on each block without DCT or FFT
quantization_level = 10;  % Quantization level
quantized_blocks = cell(size(blocks));
for i = 1:numel(blocks)
    quantized_blocks{i} = round(blocks{i} * quantization_level) / quantization_level;  % Apply quantization
end

% Reconstruct the image from the quantized blocks
reconstructed_image = cell2mat(quantized_blocks);

reconstructed_image = reconstructed_image(1:rows, 1:cols);

figure;
subplot(1, 2, 1);
imshow(gray_image, []);
title('Original Grayscale Image (Lena 512)');

subplot(1, 2, 2);
imshow(reconstructed_image, []);
title('Reconstructed Image using Direct Quantization');

% Calculate PSNR and SSIM for quality assessment
psnr_value = psnr(reconstructed_image, gray_image);
ssim_value = ssim(reconstructed_image, gray_image);

fprintf('PSNR: %.2f dB\n', psnr_value);
fprintf('SSIM: %.2f\n', ssim_value);
%% 4- Color Compression with Enhanced Chrominance Reduction

source_img = im2double(imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\lena_color_orig.png'));
ycbcr_img = rgb2ycbcr(source_img);

% Separate channels
lum_channel = ycbcr_img(:, :, 1);
chrom_cb = ycbcr_img(:, :, 2);
chrom_cr = ycbcr_img(:, :, 3);

% Compression factors
lum_factor = 10;
chrom_factor = 5;

% Quantize channels
quant_lum = round(lum_channel * lum_factor) / lum_factor;
quant_cb = round(chrom_cb * chrom_factor) / chrom_factor;
quant_cr = round(chrom_cr * chrom_factor) / chrom_factor;

% Reconstruct YCbCr and convert back to RGB
ycbcr_reconstructed = cat(3, quant_lum, quant_cb, quant_cr);
rgb_reconstructed = ycbcr2rgb(ycbcr_reconstructed);

% Display images
figure;
subplot(1, 2, 1);
imshow(source_img);
title('Original Image');

subplot(1, 2, 2);
imshow(rgb_reconstructed);
title('Reconstructed with Standard Compression');

% Adjust chrominance compression
lum_fixed = 10;
chrom_increased = 3;

% Requantize with increased chrominance compression
quant_cb_increased = round(chrom_cb * chrom_increased) / chrom_increased;
quant_cr_increased = round(chrom_cr * chrom_increased) / chrom_increased;

% Reconstruct with increased chrominance compression
ycbcr_reconstructed_inc = cat(3, quant_lum, quant_cb_increased, quant_cr_increased);
rgb_reconstructed_inc = ycbcr2rgb(ycbcr_reconstructed_inc);

figure;
subplot(1, 2, 1);
imshow(rgb_reconstructed);
title('Standard Compression');

subplot(1, 2, 2);
imshow(rgb_reconstructed_inc);
title('Enhanced Chrominance Compression');

psnr_metric = psnr(rgb_reconstructed_inc, source_img);
ssim_metric = ssim(rgb_reconstructed_inc, source_img);

fprintf('PSNR with enhanced chrominance compression: %.4f dB\n', psnr_metric);
fprintf('SSIM with enhanced chrominance compression: %.4f\n', ssim_metric);
