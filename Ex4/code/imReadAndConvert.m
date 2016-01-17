function im = imReadAndConvert(filename, representation)
% imReadAndConvert - Reads an image file and convert it according to user
% choice. Converation from grayscale to color is unavialable
% args: filename - path of the RGB or grayscale image file.
%       representation - 1 for color, 2 for grayscale.

%checks if files exists
if ~exist(filename, 'file')
    error('Warning: file does not exist:\n%s', filename);
end

%checks if file is a picture?
try
    imgInfo = imfinfo(filename);
catch
    error('File is not an image');
end

im = im2double(imread(filename));

grayscale = 1;
colors = 2;

if representation == grayscale
    if strcmp(imgInfo.ColorType, 'truecolor')
        im = rgb2gray(im);
    end
else
    if representation == colors
        if strcmp(imgInfo.ColorType, 'grayscale')
            error('Warning: grayscale to colors is not available');
        end
    else
        error('Warning: representation choice unknown. Please chose 1 for grayscale or 2 for rgb');
    end
end

end