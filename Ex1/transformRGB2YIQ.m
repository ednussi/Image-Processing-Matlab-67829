function imYIQ = transformRGB2YIQ(imRGB)
% transformRGB2YIQ - Transform an RGB image to the ntsc (YIQ) format.
% args: imRGB - RGB image to transform.

%Coefficient matrix
cofMat = [0.299, 0.587, 0.114;
          0.596, -0.275, -0.321;
          0.212, -0.523, 0.311];

%Attain image dimensions
d = size(imRGB);
imWidth = d(1);
imHeight = d(2);

%Strip colors into components
Red = imRGB(:,:,1);
Green = imRGB(:,:,2);
Blue = imRGB(:,:,3);

RGB = [Red(:), Green(:), Blue(:)]'; %turn into a multipliable strip
YIQ = cofMat * RGB;

%reshape the matrix back from the strip and concat the 3 new layers
imYIQ = cat(3, reshape(YIQ(1,:),[imWidth,imHeight]), reshape(YIQ(2,:),[imWidth,imHeight]), reshape(YIQ(3,:),[imWidth,imHeight]));
 
end

