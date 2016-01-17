function [imBlend] = pyramidBlending(im1, im2, mask, maxLevels, filterSizeIm, filterSizeMask)
%PYRAMIDBLENDING Blends in 2 diffrent images into 1
%Args
%im1, im2 - are two input grayscale images to be blended.
%mask - is a binary mask containing 1’s and 0’s representing which parts of 
%       im1 and im2 should appear in the resulting imBlend.
%maxLevels - is the maxLevels parameter you should use when generating 
%            the Gaussian and Laplacianpyramids.
%filterSizeIm - is the size of the Gaussian filter 
%               (an odd scalar that represents a squared filter) which
%               defining the filter used in the construction of the 
%               Laplacian pyramids of im1 and im2.
%filterSizeMask - is the size of the Gaussian filter
%                 (an odd scalar that represents a squared filter) which
%                 defining the filter used in the construction of the
%                 Gaussian pyramid of mask.
% Return
% imBlend - the blended image

[rowSize1,colSize1] = size(im1);
[rowSize2,colSize2] = size(im2);
mask = im2double(mask);
[maskRowSize,maskColSize] = size(mask);

if rowSize1 ~= rowSize2 || colSize1 ~= colSize2
    error('Images dimensions do not fit');
end

if maskRowSize ~= rowSize1 || maskColSize ~= colSize1
    error('Mask dimensions do not fit images');
end

%Builds both laplcian pyrmadis
[lapPyrm1, filter] = LaplacianPyramid(im1, maxLevels, filterSizeIm);
lapPyrm2  = LaplacianPyramid(im2, maxLevels, filterSizeIm);

% Builds gaussian pyrmaid for the mask
maskGaussPyrm = GaussianPyramid(mask, maxLevels, filterSizeMask);

%Creats the merged pyramid
mergedLapPyrm = cell(maxLevels,1);
for i=1:maxLevels
    mergedLapPyrm{i} = maskGaussPyrm{i}.*lapPyrm1{i} + ...
                       (1-maskGaussPyrm{i}).*lapPyrm2{i};
end

%Builds up the image
coeffMultVec = ones(maxLevels);
imBlend = LaplacianToImage(mergedLapPyrm, filter, coeffMultVec);

end