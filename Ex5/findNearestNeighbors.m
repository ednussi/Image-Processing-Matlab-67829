function [idx,Dist] = findNearestNeighbors(imPatches,dbPatches)
% FINDNEARESTNEIGHBORS Find the 3 nearest neighbors for each patch in the 
% input images from the patches in the DB
% N represents the number of patches in the DB, and M represents the 
% number of patches in the input image.
% Arguments:
% imPatches - M ª 5 ª 5 matrix with M patches that were sampled from the 
% input image (pyr{4}) 
% dbPatches - N ª 5 ª 5 matrix with N db patches
% Outputs:
% idx - M ª 3 matrix where the ith row has 3 indices of the
% 3 patches in the db that are most similar to the ith patch
% from the input image
% Dist- M ª 3 matrix where the ith row contains the euclidean 
% distances between the best 3 patches that has been
% found for the ith patch
tic;
reshapedDB = reshape(dbPatches, size(dbPatches,1), 25);
reshapedImPatches = reshape(imPatches, size(imPatches,1), 25);
[idx, Dist] = knnsearch(reshapedDB, reshapedImPatches,'K', 3);
toc;
end