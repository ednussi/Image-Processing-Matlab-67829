function imRGB = transformYIQ2RGB(imYIQ)
% transformRGB2YIQ - Transform an ntsc (YIQ) image to the RGB format.
% args: imYIQ - YIQ image to transform.

%Coefficient matrix
cofMat = [0.299, 0.587, 0.114; 
          0.596, -0.275, -0.321; 
          0.212, -0.523, 0.311];

%Attain image dimensions
d = size(imYIQ);
imWidth = d(1);
imHeight = d(2);

%Strip colors into components
Lumi = imYIQ(:,:,1);
ChromI = imYIQ(:,:,2);
ChromQ = imYIQ(:,:,3);

YIQ = [Lumi(:), ChromI(:), ChromQ(:)]'; %turn into a multipliable strip
RGB = cofMat \ YIQ;

%reshape the matrix back from the strip and concat the 3 new layers
imRGB = cat(3, reshape(RGB(1,:),[imWidth,imHeight]), reshape(RGB(2,:),[imWidth,imHeight]), reshape(RGB(3,:),[imWidth,imHeight]));
 
end