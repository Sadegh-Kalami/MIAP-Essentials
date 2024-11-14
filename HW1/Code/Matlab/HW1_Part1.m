%%
% Homework Solution - HW1
% Mohammad Sadegh Kalami Yazdi
% Student ID: 402811068
%% Section 1: Loading and Displaying the Noisy Image

imagePath = 'D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\Noisy.jpg';

Noisy = imread(imagePath);
Noisy_double = im2double(Noisy);

% Display the image in a new figure window.
figure;
imshow(Noisy_double, []);
title('Noisy Image');

% Adding labels to make the display clear and visually complete.
xlabel('Pixels');
ylabel('Pixels');

% Grayscale color helps emphasize intensity details, and the colorbar shows the range of pixel values.
colormap(gray);
colorbar;
%% Section 2: Applying a Median Filter to Reduce Noise

% Here, we apply a 3x3 median filter to the noisy image.
% This filter helps reduce the noise by replacing each pixel’s value with the median value in its 3x3 neighborhood.
Filtered_image = medfilt2(Noisy_double, [3 3]);

figure;
imshow(Filtered_image, []);
title('Image After Noise Reduction Using 3x3 Median Filter');

%% Section 3: Displaying Images at True Size

Filtered_image_twice = medfilt2(Filtered_image, [3 3]);

figure;

% Display the original noisy image in its actual size
subplot(1, 3, 1);
imshow(Noisy_double, 'InitialMagnification', 100);
title('Original Noisy Image');

% Display the first filtered image in its actual size
subplot(1, 3, 2);
imshow(Filtered_image, 'InitialMagnification', 100);
title('After First Pass of 3x3 Median Filter');

% Display the second filtered image in its actual size
subplot(1, 3, 3);
imshow(Filtered_image_twice, 'InitialMagnification', 100);
title('After Second Pass of 3x3 Median Filter');

set(gcf, 'Position', [100, 100, 1500, 500]); % Adjust figure size for the images
%% Section 4: PSNR Calculation Between Noise-Free and Noisy Images

free_Noise = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\Noise-free.jpg'); 
Noisy = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\Noisy.jpg'); 

free_Noise_double = im2double(free_Noise);
Noisy_double = im2double(Noisy);

% Calculate the Mean Squared Error (MSE) between the noise-free and noisy images.
MSE = mean((free_Noise_double - Noisy_double).^2, 'all');

% Calculate the Peak Signal-to-Noise Ratio (PSNR) based on the MSE.
% If the MSE is zero (images are identical), the PSNR is set to infinity.
if MSE == 0
    PSNR_value = Inf;
else
    MAX_pixel_value = max(free_Noise_double(:)); % Max pixel intensity in noise-free image
    PSNR_value = 10 * log10((MAX_pixel_value^2) / MSE);
end

fprintf('Computed PSNR for the noise-free and noisy images: %.2f dB\n', PSNR_value);




