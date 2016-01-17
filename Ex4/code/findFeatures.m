function [pos,desc] = findFeatures(pyr)
% FINDFEATURES Detect feature points in pyramid and sample their descriptors.
% This function should call the functions spreadOutCorners for getting the keypoints, and
% sampleDescriptor for sampling a descriptor for each keypoint
% Arguments:
% pyr - Gaussian pyramid of a grayscale image having 3 levels.
% Returns:
% pos - An Nx2 matrix of [x,y] feature positions per row found in pyr. These
% coordinates are provided at the pyramid level pyr{1}.
% desc - A kxkxN feature descriptor matrix.

% Constants
VerticalSubImg = 7;
HorizSubImg = 7;
radius = 3;
descRad = 3;

% Find the keypoints and extract descriptors
pos = spreadOutCorners(pyr{1}, VerticalSubImg, HorizSubImg, radius);

pos3L = ((pos-1)./ 4) + 1; %3rd level
desc = sampleDescriptor(pyr{3}, pos3L, descRad);
desc(isnan(desc)) = 0;

end
