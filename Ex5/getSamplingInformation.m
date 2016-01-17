function [assignmentPositionsX,assignmentPositionsY,...
          samplingPositionsX,samplingPositionsY] = getSamplingInformation(sampleCentersX,...
          sampleCentersY,pyr,inputPatchesCentersX,inputPatchesCentersY,levelsUp)
% GETSAMPLINGINFORMATION % Get the information for sampling a high resolution 
% image. Pairs of: assignment positions in the high resolution image,
% and sampling positions from the rendered pyramid image
% Arguments:
% sampleCentersX ? (m ? 4) ª (n ? 4) ª 3 matrix with the x coordinates of 
% the center of the high resolution patches in the rendered image. This variable
% should be returned from getSamplingCenters function. (green x locations)
% sampleCentersY ? (m ? 4) ª (n ? 4) ª 3 matrix with the y coordinates of the 
% center of the high resolution patches in the rendered image. his variable 
% should be returned from getSamplingCenters function. (green y locations).
% pyr ? 7 ª 1 cell created using createPyramid
% inputPatchesCentersX ? (m ? 4) ª (n ? 4) input patches center x coordinates
% inputPatchesCentersY ? (m ? 4) ª (n ? 4) input patches center y coordinates
% levelsUp ? integer which tells how much levels up we need to sample the 
% window, from the found patch. In the figure the case is levelsUp=1
% Outputs:
% assignmentPositionsX ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 x assignment coordinates 
% in the high resolution image (see figure)
% assignmentPositionsY ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 y assignment coordinates 
% in the high resolution image (see figure)
% samplingPositionsX ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 x sampling coordinates in 
% the rendered pyramid image (see figure)
% samplingPositionsY ? (m ? 4) ª (n ? 4) ª 3 ª 5 ª 5 y sampling coordinates in 
% the rendered pyramid image (see figure)

%% Creates the assignment positions
% Find locations of the center of the coresponding parent patches
[upPixelX, upPixelY] = transformPointsLevelsUp(inputPatchesCentersX,...
                                 inputPatchesCentersY,centersPyrLevel,pyr,levelsUp);

% Rounds up to integer the coordinates
upPixelX = round(upPixelX); %MxNxK
upPixelY = round(upPixelY);

% Copies each index to 5x5 mat
upPixelX = repmat(upPixelX,1,1,5,5); %MxNx5x5
upPixelY = repmat(upPixelY,1,1,5,5);

% Creates 5x5 meshgrids of surroundings
[patchSurroundX, patchSurroundY] = meshgrid(-2:2,-2:2); % to add to center
patchSurroundX = reshpae(1,1,5,5);
patchSurroundY = reshpae(1,1,5,5);
patchSurroundX = repmat(patchSurroundX,size(upPixelX,1),size(upPixelX,2));
patchSurroundY = repmat(patchSurroundY,size(upPixelY,1),size(upPixelY,2));

% Adds the surrounding to create 5x5 indices of patch
assignmentPositionsX = upPixelX + patchSurroundX;
assignmentPositionsY = upPixelY + patchSurroundY;

%Copy 3 times and permute to proper size
assignmentPositionsX = repmat(assignmentPositionsX,1,1,1,1,3);
assignmentPositionsY = repmat(assignmentPositionsY,1,1,1,1,3);
assignmentPositionsX = permute(assignmentPositionsX, [1,2,5,3,4]);
assignmentPositionsY = permute(assignmentPositionsY, [1,2,5,3,4]);

%% Create the Sampling Positions
% Copy 3 times and permute in order to become MxNx3x5x5
upPixelX = repmat(upPixelX,1,1,1,1,3);
upPixelY = repmat(upPixelY,1,1,1,1,3);
upPixelX = permute(upPixelX, [1,2,5,3,4]); %MxNx3x5x5
upPixelY = permute(upPixelY, [1,2,5,3,4]);

% Copy 5x5 times the centers
sampleCentersX = repmat(sampleCentersX,1,1,1,5,5); %TODO??
sampleCentersY = repmat(sampleCentersY,1,1,1,5,5);

% Creates the sampling postions
samplingPositionsX = assignmentPositionsX - upPixelX + sampleCentersX;
samplingPositionsY = assignmentPositionsY - upPixelY + sampleCentersY;

end