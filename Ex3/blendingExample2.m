function blendingExample2
%BLENDINGEXAMPLE1 Example of belnding two images

% Constants
origin = im2double(imReadAndConvert('origin2.jpg',2));
back = im2double(imReadAndConvert('back2.jpg',2));
mask = imread('mask2.jpg');
maxLevels = 2;
filterSizeIm = 3;
filterSizeMask = 3;

% Seperate to the R,G,B channels
originR = origin(:,:,1); % Red channel
backR = back(:,:,1);
originG = origin(:,:,2); % Green channel
backG = back(:,:,2);
originB = origin(:,:,3); % Blue channel
backB = back(:,:,3);

% Blend each channel seperately
R = pyramidBlending(originR, backR, mask, maxLevels, filterSizeIm, filterSizeMask);
G = pyramidBlending(originG, backG, mask, maxLevels, filterSizeIm, filterSizeMask);
B = pyramidBlending(originB, backB, mask, maxLevels, filterSizeIm, filterSizeMask);

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

