clear; close all; clc;

%% Load and preprocess the image
tumor_image = rgb2gray(imread('D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\Tumor.png'));
figure;
imshow(tumor_image), title('Input Tumor Image');

%% Segmentation using Multi-threshold Otsu Method
num_thresholds_1 = 3;
otsu_thresholds_1 = multithresh(tumor_image, num_thresholds_1);
segmented_labels_1 = imquantize(tumor_image, otsu_thresholds_1);
segmented_otsu_1 = labeloverlay(tumor_image, segmented_labels_1);

figure;
subplot(1, 2, 1), imshow(tumor_image), title('Input Tumor Image');
subplot(1, 2, 2), imshow(segmented_otsu_1), title('Otsu Segmentation (3 Levels)');

num_thresholds_2 = 5;
otsu_thresholds_2 = multithresh(tumor_image, num_thresholds_2);
segmented_labels_2 = imquantize(tumor_image, otsu_thresholds_2);
segmented_otsu_2 = labeloverlay(tumor_image, segmented_labels_2);

figure;
subplot(1, 2, 1), imshow(tumor_image), title('Input Tumor Image');
subplot(1, 2, 2), imshow(segmented_otsu_2), title('Otsu Segmentation (5 Levels)');

%% Apply Low-Pass Filter and Segment
cutoff_frequency = 9;
filter_order = 3;
filtered_image = applyGaussianLPF(im2double(tumor_image), cutoff_frequency, filter_order);

num_thresholds_3 = 3;
otsu_thresholds_3 = multithresh(filtered_image, num_thresholds_3);
segmented_labels_3 = imquantize(filtered_image, otsu_thresholds_3);
segmented_filtered_otsu = labeloverlay(filtered_image, segmented_labels_3);

figure;
subplot(2, 2, 1), imshow(tumor_image), title('Input Tumor Image');
subplot(2, 2, 2), imshow(filtered_image), title('Gaussian Low-Pass Filtered Image');
subplot(2, 2, [3, 4]), imshow(segmented_filtered_otsu), title('Filtered Otsu Segmentation (3 Levels)');

%% Segmentation using K-means Clustering
num_clusters = 4;
segmented_kmeans_labels = imsegkmeans(tumor_image, num_clusters);
segmented_kmeans = labeloverlay(tumor_image, segmented_kmeans_labels);

figure;
subplot(1, 2, 1), imshow(tumor_image), title('Input Tumor Image');
subplot(1, 2, 2), imshow(segmented_kmeans), title('K-means Segmentation (4 Clusters)');
