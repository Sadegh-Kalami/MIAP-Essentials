clc; clear; close all;

noiseImg = randn(256, 256);
dctImg = dct2(noiseImg);
[cApprox, cHor, cVer, cDiag] = dwt2(noiseImg, 'haar');

figure;

subplot(3, 3, 1);
imshow(noiseImg, []);
title('Random Noise');

subplot(3, 3, 2);
imshow(log(abs(dctImg)), []);
colormap(gca, jet); colorbar;
title('DCT Coefficients');

subplot(3, 3, 3);
histogram(dctImg(:), 256, 'FaceColor', 'g');
title('DCT Histogram');
xlabel('Value'); ylabel('Count');

subplot(3, 3, 4);
imshow(cApprox, []);
title('Wavelet Approximation');

subplot(3, 3, 5);
imshow(cHor, []);
title('Wavelet Horizontal');

subplot(3, 3, 6);
imshow(cVer, []);
title('Wavelet Vertical');

% Wavelet Diagonal Details
subplot(3, 3, 7);
imshow(cDiag, []);
title('Wavelet Diagonal');

subplot(3, 3, 8);
histogram(cApprox(:), 256, 'FaceColor', 'm');
title('Wavelet Histogram');
xlabel('Value'); ylabel('Count');

subplot(3, 3, 9);
hold on;
histogram(dctImg(:), 256, 'FaceColor', 'g', 'FaceAlpha', 0.5);
histogram(cApprox(:), 256, 'FaceColor', 'm', 'FaceAlpha', 0.5);
hold off;
title('Histogram Comparison');
xlabel('Value'); ylabel('Count');
legend('DCT', 'Wavelet');
