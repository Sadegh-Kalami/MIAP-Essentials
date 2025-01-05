clc; clear; close all;

img = imread('..\..\chest-ct-scan.jpg');
if size(img, 3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

dctImg = dct2(double(grayImg));
[cApprox, cHor, cVer, cDiag] = dwt2(double(grayImg), 'haar');

figure;

% Original Image
subplot(3, 3, 1);
imshow(grayImg);
title('Original Image');

% DCT Transform Visualization
subplot(3, 3, 2);
imshow(log(abs(dctImg)), []);
colormap(gca, jet); colorbar;
title('DCT Coefficients');

% Histogram of DCT Coefficients
subplot(3, 3, 3);
histogram(dctImg(:), 256, 'FaceColor', 'b');
title('DCT Histogram');
xlabel('Value'); ylabel('Count');

% Wavelet Approximation Visualization
subplot(3, 3, 4);
imshow(cApprox, []);
title('Wavelet Approximation');

% Wavelet Detail Coefficients Visualization
subplot(3, 3, 5);
imshow(cHor, []);
title('Wavelet Horizontal');

subplot(3, 3, 6);
imshow(cVer, []);
title('Wavelet Vertical');

subplot(3, 3, 7);
imshow(cDiag, []);
title('Wavelet Diagonal');

% Histogram of Wavelet Approximation Coefficients
subplot(3, 3, 8);
histogram(cApprox(:), 256, 'FaceColor', 'r');
title('Wavelet Histogram');
xlabel('Value'); ylabel('Count');

% Comparison of Histograms
figure;
hold on;
histogram(dctImg(:), 256, 'FaceColor', 'b', 'FaceAlpha', 0.5);
histogram(cApprox(:), 256, 'FaceColor', 'r', 'FaceAlpha', 0.5);
hold off;
title('DCT vs Wavelet Histogram');
xlabel('Value'); ylabel('Count');
legend('DCT', 'Wavelet');
