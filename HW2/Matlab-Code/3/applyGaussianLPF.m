function outputImage = applyGaussianLPF(inputImage, cutoffFrequency, order)
    [rows, cols] = size(inputImage);
    transformedImage = fft2(double(inputImage));
    u = 0:(rows-1);
    v = 0:(cols-1);
    u(u > rows/2) = u(u > rows/2) - rows;
    v(v > cols/2) = v(v > cols/2) - cols;
    [V, U] = meshgrid(v, u);
    distanceMatrix = sqrt(U.^2 + V.^2);
    gaussianFilter = exp(-1/2 * (distanceMatrix.^2 / cutoffFrequency^order));
    filteredTransform = gaussianFilter .* transformedImage;
    outputImage = real(ifft2(filteredTransform));
end
