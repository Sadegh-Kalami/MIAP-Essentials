clear; close all ; clc ;% image_path = 'D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\Coins.png'; 

image_path = 'D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\cell.jpg';
original_image = imread(image_path);

gray_image = rgb2gray(original_image);

edge_detected = edge(gray_image, 'Canny');

[circle_centers, circle_radii] = imfindcircles(edge_detected, [10 50], ...
    'ObjectPolarity', 'bright', 'Sensitivity', 0.9);
size_cutoff = 25; % Threshold for classifying small and large circles

%  second image
% [circle_centers, circle_radii] = imfindcircles(edge_detected, [30 50], ...
%     'ObjectPolarity', 'bright', 'Sensitivity', 0.9);
% size_cutoff = 35; % Threshold for classifying small and large circles




% Classify circles into small and large
small_circle_indices = circle_radii < size_cutoff;
large_circle_indices = circle_radii >= size_cutoff;

small_centers = circle_centers(small_circle_indices, :);
small_radii = circle_radii(small_circle_indices);

large_centers = circle_centers(large_circle_indices, :);
large_radii = circle_radii(large_circle_indices);

keep_small = true(size(small_centers, 1), 1); % Logical array to track valid small circles

for i = 1:size(large_centers, 1)
    large_center = large_centers(i, :);
    large_radius = large_radii(i);

    distances = sqrt(sum((small_centers - large_center).^2, 2));

    keep_small = keep_small & (distances > large_radius);
end

filtered_small_centers = small_centers(keep_small, :);
filtered_small_radii = small_radii(keep_small);

figure;
imshow(original_image);
hold on;

viscircles(filtered_small_centers, filtered_small_radii, 'Color', 'g');

viscircles(large_centers, large_radii, 'Color', 'm');


title('Detected Circles: Small (Green) and Large (Magenta)');
hold off;