function blendingExample1
%BLENDINGEXAMPLE1 Example of belnding two images

% Constants
origin = im2double(imReadAndConvert('origin1.jpg',2));
back = im2double(imReadAndConvert('back1.jpg',2));
mask = imread('mask1.jpg');
maxLevels = 2;
filterSizeIm = 3;
filterSizeMask = 3;

% Seperate to the R,G,B channels
%originR = origin(:,:,1); % Red channel
backR = back(:,:,1);
%originG = origin(:,:,2); % Green channel
backG = back(:,:,2);
%originB = origin(:,:,3); % Blue channel
backB = back(:,:,3);

% Blend each channel seperately
R = pyramidBlending(origin, backR, mask, maxLevels, filterSizeIm, filterSizeMask);
G = pyramidBlending(origin, backG, mask, maxLevels, filterSizeIm, filterSizeMask);
B = pyramidBlending(origin, backB, mask, maxLevels, filterSizeIm, filterSizeMask);

% Blend channels back into 1 picture
blended = origin;
blended(:,:,1) = R;
blended(:,:,2) = G;
blended(:,:,3) = B;

%Show orignl picture, mask and blended img
figure; imshow(origin);
figure; imshow(back);
figure; imshow(mask);
figure; imshow(blended);
end

