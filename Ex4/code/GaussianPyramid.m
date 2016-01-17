function [pyr, filter] = GaussianPyramid(im, maxLevels, filterSize)
%UNTITLED Builds the gaussian pyramid of a given image
%Args
% im - a grayscale image with double values in [0,1] 
% image dimensions are multiples of 2^(maxLevels?1).
% maxLevels - the maximal number of levels in the resulting pyramid. 
% filterSize - the size of the Gaussian filter 
% (an odd scalar that represents a squared filter) 
% to be used in constructing the pyramid filter.

% Filter Size check
if filterSize <= 0 || mod(filterSize, 2) == 0
    error('Error: filterSize must be an odd positive int');
end

% Create blur kernel
GAUSS_KERNEL = [1 1];
gaussKernel = GAUSS_KERNEL;
for i = 1:filterSize - 2
    gaussKernel = conv2(gaussKernel, GAUSS_KERNEL);
end
sizeOfGaussKernel = sum(gaussKernel);
% normalize - makes sure picture averege stays the same
blurKernel = gaussKernel / sizeOfGaussKernel; 

% Max level check
if maxLevels <= 0
    error('Error: maxLevels must be a positive int'); 
end 

% Calc the max number of levels
maxLevels = findMaxLevel(min(size(im)), maxLevels);

% Set the filter and base of pyramid
pyr = cell(maxLevels,1);
pyr{1} = im;
filter = blurKernel;

% In case no operations are needed
if  maxLevels == 1
    return;
end

%Pads image with extra pixels in a circular manner
extraPadSize = floor(filterSize/2);
curIm = im;

% Convolution of the padded image with the blur kernel
% and unpadds the image to get the blurred image in proper dimensions
for  level=1:maxLevels-1
    paddedImage = padarray(curIm, [extraPadSize, extraPadSize], 'circular');
    bluredIm = conv2(paddedImage, blurKernel, 'same');
    bluredIm = conv2(bluredIm, blurKernel', 'same');
    blurImage = bluredIm(extraPadSize:end - extraPadSize - 1, ...
                        extraPadSize:end - extraPadSize - 1);
    gaussPyrm = blurImage(1:2:end,1:2:end);
    pyr{level + 1} = gaussPyrm;
    curIm = gaussPyrm;
end


end

