function [weights] = weightsSetting( imPatches, Dists, pyr ,dbPatchesStd )
% WEIGHTSSETTING Given 3 nearest neighbors for each patch of the input image
% Find a threshold (maximum distance) for each input patch.
% Next, give a weight for each candidate based on its distance from the input 
% patch. denote m,n such that [m,n]=size(pyr{4})
% Arguments:
% imPatches ? (m ? 4) ª (n ? 4) ª 5 ª 5 matrix with the patches that were 
% sampled from the input image (pyr{4})
% Dists ? (m ? 4) ª (n ? 4) ª 3 matrix with the distances returned from 
% findNearestNeighbors.
% pyr ? 7 ª 1 cell created using createPyramid
% dbPatchesStd ? (m ? 4) ª (n ? 4) ª 3 matrix with the STDs of the neighbors
% patches returned from findNearestNeighbors.
% Outputs:
% weights ? (m ? 4) ª (n ? 4) ª 3 matrix with the weights for each DB candidates

%% Creates Patches of half size image in X and Y
[translatedX,translatedY] = translateImageHalfPixel(pyr{4});
[~, ~, MovedXpatches] = samplePatches(translatedX, 0);
[~, ~, MovedYpatches] = samplePatches(translatedY, 0);

% Find eculidian distances of orgiinal images to the moved patches
Xdist = sum(sum((imPatches - MovedXpatches).^2, 4),3).^0.5;
Ydist = sum(sum((imPatches - MovedYpatches).^2, 4),3).^0.5;
Thersholds = (Xdist+Ydist)./2;

%% Calculate Weight Matrix
weights = exp((-(Dists.^2)./dbPatchesStd));
weights(Dists(:,:,3) > Thersholds) = 0;

end