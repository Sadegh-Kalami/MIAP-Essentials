%%
% Homework Solution - HW1
% Mohammad Sadegh Kalami Yazdi
% Student ID: 402811068
%%
close all; clear;clc
sharp_img = im2double(imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\Phantom.jpg')); 
blur_img = im2double(imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\BluredPhantom.jpg')); 
noisy_blur_img = im2double(imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\NoisyBluredPhantom.jpg'));
if size(sharp_img, 3) == 3
    sharp_img = rgb2gray(sharp_img);
end
if size(blur_img, 3) == 3
    blur_img = rgb2gray(blur_img);
end
if size(noisy_blur_img, 3) == 3
    noisy_blur_img = rgb2gray(noisy_blur_img);
end

if size(sharp_img) ~= size(blur_img)
    blur_img = imresize(blur_img, size(sharp_img));
end
if size(sharp_img) ~= size(noisy_blur_img)
    noisy_blur_img = imresize(noisy_blur_img, size(sharp_img));
end

disp(['Sharp Image Size: ', num2str(size(sharp_img))]);
disp(['Blurred Image Size: ', num2str(size(blur_img))]);
disp(['Noisy Blurred Image Size: ', num2str(size(noisy_blur_img))]);

sharp_img_fft = fft2(sharp_img);
blur_img_fft = fft2(blur_img);
noisy_blur_img_fft = fft2(noisy_blur_img);

figure
subplot(1, 3, 1);
imshow(sharp_img)
title('Sharp Image')

subplot(1, 3, 2);
imshow(blur_img)
title('Blurred Image')

subplot(1, 3, 3)
imshow(noisy_blur_img)
title('Noisy Blurred Image')

%% Section 1
% Estimate degradation function in frequency domain
epsilon = 1e-10;  % Small constant to avoid division by zero
degradation_func = blur_img_fft ./ (sharp_img_fft + epsilon);  
psf_spatial = otf2psf(degradation_func);  % Convert to spatial domain (PSF)

% Display FFT and degradation function results
figure;
subplot(2,3,1);
imshow(log(abs(fftshift(sharp_img_fft))), []);
title('Fourier Transform of Sharp Image');

subplot(2,3,2);
imshow(log(abs(fftshift(degradation_func))), []);
title('Estimated Degradation Function (Frequency Domain)');

subplot(2,3,3);
imshow(log(abs(fftshift(blur_img_fft))), []);
title('Fourier Transform of Blurred Image');

subplot(2,3,[4 6]);
surf(psf_spatial(1:31, 1:31));  % Display PSF (31x31 region)
shading interp;
title('Spatial Domain 31x31');

%% Section 2
% Estimate degradation function for noise and blur
degradation_func_noisy = noisy_blur_img_fft ./ sharp_img_fft;
psf_noisy = otf2psf(degradation_func_noisy);

% Display results in frequency and spatial domains
figure
subplot(2,3,1);
imshow(log(abs(fftshift(sharp_img_fft))), []);
title('FFT of Sharp Image');

subplot(2,3,2);
imshow(log(abs(fftshift(degradation_func_noisy))), []);
title('Degradation Function (Frequency Domain)');

subplot(2,3,3);
imshow(log(abs(fftshift(noisy_blur_img_fft))), []);
title('FFT of Noisy Blurred Image');

subplot(2,3,[4 6]);
surf(psf_noisy(1:31, 1:31));  
title('Degradation Function (Spatial Domain 31x31)');

%% Section 3
% Apply inverse filter
restored_img_inverse = noisy_blur_img_fft ./ degradation_func_noisy;
restored_spatial_inverse = ifft2(restored_img_inverse);

% Apply Wiener filter
PNN = 0.1; 
inverse_SNR = PNN / mean(abs(sharp_img_fft(:)).^2);
wiener_filter = (1 ./ degradation_func_noisy) .* (abs(degradation_func_noisy).^2 ./ (abs(degradation_func_noisy).^2 + inverse_SNR));
restored_img_wiener = wiener_filter .* noisy_blur_img_fft;
restored_spatial_wiener = ifft2(restored_img_wiener);

% Display results of inverse filtering and Wiener filtering
figure; 
subplot(2,2,1)
imshow(noisy_blur_img)
title('Noisy Blurred Image')

subplot(2,2,2)
imshow(sharp_img)
title('Original Image')

subplot(2,2,3)
imshow(restored_spatial_inverse)
title('Restored Image (Inverse Filter)')

subplot(2,2,4)
imshow(restored_spatial_wiener)
title('Restored Image (Wiener Filter)')

%% Section 4
% Apply inverse filter
restored_img_inverse2 = noisy_blur_img_fft ./ degradation_func_noisy;
restored_spatial_inverse2 = ifft2(restored_img_inverse2);

% Apply Wiener filtering with iterative updates
PNN = 0.1; 
PGG = mean(abs(noisy_blur_img_fft(:)).^2);
PFF = PGG;

% Wiener filter iteration
for i = 1:100
    wiener_iter = (1 ./ degradation_func_noisy) .* ((abs(degradation_func_noisy).^2) ./ (abs(degradation_func_noisy).^2 + (PNN / PFF)));
    restored_img_wiener_iter = wiener_iter .* noisy_blur_img_fft;
    PFF = mean(abs(restored_img_wiener_iter(:)).^2);
end

% Final restored image using Wiener filter
restored_spatial_wiener_iter = ifft2(restored_img_wiener_iter);

% Display results
figure;
subplot(2,2,1)
imshow(noisy_blur_img)
title('Noisy Blurred Image');

subplot(2,2,2)
imshow(sharp_img)
title('Original Image');

subplot(2,2,3)
imshow(restored_spatial_inverse2)
title('Restored Image (Inverse Filter)');

subplot(2,2,4)
imshow(restored_spatial_wiener_iter)
title('Restored Image (Iterative Wiener Filter)');

%% Section 5
% Blind deconvolution (deconvblind method)
psf_noisy = otf2psf(degradation_func_noisy);
restored_img_deconvblind = deconvblind(noisy_blur_img, ones(size(psf_noisy)), 5, 20);

% Display results of deconvblind method
figure;
subplot(3,2,1)
imshow(noisy_blur_img)
title('Noisy Blurred Image');

subplot(3,2,2)
imshow(sharp_img)
title('Original Image');

subplot(3,2,3)
imshow(restored_img_deconvblind)
title('Restoration via Deconvblind');

% Apply deconvlucy method
restored_img_deconvlucy = deconvlucy(noisy_blur_img, psf_noisy, 7, 50);
subplot(3,2,4)
imshow(restored_img_deconvlucy)
title('Restoration via Deconvlucy');

% Apply deconvreg method
restored_img_deconvreg = deconvreg(noisy_blur_img, psf_noisy, 1);
subplot(3,2,5)
imshow(restored_img_deconvreg)
title('Restoration via Deconvreg');

% Apply deconvwnr method
snr = 0.001 / var(noisy_blur_img(:));
restored_img_deconvwnr = deconvwnr(noisy_blur_img, psf_noisy, snr);
subplot(3,2,6)
imshow(restored_img_deconvwnr)
title('Restoration via Deconvwnr');

%% Section 6.1
% Define Gaussian blur kernel
gaussian_kernel = fspecial('gaussian', [5, 5], 1);  % Example: 5x5 Gaussian kernel with sigma=1
[img_rows, img_cols] = size(noisy_blur_img);        % Dimensions of noisy image

% Pad blur kernel to image size
padded_kernel = padarray(gaussian_kernel, [img_rows - size(gaussian_kernel, 1), img_cols - size(gaussian_kernel, 2)], 'post');

% Fourier transforms of image and kernel
img_fft = fft2(noisy_blur_img);                    % FFT of noisy blurred image
kernel_fft = fft2(padded_kernel);                  % FFT of blur kernel

% Signal-to-noise ratio (SNR)
SNR = 0.1;  % Adjust SNR based on data
kernel_conj = conj(kernel_fft);                    % Conjugate of kernel FFT

% Wiener filter
wiener_filter = kernel_conj ./ (abs(kernel_fft).^2 + (1 / SNR));
restored_fft_wiener = wiener_filter .* img_fft;    % Apply Wiener filter
restored_img_wiener = ifft2(restored_fft_wiener);  % Inverse FFT for spatial domain restoration

% Display results
figure;
subplot(1, 3, 1);
imshow(abs(noisy_blur_img), []);
title('Noisy Blurred Image');

subplot(1, 3, 2);
imshow(abs(restored_img_wiener), []);
title('Restored Image (Wiener Filter)');

subplot(1, 3, 3);
imshow(log(abs(fftshift(wiener_filter))), []);
title('Wiener Filter in Frequency Domain');

%% Section 6.2
% Define Gaussian blur kernel
gaussian_kernel = fspecial('gaussian', [5, 5], 1);  % Example: 5x5 Gaussian kernel with sigma=1
[img_rows, img_cols] = size(noisy_blur_img);        % Dimensions of noisy image

% Pad blur kernel to image size
padded_kernel = padarray(gaussian_kernel, [img_rows - size(gaussian_kernel, 1), img_cols - size(gaussian_kernel, 2)], 'post');

% Fourier transforms of image and kernel
img_fft = fft2(noisy_blur_img);                    % FFT of noisy blurred image
kernel_fft = fft2(padded_kernel);                  % FFT of blur kernel

% Regularization parameter for Tikhonov regularization
lambda = 0.01;
epsilon = 1e-10;  % Small constant to avoid division by zero

% Tikhonov regularization in frequency domain
restored_fft_tikhonov = (conj(kernel_fft) ./ (abs(kernel_fft).^2 + lambda + epsilon)) .* img_fft;
restored_img_tikhonov = ifft2(restored_fft_tikhonov);  % Inverse FFT for spatial domain restoration

% Display results
figure;
subplot(1, 3, 1);
imshow(abs(noisy_blur_img), []);
title('Noisy Blurred Image');

subplot(1, 3, 2);
imshow(abs(restored_img_tikhonov), []);
title('Restored Image (Tikhonov Regularization)');

subplot(1, 3, 3);
imshow(log(abs(fftshift(conj(kernel_fft) ./ (abs(kernel_fft).^2 + lambda)))), []);
title('Regularization Term in Frequency Domain');

%% Section 6.3
gaussian_kernel = fspecial('gaussian', [5, 5], 1);  % Example: 5x5 Gaussian kernel with sigma=1
[img_rows, img_cols] = size(noisy_blur_img);        % Dimensions of noisy image

% Pad blur kernel to image size
padded_kernel = padarray(gaussian_kernel, [img_rows - size(gaussian_kernel, 1), img_cols - size(gaussian_kernel, 2)], 'post');

% Fourier transforms of image and kernel
img_fft = fft2(noisy_blur_img);                    % FFT of noisy blurred image
kernel_fft = fft2(padded_kernel);                  % FFT of blur kernel

% SNR for Wiener filter
SNR = 0.1;  % Adjust based on data
kernel_conj = conj(kernel_fft);  % Conjugate of kernel FFT

% Wiener filter in frequency domain
wiener_filter = kernel_conj ./ (abs(kernel_fft).^2 + (1 / SNR));
restored_fft_wiener = wiener_filter .* img_fft;
restored_img_wiener = ifft2(restored_fft_wiener);

% Display results
figure;
subplot(1, 2, 1);
imshow(abs(noisy_blur_img), []);
title('Noisy Blurred Image');

subplot(1, 2, 2);
imshow(abs(restored_img_wiener), []);
title('Restored Image (Wiener Filter)');

% Tikhonov regularization in frequency domain
lambda = 0.01;
restored_fft_tikhonov = (conj(kernel_fft) ./ (abs(kernel_fft).^2 + lambda)) .* img_fft;
restored_img_tikhonov = ifft2(restored_fft_tikhonov);

% Display results
figure;
subplot(1, 2, 1);
imshow(abs(noisy_blur_img), []);
title('Noisy Blurred Image');

subplot(1, 2, 2);
imshow(abs(restored_img_tikhonov), []);
title('Restored Image (Tikhonov Regularization)');

% Compute PSNR and SSIM for Wiener and Tikhonov filters
psnr_wiener = psnr(restored_img_wiener, sharp_img);
psnr_tikhonov = psnr(restored_img_tikhonov, sharp_img);
ssim_wiener = ssim(restored_img_wiener, sharp_img);
ssim_tikhonov = ssim(restored_img_tikhonov, sharp_img);

% Display PSNR and SSIM values
fprintf('PSNR (Wiener Filter): %.4f dB\n', psnr_wiener);
fprintf('PSNR (Tikhonov Regularization): %.4f dB\n', psnr_tikhonov);
fprintf('SSIM (Wiener Filter): %.4f\n', ssim_wiener);
fprintf('SSIM (Tikhonov Regularization): %.4f\n', ssim_tikhonov);

