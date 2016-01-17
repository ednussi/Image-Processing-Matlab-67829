function [maxLevels] = findMaxLevel(smallDim, maxLevels)
% Calc the max number of levels - min between input and times untill
% your reach to minimal level.
power2Vec = 2.^(0:maxLevels);
minimalDivdedSizeDimnesion = ones(1, maxLevels + 1) .* smallDim ./ power2Vec;
validLevels = minimalDivdedSizeDimnesion >= 16;
maxLevels = min(maxLevels, numel(find(validLevels == 1)));
end

