function [signal] = IDFT(fourierSignal)
%IDFT converts 1D discrete fourier representation to its signals 

%Finds signal sizes
COL_SIZE = 2;
ROW_SIZE = 1;
signalRowSize = size(fourierSignal, ROW_SIZE);
signalColSize = size(fourierSignal, COL_SIZE);

% In case is a 1X1 matrix
if signalRowSize == 1 && signalColSize == 1
    signal = fourierSignal;
    return;
end

% Checks if is a row or column vector
if signalRowSize ~= 1 
    isColSignal = 1;
    matSize = signalRowSize;
else
    isColSignal = 0;
    matSize = signalColSize;
end

%Creates the exponent matching matrix for multiplication
uVec = 0:(matSize-1);
xVec = (uVec)';
expMat = exp(2 * pi * 1i * (xVec * uVec) / matSize);

% Generate Vandermonde
%vandTemp = exp((1:matSize) * (2i*pi/matSize));
%expMat = rot90((vander(vandTemp)),2);


% Calculate the Discrete Fourier Transform
if isColSignal == 1
    signal = expMat * fourierSignal;
else
    signal = fourierSignal * expMat;
end
signal = signal / matSize;

end

