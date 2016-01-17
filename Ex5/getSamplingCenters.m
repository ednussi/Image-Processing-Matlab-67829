function [sampleCentersX,sampleCentersY,renderedPyramid] = getSamplingCenters( xCenters, ...
            yCenters, centersPyrLevel, pyr, levelsUp )
% GETSAMPLINGCENTERS Given 3 nearest neighbors for each patch of the input 
% image, from the patches DB, find the location of parent patch in the 
% rendered pyramid image 8
% Arguments:
% xCenters - (m - 4) ª (n - 4) ª 3 matrix with the x coordinates of the 
% closest patches (child patches) to each sampled patch from the image
% yCenters - (m - 4) ª (n - 4) ª 3 matrix with the y coordinates of the 
% closest patches (child patches) to each sampled patch from the image
% centersPyrLevel - (m - 4) ª (n - 4) ª 3 matrix with the levels of the 
% closest patches to each sampled patch from the image
% pyr - 7 ª 1 cell created using createPyramid
% levelsUp - integer which tells how much levels up we need to sample the 
% parent patch, from the found patch. In the figure the case is levelsUp=1.
% Outputs:
% sampleCentersX - (m - 4) ª (n - 4) ª 3 matrix with the x coordinates 
% of the center of the patches in the rendered image (the green points in 
% the figure)
% sampleCentersY - (m - 4) ª (n - 4) ª 3 matrix with the y coordinates of 
% the center of the patches in the rendered image (the green points in the 
% figure) renderedPyramid ? a single image containing all levels of the pyramid

% Render the pyramid into one large image
renderedPyramid = renderPyramidEx5(pyr);

% Find locations of the center of the coresponding parent patches
[sampleCentersX,sampleCentersY,levels] = transformPointsLevelsUp(xCenters,...
                                 yCenters,centersPyrLevel,pyr,levelsUp);
                             
% Finds the cumSum of cols to add each time
pyrSizes = cell2mat(cellfun(@size, pyr, 'UniformOutput', false));
cumSizes = cumsum(pyrSizes(:,2));

% Adds proper size to col
sampleCentersY = sampleCentersY + cumSizes(levels);

end