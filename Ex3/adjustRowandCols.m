function [mat2] = adjustRowandCols(mat1,mat2)
%ADJUSTROWANDCOLS This function adjust any matrix(image) 
% dimensions which are not matching the 2nd matrix
mat1Size = size(mat1);
mat2Size = size(mat2);
if(mat1Size(1) ~= mat2Size(1) || mat1Size(2) ~= mat2Size(2) )
    mat2 = mat2(1:mat1Size(1), 1:mat1Size(2));
end
end

