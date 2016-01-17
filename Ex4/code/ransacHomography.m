function [H12,inliers] = ransacHomography(pos1,pos2,numIters,inlierTol)
% RANSACHOMOGRAPHY Fit homography to maximal inliers given point matches
% using the RANSAC algorithm.
% Arguments:
% pos1,pos2 - Two Nx2 matrices containing n rows of [x,y] coordinates of
% matched points.
% numIters - Number of RANSAC iterations to perform.
% inlierTol - inlier tolerance threshold.
% Returns:
% H12 - A 3x3 normalized homography matrix.
% inliers - A kx1 vector where k is the number of inliers, containing the 
% indices in pos1/pos2 of the maximal set of inlier matches found.


%Compute least square fit to homography transforming between two sets of points.

%% Check both pos sizes are Nx2
if size(pos1)~=size(pos2)
    error('Error: matrices of match points are not of the same size');
elseif (size(pos1,2)~= 2 || size(pos2,2)~=2)
    error('Error: matrices of size must be Nx2');   
end

largestMatch=0;
inliers=[];
%% Run Ransac numIters times to find largest match
for i=1:numIters

    % Randonmly pick 4 matches
    randomNums = randperm(size(pos1,1),4);
    
    % Create homography for those 4 pairs of matches
    singlePos1 = pos1(randomNums,:);
    singlePos2 = pos2(randomNums,:);
    curH12 = leastSquaresHomography(singlePos1,singlePos2);

    % Check homography is of correct size
    if ((size(curH12,1) ~= 3 && size(curH12,2) ~= 3) || (numel(curH12) == 0))
        continue;
    end

    % Calculate score of homography
    transformedPos1 = applyHomography(pos1,curH12);
    posDist = (transformedPos1 - pos2).^2;
    posDistErr = posDist(:,1) + posDist(:,2);  %E = ||P0-P2||^2 for each pxl
    binaryMatch = posDistErr < inlierTol; %Create binary of outliers and inliers
    
    % If curMatch is better update bestMatch score and inliers
    curMatch = sum(binaryMatch);
    if curMatch > largestMatch
        largestMatch = curMatch;
        inliers = find(binaryMatch);
    end    
end

% In case no inliers were found
if (sum(inliers) == 0)
    error('Error: Did not find any inliers, Please change parameters');
end

H12 = leastSquaresHomography(pos1(inliers',:),pos2(inliers',:));
end