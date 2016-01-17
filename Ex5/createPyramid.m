function [pyr] = createPyramid(im)
% CREATEPYRAMID Create a pyramid from the input image, where pyr{1} 
% is the smallest level, pyr{4} is the input image, 
% and pyr{5},pyr{6},pyr{7} are zeros.
% The ratio between two adjacent levels in the pyramid is 2(1/3)
% Arguments:
% im ? a grayscale image
% outputs:
% pyr ? A 7 ª 1 cell of matrices.

%% Constants
scale = 2^(1/3); %Constant Third root of 2
imSize = size(im);

%% Creates pyr
pyr = cell(7,1);
temp = zeros(imSize); 
pyr{7} = imresize(temp, scale^3);
pyr{6} = imresize(temp, scale^2);
pyr{5} = imresize(temp, scale);
pyr{4} = im;
pyr{3} = imresize(im, scale^(-1));
pyr{2} = imresize(im, scale^(-2));
pyr{1} = imresize(im, scale^(-3));
end

