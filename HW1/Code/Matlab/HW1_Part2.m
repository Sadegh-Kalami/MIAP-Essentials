%%
% Homework Solution - HW1
% Mohammad Sadegh Kalami Yazdi
% Student ID: 402811068
%% Section 1: Adding Noise to an Image and Viewing the Results

I = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img2.jpg');

I_gray = rgb2gray(I);

% Add some "Gaussian noise" with two different amounts (variances)
noisy_gaussian_01 = imnoise(I_gray, 'gaussian', 0, 0.01); % Small amount of noise
noisy_gaussian_02 = imnoise(I_gray, 'gaussian', 0, 0.02); % A bit more noise

% Add some "salt & pepper noise" with two different amounts (densities)
noisy_saltpepper_01 = imnoise(I_gray, 'salt & pepper', 0.01); % Small amount of salt & pepper noise
noisy_saltpepper_02 = imnoise(I_gray, 'salt & pepper', 0.05); % More salt & pepper noise

figure;
subplot(2,3,1), imshow(I_gray), title('Original Image');
subplot(2,3,2), imshow(noisy_gaussian_01), title('Gaussian Noise, Variance = 0.01');
subplot(2,3,3), imshow(noisy_gaussian_02), title('Gaussian Noise, Variance = 0.02');
subplot(2,3,4), imshow(noisy_saltpepper_01), title('Salt & Pepper Noise, Density = 0.01');
subplot(2,3,5), imshow(noisy_saltpepper_02), title('Salt & Pepper Noise, Density = 0.05');
%% Section 2: Applying Median Filter with Different Window Sizes

% Apply a 3x3 median filter to each noisy image.
filtered_gaussian_3x3_01 = medfilt2(noisy_gaussian_01, [3 3]);
filtered_gaussian_3x3_02 = medfilt2(noisy_gaussian_02, [3 3]);
filtered_saltpepper_3x3_01 = medfilt2(noisy_saltpepper_01, [3 3]);
filtered_saltpepper_3x3_02 = medfilt2(noisy_saltpepper_02, [3 3]);

% Apply a 5x5 median filter to each noisy image.
filtered_gaussian_5x5_01 = medfilt2(noisy_gaussian_01, [5 5]);
filtered_gaussian_5x5_02 = medfilt2(noisy_gaussian_02, [5 5]);
filtered_saltpepper_5x5_01 = medfilt2(noisy_saltpepper_01, [5 5]);
filtered_saltpepper_5x5_02 = medfilt2(noisy_saltpepper_02, [5 5]);

figure;

% Show images filtered with the 3x3 window
subplot(3,4,1), imshow(filtered_gaussian_3x3_01), title('3x3 Filter, Gaussian Noise (Var=0.01)');
subplot(3,4,2), imshow(filtered_gaussian_3x3_02), title('3x3 Filter, Gaussian Noise (Var=0.02)');
subplot(3,4,3), imshow(filtered_saltpepper_3x3_01), title('3x3 Filter, Salt & Pepper Noise (0.01 Density)');
subplot(3,4,4), imshow(filtered_saltpepper_3x3_02), title('3x3 Filter, Salt & Pepper Noise (0.05 Density)');

% Show images filtered with the 5x5 window
subplot(3,4,5), imshow(filtered_gaussian_5x5_01), title('5x5 Filter, Gaussian Noise (Var=0.01)');
subplot(3,4,6), imshow(filtered_gaussian_5x5_02), title('5x5 Filter, Gaussian Noise (Var=0.02)');
subplot(3,4,7), imshow(filtered_saltpepper_5x5_01), title('5x5 Filter, Salt & Pepper Noise (0.01 Density)');
subplot(3,4,8), imshow(filtered_saltpepper_5x5_02), title('5x5 Filter, Salt & Pepper Noise (0.05 Density)');

% Show the original noisy images for reference
subplot(3,4,9), imshow(noisy_gaussian_01), title('Original Image, Gaussian Noise (Var=0.01)');
subplot(3,4,10), imshow(noisy_gaussian_02), title('Original Image, Gaussian Noise (Var=0.02)');
subplot(3,4,11), imshow(noisy_saltpepper_01), title('Original Image, Salt & Pepper (0.01 Density)');
subplot(3,4,12), imshow(noisy_saltpepper_02), title('Original Image, Salt & Pepper (0.05 Density)');

%% Section 3: Image Smoothing with Different Block Sizes and Overlap Options
image = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img2.jpg'); 
image_gray = rgb2gray(image);
% Set two block sizes for smoothing
size_small = 3; % Small 3x3 block for light smoothing
size_large = 5; % Larger 5x5 block for stronger smoothing

%% Step 3.1: Smoothing with Non-Overlapping Blocks
filter_small = fspecial('average', [size_small size_small]);
filter_large = fspecial('average', [size_large size_large]);

smooth_no_overlap_small = conv2(image_gray, filter_small, 'same');
smooth_no_overlap_large = conv2(image_gray, filter_large, 'same');

%% Step 3.2: Smoothing with Overlapping Blocks
overlap = [1 1]; % 1-pixel overlap around blocks

% Apply smoothing with overlapping blocks
smooth_with_overlap_small = blockproc(image_gray, [size_small size_small], ...
                                      @(block) mean(block.data(:)), ...
                                      'BorderSize', overlap, 'TrimBorder', false);
smooth_with_overlap_large = blockproc(image_gray, [size_large size_large], ...
                                      @(block) mean(block.data(:)), ...
                                      'BorderSize', overlap, 'TrimBorder', false);
figure;
subplot(2,3,1), imshow(image_gray), title('Original Grayscale Image');
subplot(2,3,2), imshow(uint8(smooth_no_overlap_small)), title('3x3 Non-Overlap Smoothing');
subplot(2,3,3), imshow(uint8(smooth_no_overlap_large)), title('5x5 Non-Overlap Smoothing');
subplot(2,3,4), imshow(uint8(smooth_with_overlap_small)), title('3x3 Overlap Smoothing');
subplot(2,3,5), imshow(uint8(smooth_with_overlap_large)), title('5x5 Overlap Smoothing');

