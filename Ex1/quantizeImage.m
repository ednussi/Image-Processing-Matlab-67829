function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter)
% quantizeImage - Function which Performs quantization of a given grayscale 
% or RGB image
% args: imOrig - grayscale or RGB double image.
%       nQuant - number of Colors to redivide the image into
%       nIter - max number of iterations to run of quantization algo.
% return: imEq - equalized image
%         imQuant - the quantizied image 
%         error - the error vector which shows the quadratic error of each
%                 iteration.

%args check
if (nQuant < 1 || (floor(nQuant) ~= nQuant))
    error('Failue: nQuant must be integer larger than 0');
end

if (nIter < 0 || (floor(nQuant) ~= nQuant))
    error('Failue: nIter must be a non negative integer');
end

%constants
color = 3;
grayscale = 2;

%Attain image dimensions
dim = size(imOrig);
dimSize = size(dim);
mode = dimSize(2);
pixels = dim(1)*dim(2);

%detrminte if image is rgb or grayscale
if mode == color
    matOrig = 0.299 * imOrig(:,:,1) + 0.587 * imOrig(:,:,2) + 0.114 * imOrig(:,:,3);
    YIQmat = rgb2ntsc(imOrig);
elseif mode == grayscale
    matOrig = imOrig;
else
    error('Warning: image format unknown');
end

%Check if Quantization is possible for given values
imHist = imhist(matOrig);
diffPix = size(find(imHist > 0));
clrAmount = diffPix(1);
if (clrAmount < nQuant) %case image has less colors than wanted nQuants
    error('Error: Cannot Quantizie image since number of colors in image is less than nQuant');
elseif (clrAmount == nQuant) %case image already meets quantization criterias
    error = 0;
    imQuant = imOrig;
    return;
end

%Calculate initial Zs
cumHist = cumsum(imHist);
pixPerQuant = pixels / nQuant;
Z = ones(1, nQuant+1);
for i=1:(nQuant-1)
    endQuant = find(cumHist > pixPerQuant*i,1);
    Z(i+1) = endQuant; %maybe create array of size from advanced
end
Z(end) = 256;

%Initialize info for the iterations
error = zeros(nIter , 1);
convMat=[1,1];
for i=1:nIter
    
    %Find Q according to given formula
    startSeg = 1;
    Q = zeros(1, nQuant - 1);
    for j=1:nQuant
        endSeg = Z(j+1) - 1;
        mult1 = startSeg:(endSeg);
        mult2 = imHist(startSeg:endSeg);
        curQ = round(mult1 * mult2 / sum(mult2));
        startSeg = endSeg + 1;
        Q(j) = curQ;
    end

    %Find matching Z according to given formula
    Z = round(conv(Q,convMat)/2);
    Z = Z(2:end-1);
    Z = [1, Z, 256];

    %Calcualte Error according to given formula
    startSeg = 1;
    for j=1:nQuant
        endSeg = Z(j+1);
        z = (startSeg-1):(endSeg-1);
        Qi = Q(j);
        curCumHist = imHist(startSeg:endSeg);
        curError = ((Qi-z).^2)*(curCumHist);
        startSeg = endSeg + 1;
    end
    curErrorVal = sum(curError);
    if ((i ~= 1) && (error(i-1) == curErrorVal))
        error = error(1:i-1);
        break;
    end
    error(i) = curErrorVal; 

end

%Quantizing the original image with updated values
Z = Z-1;
imInt = im2uint8(matOrig);
for j=1:(nQuant-1)
    imInt((imInt >= Z(j)) & (imInt < Z(j+1))) = Q(j);
end
imInt((imInt >= Z(nQuant)) & (imInt <= Z(nQuant+1))) = Q(nQuant);
imQuant = im2double(imInt);

%in case originl picture wasn't RGB return to RGB
if mode == color
    YIQmat(:,:,1) = imQuant;
    imQuant = ntsc2rgb(YIQmat);
end

end
