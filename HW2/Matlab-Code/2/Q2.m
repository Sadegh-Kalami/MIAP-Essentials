inputImage = imread('D:\My-Documants\PhD\Term_03_1403\HW2_402811068\HW2\Nuclei.png');

grayscaleImage = rgb2gray(inputImage);
doubleImage = im2double(grayscaleImage);

thresholdLevel = graythresh(doubleImage);
binaryMask = imbinarize(doubleImage, thresholdLevel);
binaryMask = ~binaryMask;

contrastEnhancedImage = imadjust(doubleImage);

structuringElement = strel('disk', 3);
morphOpenedImage = imopen(contrastEnhancedImage, structuringElement);
morphClosedImage = imclose(morphOpenedImage, structuringElement);

erodedImage = imerode(binaryMask, structuringElement);
dilatedImage = imdilate(binaryMask, structuringElement);

boundaryExtraction = binaryMask - erodedImage;

objectPerimeter = bwperim(binaryMask);

morphGradientImage = imsubtract(dilatedImage, erodedImage);

cannyEdges = edge(morphClosedImage, 'canny');

figure;
subplot(2, 3, 1); imshow(inputImage); title('Input Image');
subplot(2, 3, 2); imshow(doubleImage); title('Converted Grayscale Image');
subplot(2, 3, 3); imshow(boundaryExtraction, []); title('Extracted Boundaries (Erosion Subtraction)');
subplot(2, 3, 4); imshow(objectPerimeter); title('Perimeter of Objects');
subplot(2, 3, 5); imshow(morphGradientImage, []); title('Morphological Gradient');
subplot(2, 3, 6); imshow(cannyEdges); title('Edge Detection (Canny)');
