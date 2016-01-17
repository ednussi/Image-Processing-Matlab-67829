function [blurImage] = blurInFourierSpace(inImage, kernelSize)
%BLURINFOURIERSPACE Blur the image input in the fourier plain

% Constans
GAUSS_KERNEL = [1 1];
COL_SIZE = 2;
ROW_SIZE = 1;

%Kernel size check
if kernelSize <= 0 || mod(kernelSize, 2) == 0
    error('Error: The kernel size must be an odd positive int')
end

%Finds image sizes
rowSize = size(inImage, ROW_SIZE);
colSize = size(inImage, COL_SIZE);

if kernelSize >= min(rowSize, colSize)
    error('Kernel size must be less then minimal image dimension.')
end

%In case of no blur
if kernelSize == 1
    blurImage = inImage;
    figure; imshow(blurImage);
    return;
end

% Creates a vector of proper dimension from the gaussian kernel
gaussKernel = GAUSS_KERNEL;
for i = 1:kernelSize - 2
    gaussKernel = conv2(gaussKernel, GAUSS_KERNEL);
end
gaussKernel = conv2(gaussKernel, gaussKernel'); % turns vector into sqaured matrix
sizeOfGaussKernel = sum(sum(gaussKernel));
% normalize - makes sure picture averege stays the same
blurKernel = gaussKernel / sizeOfGaussKernel; 

%Pads image with extra pixels in a circular manner
extraPadSize = floor(kernelSize/2);
paddedImage = padarray(inImage, [extraPadSize, extraPadSize], 'circular');

%Gets padded image dimensions
rowSize = size(paddedImage, ROW_SIZE);
colSize = size(paddedImage, COL_SIZE);

%Turns the blur kernel into a blur Filter of proper dimesnsions
blurFilter = zeros(rowSize, colSize);
padImRowSize = floor(rowSize/2);
padImColSize = floor(colSize/2);
blurFilter(padImRowSize - extraPadSize:end - padImRowSize + extraPadSize,...
       padImColSize - extraPadSize:end - padImColSize + extraPadSize)...
       = blurKernel;

% Transform into fourier plain the image and filter
blurFilterFourier = fftshift(fft2(ifftshift(blurFilter)));
padImFourier = fftshift(fft2(paddedImage));

% Filters out the high frequencies transforms back and unpads to proper
% size
blurImageFourier = blurFilterFourier .* padImFourier;
paddedImage = ifft2(fftshift(blurImageFourier));
blurImage = paddedImage(extraPadSize:end - extraPadSize - 1,...
                        extraPadSize:end - extraPadSize - 1);
figure; imshow(blurImage);
end