function [image] = IDFT2(fourierImage)
%IDFT2 converts 2D fourier transforms into their image representation

%Constants
COL_SIZE = 2;
ROW_SIZE = 1;

if size(fourierImage, ROW_SIZE) == 1 || size(fourierImage, COL_SIZE) == 1
    image = IDFT(fourierImage); %in case is a vector
else
    image = IDFT(IDFT(fourierImage.').');
end

end

