function [pyr, filter] = LaplacianPyramid(im, maxLevels, filterSize)
%UNTITLED Builds the laplcian pyramid of a given image
%Args
% im - a grayscale image with double values in [0,1] 
%      image dimensions are multiples of 2^(maxLevels?1).
% maxLevels - the maximal number of levels in the resulting pyramid. 
% filterSize - the size of the Gaussian filter 
%              (an odd scalar that represents a squared filter) 
%               to be used in constructing the pyramid filter.
% Returns
% filter - which is 1D-row of size filterSize used for the pyramid construction.
% pyr - is a column cell array with maximum of maxLevels cells 
%       of grayscale images

[gaussPyrm, filter] = GaussianPyramid(im,maxLevels,filterSize);

% Calc the max number of levels
maxLevels = findMaxLevel(min(size(im)), maxLevels);

% Set the filter and base of pyramid
pyr = cell(maxLevels,1);
pyr{maxLevels} = gaussPyrm{maxLevels};

for  level=maxLevels:-1:2
    %Expand and reduce the previous stage
    curGauss = gaussPyrm{level};
    [rowSize, colSize] = size(curGauss);
    rowSize = rowSize*2;
    colSize = colSize*2;
    expandedGauss = zeros(rowSize,colSize);
    expandedGauss(1:2:end,1:2:end) = curGauss;
    
    % Blur
    bluredExpand = conv2(expandedGauss, 2 * filter, 'same');
    bluredExpand = conv2(bluredExpand, 2 * filter', 'same');
    
    %Check rows and cols
    bluredExpand = adjustRowandCols(gaussPyrm{level-1} ,bluredExpand);
    
    %Save into pyramid
    pyr{level-1} = gaussPyrm{level-1} - bluredExpand;
end

end

