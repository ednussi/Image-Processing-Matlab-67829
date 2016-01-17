function [p_x, p_y, patches] = samplePatches(im,border)
% SAMPLEPATCHES Sample 5 ª 5 patches from the input image. 
% You are allowed to use 2D loops here.
% Arguments:
% im - a grayscale image of size m ª n
% border ? An integer that determines how much border we want to leave in 
% the image. For example: if border=0 the center of the first patch will 
% be at (3,3), and the last one will be at (end?2,end?2), so the number 
% of patches in this case is (m - 4) ª (n ? 4). But if border=1 the center
% of the first patch will be at (4,4) and the last one will be at 
% (end:3,end:3). So in general, the number of patches is 
% (m - 2 · (2 + border)) ª (n ? 2 · (2 + border)).
% outputs:
% p_x - (m - 2 · (2 + border)) ª (n - 2 · (2 + border)) 
% matrix with the x indices of the centers of the patches
% p_y - (m - 2 · (2 + border)) ª (n - 2 · (2 + border)) 
% matrix with the y indices of the centers of the patches
% patches - (m - 2 · (2 + border)) ª (n - 2 · (2 + border)) ª 5 ª 5 the patches

%% Initialize Parameters
[rowSize, colSize] = size(im);
XSize = rowSize-2*(2+border);
YSize = colSize-2*(2+border);
patches = zeros(XSize,YSize,5,5);
p_x = zeros(XSize,YSize);
p_y = zeros(XSize,YSize);

%% Run on all cenetrs of patches - save their x,y coordinate and the patches
for row = 1+2+border:rowSize-border-2
    for  col = 1+2+border:colSize-border-2
        curRow = row-2-border;
        curCol = col-2-border;
        % Save the x,y from original image and the patch itself
        p_x(curRow, curCol) = row;
        p_y(curRow, curCol) = col;
        patches(curRow, curCol,:,:) = im(curRow:curRow+4, curCol:curCol+4);
    end
end


end