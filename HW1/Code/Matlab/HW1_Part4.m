%%
% Homework Solution - HW1
% Mohammad Sadegh Kalami Yazdi
% Student ID: 402811068
%% Section 1: Image Loading and Intensity Transformations

img1 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img1.jpg'); 
img2 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img2.jpg'); 

gray_img1 = rgb2gray(img1); 
gray_img2 = rgb2gray(img2); 

% Histogram Equalization
eq_img1 = histeq(gray_img1);
eq_img2 = histeq(gray_img2);

% Logarithmic Transformation
scale_log = 100; 
log_img1 = scale_log * log(1 + im2double(gray_img1));
log_img2 = scale_log * log(1 + im2double(gray_img2));

% Exponential Transformation
scale_exp = 1;
gamma_value = -5;
exp_img1 = scale_exp * (im2double(gray_img1) .^ gamma_value);
exp_img2 = scale_exp * (im2double(gray_img2) .^ gamma_value);

% Display original and transformed images for the first image
figure;
subplot(2,4,1), imshow(gray_img1), title('Original Grayscale');
subplot(2,4,2), imshow(eq_img1), title('Equalized Intensity');
subplot(2,4,3), imshow(uint8(log_img1)), title('Logarithmic Adjusted');
subplot(2,4,4), imshow(uint8(exp_img1)), title('Exponential Adjusted');

% Display histograms for the first image transformations
subplot(2,4,5), imhist(gray_img1), title('Initial Histogram');
subplot(2,4,6), imhist(eq_img1), title('Histogram after Equalization');
subplot(2,4,7), imhist(uint8(log_img1)), title('Histogram after Log Adjustment');
subplot(2,4,8), imhist(uint8(exp_img1)), title('Histogram after Exponential Adjustment');

% Display original and transformed images for the second image
figure;
subplot(2,4,1), imshow(gray_img2), title('Source Grayscale');
subplot(2,4,2), imshow(eq_img2), title('Enhanced with Equalization');
subplot(2,4,3), imshow(uint8(log_img2)), title('Logarithmic Transformation');
subplot(2,4,4), imshow(uint8(exp_img2)), title('Exponential Transformation');

% Display histograms for the second image transformations
subplot(2,4,5), imhist(gray_img2), title('Source Histogram');
subplot(2,4,6), imhist(eq_img2), title('Post-Equalization Histogram');
subplot(2,4,7), imhist(uint8(log_img2)), title('Post-Log Transformation Histogram');
subplot(2,4,8), imhist(uint8(exp_img2)), title('Post-Exponential Histogram');
%% Section 2: Histogram Matching

% Load images and convert to grayscale
img1 = rgb2gray(imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\Medical_image.jpg')); 
img2 = rgb2gray(imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img2.jpg'));

% Perform histogram matching
matched_img = imhistmatch(img1, img2);

% Display original and matched images with histograms
figure;
subplot(2,3,1), imshow(img1), title('Original Grayscale 1');
subplot(2,3,2), imshow(img2), title('Reference Grayscale 2');
subplot(2,3,3), imshow(matched_img), title('Histogram Matched');

% Display histograms for the images
subplot(2,3,4), imhist(img1), title('Original Histogram 1');
subplot(2,3,5), imhist(img2), title('Reference Histogram 2');
subplot(2,3,6), imhist(matched_img), title('Matched Histogram');

%% Section 3: Applying Homomorphic Filter to Reduce Illumination Effects

% Load and prepare images in grayscale
img1 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img7.jpg');  
img2 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img9.jpg'); 

% Ensure the images are the same size
if ~isequal(size(img1), size(img2))
    img2 = imresize(img2, size(img1));
end

% Convert images to double and apply logarithmic transformation
img1_log = log(1 + im2double(img1));
img2_log = log(1 + im2double(img2));

% FFT transformation for frequency domain processing
img1_fft = fft2(img1_log);
img2_fft = fft2(img2_log);

% Create a Gaussian low-pass filter for the frequency domain
[M, N] = size(img1_log);
[x, y] = meshgrid(1:N, 1:M);
center_x = ceil(M / 2);
center_y = ceil(N / 2);
D = sqrt((x - center_x).^2 + (y - center_y).^2);  
H = 1 ./ (1 + (D / 150).^4);  % Gaussian filter

% Apply the filter in the frequency domain
img1_fft_filtered = img1_fft .* H;
img2_fft_filtered = img2_fft .* H;

% Inverse FFT to bring filtered images back to the spatial domain
img1_filtered_log = real(ifft2(img1_fft_filtered));
img2_filtered_log = real(ifft2(img2_fft_filtered));

% Convert back to original intensity range
img1_filtered = exp(img1_filtered_log) - 1;
img2_filtered = exp(img2_filtered_log) - 1;

% Normalize images to range [0, 255]
img1_filtered = uint8(mat2gray(img1_filtered) * 255);
img2_filtered = uint8(mat2gray(img2_filtered) * 255);

if ndims(img1_filtered) == 3  % Check if img1_filtered is RGB
    img1_filtered = rgb2gray(img1_filtered);
end
if ndims(img2_filtered) == 3  % Check if img2_filtered is RGB
    img2_filtered = rgb2gray(img2_filtered);
end

% Apply contrast adjustment to enhance visibility
img1_filtered = imadjust(img1_filtered);
img2_filtered = imadjust(img2_filtered);

% Display original and filtered images with histograms
figure;

% Display original and filtered images for Image 1
subplot(3, 4, 1), imshow(img1), title('Original Grayscale Image 1');
subplot(3, 4, 2), imshow(img1_filtered), title('Homomorphic Filtered Image 1');
subplot(3, 4, 3), imhist(img1), title('Original Histogram Image 1');
subplot(3, 4, 4), imhist(img1_filtered), title('Filtered Histogram Image 1');

% Display original and filtered images for Image 2
subplot(3, 4, 5), imshow(img2), title('Original Grayscale Image 2');
subplot(3, 4, 6), imshow(img2_filtered), title('Homomorphic Filtered Image 2');
subplot(3, 4, 7), imhist(img2), title('Original Histogram Image 2');
subplot(3, 4, 8), imhist(img2_filtered), title('Filtered Histogram Image 2');

%% Section 4
clear; close all; clc;
img = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img10.png');
if size(img, 3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% Convert image to double for processing
grayImg = double(grayImg);

% Preprocessing
% Contrast Enhancement using Histogram Equalization
enhancedImg = histeq(uint8(grayImg));
enhancedImg = double(enhancedImg);

% Noise Reduction using Gaussian Filtering
sigma = 2.0; % Increased sigma for more smoothing
gaussianFilter = fspecial('gaussian', [7 7], sigma); % Increased filter size
smoothedImg = imfilter(enhancedImg, gaussianFilter, 'same');

% Edge Detection
% Sobel Edge Detection
sobelEdges = edge(smoothedImg, 'Sobel');

% Prewitt Edge Detection
prewittEdges = edge(smoothedImg, 'Prewitt');

% Canny Edge Detection with adjusted thresholds
cannyEdges = edge(smoothedImg, 'Canny', [0.1 0.3]);

% Combine Edge Detection Results (Sobel, Prewitt, and Canny only)
combinedEdges = sobelEdges | prewittEdges | cannyEdges;

% Create a tiled layout for better subplot control
figure;
t = tiledlayout(2, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact'); % Compact spacing

% Plot All Results in a Single Figure with Subplots

nexttile;
imshow(grayImg, []);
title('Original Grayscale CT Image');

nexttile;
imshow(enhancedImg, []);
title('Contrast Enhanced Image');

nexttile;
imshow(smoothedImg, []);
title('Smoothed Image (Gaussian Filter)');

nexttile;
imshow(sobelEdges);
title('Edges Detected by Sobel');

nexttile;
imshow(prewittEdges);
title('Edges Detected by Prewitt');

nexttile;
imshow(cannyEdges);
title('Edges Detected by Canny');

figure;
imshow(combinedEdges);
title('Combined Edge Detection Results (Sobel, Prewitt, and Canny)');

set(gcf, 'Position', [100, 100, 1400, 900]);

%% Section 5: Downsampling and Aliasing Analysis

% Load the three images
img1 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img4.jpg');  
img2 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img5.jpg');  
img3 = imread('D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img3.jpg'); 

% Convert images to grayscale if they are in RGB format
if size(img1, 3) == 3
    img1_gray = rgb2gray(img1);  
else
    img1_gray = img1;  
end
if size(img2, 3) == 3
    img2_gray = rgb2gray(img2);  
else
    img2_gray = img2;  
end
if size(img3, 3) == 3
    img3_gray = rgb2gray(img3);  
else
    img3_gray = img3;  
end

% Downsample the images by a factor of 4 to observe aliasing effects
downsample_factor = 4;  
img1_downsampled = img1_gray(1:downsample_factor:end, 1:downsample_factor:end);
img2_downsampled = img2_gray(1:downsample_factor:end, 1:downsample_factor:end);
img3_downsampled = img3_gray(1:downsample_factor:end, 1:downsample_factor:end);

% Upsample back to original size using nearest neighbor interpolation to emphasize aliasing
img1_upsampled = imresize(img1_downsampled, size(img1_gray), 'nearest');
img2_upsampled = imresize(img2_downsampled, size(img2_gray), 'nearest');
img3_upsampled = imresize(img3_downsampled, size(img3_gray), 'nearest');

% Display original, downsampled, and upsampled images for aliasing observation
figure;
subplot(3, 3, 1), imshow(img1_gray), title('Original Image - Sample 1');
subplot(3, 3, 2), imshow(img1_downsampled), title('Downsampled by Factor 4 - Sample 1');
subplot(3, 3, 3), imshow(img1_upsampled), title('Upsampled (Aliasing) - Sample 1');

subplot(3, 3, 4), imshow(img2_gray), title('Original Image - Sample 2');
subplot(3, 3, 5), imshow(img2_downsampled), title('Downsampled by Factor 4 - Sample 2');
subplot(3, 3, 6), imshow(img2_upsampled), title('Upsampled (Aliasing) - Sample 2');

subplot(3, 3, 7), imshow(img3_gray), title('Original Image - Sample 3');
subplot(3, 3, 8), imshow(img3_downsampled), title('Downsampled by Factor 4 - Sample 3');
subplot(3, 3, 9), imshow(img3_upsampled), title('Upsampled (Aliasing) - Sample 3');
