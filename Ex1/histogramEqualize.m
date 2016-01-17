function [imEq, histOrig, histEq] = histogramEqualize(imOrig)
% histogramEqualize - Function which performs histogram equalization
% of a given grayscale or RGB image.
% args: imOrig - grayscale or RGB double image.
% return: imEq - equalized image
%         histOrig - original image 256 bin histogram  
%         histEq - equalized image 256 bin histogram 

color = 3;
grayscale = 2;

%Attain image dimensions
dim = size(imOrig);
dimSize = size(dim);
mode = dimSize(2);

if mode == color
    %histogram of the Y channel
    mat = 0.299 * imOrig(:,:,1) + 0.587 * imOrig(:,:,2) + 0.114 * imOrig(:,:,3);
    YIQmat = rgb2ntsc(imOrig);
elseif mode == grayscale
    mat = imOrig;
else
    error('Warning: image format unknown');
end

%Histogram Equalization Algorithm
histOrig = imhist(mat, 256);
cumHisto = cumsum(histOrig);

%normalize the cumulative histogram and multiply by maximal gray level value
pixels = dim(1)*dim(2);
normalizedCumHisto = (cumHisto/pixels);
maxPixel = max(normalizedCumHisto);
minPixel = min(normalizedCumHisto);

%strech to [0,255] range  if needed
if (maxPixel ~= minPixel)
    if ((minPixel ~= 0) || (maxPixel ~= 255))
    normalizedCumHisto = (normalizedCumHisto - minPixel) /(maxPixel-minPixel);
    end
end

%Maping the intensity values
imEq = normalizedCumHisto(im2uint8(mat) + 1);
histEq = imhist(imEq);

%in case originl picture was RGB
%replace Y in YIQ table than return to RGB
if mode == color
    YIQmat(:,:,1) = imEq;
    imEq = ntsc2rgb(YIQmat);
end

%show the given and equalized image 
figure; imshow(imOrig); title('Original Photo');
figure; imshow(imEq); title('Equalized Photo');
end