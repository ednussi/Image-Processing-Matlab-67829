function [fourierImage] = DFT2(image)
%DFT converts 2D discrete images to thier fourier representation

%Constants
COL_SIZE = 2;
ROW_SIZE = 1;

if size(image, ROW_SIZE) == 1 || size(image, COL_SIZE) == 1
    fourierImage = DFT(image); %in case is a vector
else
    fourierImage = conj(DFT(DFT(image)')');
end

end

