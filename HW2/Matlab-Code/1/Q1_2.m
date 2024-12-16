clear; close all; clc;

input_image = im2double(imread('D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\cell.jpg'));
grayscale_image = rgb2gray(input_image);
threshold_value = graythresh(grayscale_image);
binary_mask = ~im2bw(grayscale_image, threshold_value);

figure;
subplot(1, 3, 1); imshow(input_image); title('Original Image');
saveas(gcf, 'Original_Image.png');
subplot(1, 3, 2); imshow(grayscale_image); title('Grayscale Image');
saveas(gcf, 'Grayscale_Image.png');
subplot(1, 3, 3); imshow(binary_mask); title('Binary Mask');
saveas(gcf, 'Binary_Mask.png');

structuring_element = strel('disk', 4);

eroded_result = imerode(binary_mask, structuring_element);
figure;
subplot(2, 1, 1), imshow(binary_mask), title('Binary Mask');
subplot(2, 1, 2), imshow(eroded_result), title('Eroded Result');
saveas(gcf, 'Eroded_Result.png');

dilated_result = imdilate(binary_mask, structuring_element);
figure;
subplot(2, 1, 1), imshow(binary_mask), title('Binary Mask');
subplot(2, 1, 2), imshow(dilated_result), title('Dilated Result');
saveas(gcf, 'Dilated_Result.png');

opened_result = bwmorph(binary_mask, 'open');
figure;
subplot(2, 1, 1), imshow(binary_mask), title('Binary Mask');
subplot(2, 1, 2), imshow(opened_result), title('Morphologically Opened Result');
saveas(gcf, 'Opened_Result.png');

closed_result = bwmorph(binary_mask, 'close');
figure;
subplot(2, 1, 1), imshow(binary_mask), title('Binary Mask');
subplot(2, 1, 2), imshow(closed_result), title('Morphologically Closed Result');
saveas(gcf, 'Closed_Result.png');

skeletonized_result = bwmorph(binary_mask, 'skel', inf);
figure;
subplot(2, 1, 1), imshow(binary_mask), title('Binary Mask');
subplot(2, 1, 2), imshow(skeletonized_result), title('Skeletonized Image');
saveas(gcf, 'Skeletonized_Result.png');

thinned_result = bwmorph(binary_mask, 'thin');
thickened_result = bwmorph(binary_mask, 'thick');
figure;
subplot(1, 3, 1); imshow(binary_mask); title('Binary Mask');
subplot(1, 3, 2); imshow(thinned_result); title('Thinned Image');
subplot(1, 3, 3); imshow(thickened_result); title('Thickened Image');
saveas(gcf, 'Thinned_and_Thickened_Result.png');

filled_result = imfill(binary_mask, 'holes');
figure;
subplot(1, 2, 1); imshow(binary_mask); title('Binary Mask');
subplot(1, 2, 2); imshow(filled_result); title('Hole-Filled Image');
saveas(gcf, 'Hole_Filled_Result.png');
