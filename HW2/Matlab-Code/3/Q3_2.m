clear; close all; clc;
%%
input_image = im2double(rgb2gray(imread('D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\Tumor.png')));

% Identify the seed point for region growing
[seed_x, seed_y] = find(input_image == max(max(input_image)));

% Perform region growing
tumor_segmented = regionGrowingSegmentation(input_image, seed_x, seed_y);

% Display the results
figure;
subplot(1, 3, 1); imshow(input_image); title('Input Grayscale Image');
subplot(1, 3, 2); imshow(tumor_segmented); title('Tumor Segmentation Using Region Growing');
subplot(1, 3, 3); imshow(tumor_segmented + input_image); title('Overlay of Segmentation on Input Image');

% Calculate the tumor area
tumor_area = bwarea(tumor_segmented);
disp(['Tumor Area: ', num2str(tumor_area)]);
