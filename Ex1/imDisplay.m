function imDisplay(filename, representation)
% imDisplay - Function which displays the output of the imReadAndConvert
% function
% args: filename - path of the RGB or grayscale image file.
%       representation - 1 for color, 2 for grayscale.

%Using imReadAndConvert function and throws error if caught 
try
    img = imReadAndConvert(filename, representation);
catch err
    error(err.message);
end

%Open in a new figure the converted image
figure; imshow(img);
impixelinfo;

end