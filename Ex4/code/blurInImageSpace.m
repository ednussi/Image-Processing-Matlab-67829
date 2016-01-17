function [blurImage] = blurInImageSpace(inImage, kernelSize)
%Function that performs image blurring using 2D convolution between the
%image f and a gaussian kernel g.
%in image - is the input to be blurred(grayscale double image)
%kernelSize -is the size of the gaussian in each dimension(one odd
%integer)
%blurImage - is the output blurry image(grayscale double image)

%Kernel size check
if kernelSize <= 0 || mod(kernelSize, 2) == 0
    error('Error: The kernel size must be an odd positive int')
end

%Finds image sizes
[rowSize, colSize] = size(inImage);

%In case kernel is bigger than image sizes
if kernelSize >= rowSize ||  kernelSize >= colSize
    error('Error: The kernel size must be smaller than image smallest dimensions')
end

%In case of no blur
if kernelSize == 1
    blurImage = inImage;
    return;
end

% Create the gaussian kernel
GAUSS_KERNEL = [1 1];
gaussKernel = GAUSS_KERNEL;
for i = 1:(kernelSize - 2)
    gaussKernel = conv(gaussKernel, GAUSS_KERNEL);
end

%Normalize and get 2D gauusKernel
gaussKernel2D = (gaussKernel' * gaussKernel) / sum(sum((gaussKernel' * gaussKernel)));

% Blur the image using convolotion
blurImage = conv2(inImage, gaussKernel2D, 'same');

end