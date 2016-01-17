function [fourierSignal] = DFT(signal)
%DFT converts 1D discrete signals to its fourier representation

%Finds signal sizes
COL_SIZE = 2;
ROW_SIZE = 1;
signalRowSize = size(signal, ROW_SIZE);
signalColSize = size(signal, COL_SIZE);

% In case is a 1X1 matrix
if signalRowSize == 1 && signalColSize == 1
    fourierSignal = signal;
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

%Creates the vandermonde matrix
indexVec = 1:matSize;
vandTemp = exp(indexVec * (-2 * pi * 1i / matSize));
vanderMat = rot90(vander(vandTemp),2);

% Calculate the Discrete Fourier Transform
if isColSignal == 1
    fourierSignal = vanderMat * signal;
else
    fourierSignal = signal * vanderMat;
end
fourierSignal = conj(fourierSignal);

end



