clear; close all; clc;

%% Load and Preprocess the Image
inputImage = imread('D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\Kidney.jpg'); 
figure;
imshow(inputImage);
title('Original Input Image');

%% Morphological Step: Erosion to Remove Small Bright Features
structuringElement = strel('disk', 2); % Create a disk-shaped structuring element
erodedImage = imerode(inputImage, structuringElement); % Perform erosion
figure;
imshow(erodedImage);
title('Eroded Image to Suppress Fine Details');

%% Morphological Step: Opening to Smooth Regions
openedImage = imopen(erodedImage, structuringElement); % Perform morphological opening
figure;
imshow(openedImage);
title('Opened Image to Remove Small Irregularities');

%% K-means Clustering for Image Segmentation
numClusters = 8; % Define the number of clusters for segmentation
% Perform K-means clustering on the preprocessed image
[clusterIndices, ~] = kmeans(double(openedImage(:)), numClusters, 'Replicates', 5);
% Reshape the clustering output to match the original image dimensions
segmentationResult = reshape(clusterIndices, size(openedImage));

%% Assign Custom Colors to Clusters
clusterColors = [
    255, 69, 0;       % Orange Red
    50, 205, 50;      % Lime Green
    65, 105, 225;     % Royal Blue
    218, 165, 32;     % Goldenrod
    75, 0, 130;       % Indigo
    255, 20, 147;     % Deep Pink
    176, 224, 230;    % Light Blue
    128, 0, 128;      % Purple
];

% Create an RGB image for the colored segmentation
coloredImage = uint8(zeros([size(segmentationResult), 3])); % Initialize an RGB image

% Map each cluster to its corresponding color
for cluster = 1:numClusters
    mask = (segmentationResult == cluster);
    coloredImage(repmat(mask, [1, 1, 3])) = repmat(clusterColors(cluster, :), sum(mask(:)), 1);
end

%% Display the Results
figure;
subplot(1, 3, 1);
imshow(inputImage);
title('Input Grayscale Image');

subplot(1, 3, 2);
imshow(openedImage);
title('Preprocessed Image (Erosion + Morphological Opening)');

subplot(1, 3, 3);
imshow(coloredImage);
title('Segmented Image with Cluster Colors');
