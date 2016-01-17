function [magnitude] = fourierDerivative(inImage)
% fourierDerivative Calculate the magnitude of an image
% in the fourier domain

%Constants
COL_SIZE = 2;
ROW_SIZE = 1;
signalRowSize = size(inImage, ROW_SIZE);
signalColSize = size(inImage, COL_SIZE);

%Calculating the coefficents matrices
%Creating proper size vectors
yCofRow = -floor(signalColSize/2):(ceil(signalColSize)/2 - 1);
xCofRow = -floor(signalRowSize/2):(ceil(signalRowSize)/2 - 1);
% turning the vectors into matrices
yCofMat = repmat(yCofRow,signalRowSize,1);
xCofMat = repmat(xCofRow,signalColSize,1);

%Calculate the fourier trnasform and derivate
fImg =  fftshift(DFT2(inImage));
dx = 2 * pi * 1i * ifft2((xCofMat)' .* fImg) / signalRowSize;
dy = 2 * pi * 1i * ifft2(fImg .* yCofMat) / signalColSize;

%Calculate the magnitude
magnitude = sqrt(dx.^2 + dy.^2);
figure; imshow(magnitude);

end

