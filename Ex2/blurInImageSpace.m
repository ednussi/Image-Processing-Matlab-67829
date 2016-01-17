function [blurImage] = blurInImageSpace(inImage, kernelSize)
%BLURINIMAGESPACE Blur the image input in the space plain

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

%In case kernel is bigger than image sizes
if kernelSize >= rowSize ||  kernelSize >= colSize
    error('Error: The kernel size must be smaller than image smallest dimensions')
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

% Convolution of the padded image with the blur kernel
% and unpadds the image to get the blurred image in proper dimensions
paddedImage = conv2(paddedImage, blurKernel, 'same');
blurImage = paddedImage(extraPadSize:end - extraPadSize - 1, ...
                        extraPadSize:end - extraPadSize - 1);

figure; imshow(blurImage);

end