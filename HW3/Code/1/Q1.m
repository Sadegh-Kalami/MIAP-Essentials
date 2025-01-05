clc; clear; close all;

img = imread('..\..\chest-ct-scan.jpg');
if size(img, 3) == 3
    img = rgb2gray(img);
end

maxVal = max(img(:));
disp(['Max Value: ', num2str(maxVal)]);

img = double(img);
psnrTargets = [10, 15, 20];
maxVal = double(maxVal);
mseTargets = (maxVal^2) ./ (10.^(psnrTargets / 10));

noisyImgs = cell(1, length(psnrTargets));
psnrActual = zeros(1, length(psnrTargets));

for i = 1:length(psnrTargets)
    noiseVar = mseTargets(i);
    noisyImg = img + sqrt(noiseVar) * randn(size(img));
    noisyImg = max(0, min(255, noisyImg));
    psnrActual(i) = 10 * log10((maxVal^2) / noiseVar);
    noisyImgs{i} = noisyImg;
end

figure;
subplot(2, 2, 1);
imshow(uint8(img));
title('Original');

for i = 1:length(psnrTargets)
    subplot(2, 2, i + 1);
    imshow(uint8(noisyImgs{i}));
    title(['PSNR: ', num2str(psnrActual(i), '%.2f'), ' dB']);
end
