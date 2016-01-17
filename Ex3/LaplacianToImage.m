function [img] = LaplacianToImage(lpyr, filter, coeffMultVec)
%LAPLACIANTOIMAGE Turns from a laplcian pyramid back the original image
%Args
%lpyr - is the Laplacian pyramid
%filter - the size of the Gaussian filter 
%         (an odd scalar that represents a squared filter) 
%         to be used in constructing the pyramid filter.
% coeffMultVec -  is a vector. The vector size is the same as the 
%                 number of levels in the pyramid lpyr.
%                 Before reconstructing the image img you should multiply 
%                 each level i of the laplacian pyramid by
%                 its corresponding coefficient coeffMultVec(i).

pyrSize = size(lpyr,1);

% Make sure it's a vector and not row
if (size(coeffMultVec,1) == 1)
    coeffMultVec = coeffMultVec';
end

%Checks matching sizes
if size(coeffMultVec,1) ~= pyrSize
    error('Error: coeffMultVec size and lpyr size do not Match');
end

%In case there is only one level
if pyrSize == 1
    img = lpyr{1} * coeffMultVec(1);
    return;
end

img = lpyr{pyrSize};
for i=pyrSize-1:-1:1

   %Expand level
    [rowSize, colSize] = size(img);
    rowSize = rowSize * 2;
    colSize = colSize * 2;
    expandedLap = zeros(rowSize,colSize);
    expandedLap(1:2:end,1:2:end) = img;
    bluredExpand = conv2(expandedLap, 2 * filter, 'same');
    bluredExpand = conv2(bluredExpand, 2 * filter', 'same');
   
    %Check rows and cols
    bluredExpand = adjustRowandCols(lpyr{i} ,bluredExpand);
    
    %Update the image
    img = lpyr{i} * coeffMultVec(i) + bluredExpand;
end

end

