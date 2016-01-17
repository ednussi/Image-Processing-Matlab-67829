function [panorama] = renderPanorama(im,H)
% RENDERPANORAMA Renders a set of images into a combined panorama image.
% Arguments:
% im - Cell array of n grayscale images.
% H - Cell array of n 3x3 homography matrices transforming the ith image
% coordinates to the panorama image coordinates.
% Returns:
% panorama - A grayscale panorama image composed of n vertical strips that
% were backwarped each from the relevant frame im{i} using homography H{i}

%% Initialize empty corners cenetrs and borders arrays
numOfImages = size(im,1);
corners = zeros(4,2); 
Hcenters = zeros(numOfImages, 2);
edges = zeros(4, numOfImages);

% In case was given only 1 image
if numOfImages == 1
    panorama = im;
    return;
end

%% for each image run homography and find new edges and center
for i = 1:numOfImages
    
    % Find sizes of image
    [rowsSize, colsSize] = size(im{i});
    curHomography = H{i};
    
    % Find corners
    corners(1,:) = [1,1]; %left-bot
    corners(2,:) = [colsSize,1]; %left-top
    corners(3,:) = [1,rowsSize]; %right-bot
    corners(4,:) = [colsSize,rowsSize]; %right-top
    % Apply homography to corners
    Hcorners = applyHomography(corners, curHomography);
    
    % Find image centers
    centers(1) = (colsSize - 1)/2;
    centers(2) = (rowsSize - 1)/2;
    % Apply homography on center
    Hcenters(i,:) = applyHomography(centers, curHomography);
    
    % Find new edges of image
    % X values
    edges(1,i) = min(Hcorners(:,1)); % minX
    edges(2,i) = max(Hcorners(:,1)); % maxX
    % Y values
    edges(3,i) = min(Hcorners(:,2)); % minY
    edges(4,i) = max(Hcorners(:,2)); % maxY
end

%% Initialize empty panorma of proper size and all indices
[Xpano, Ypano] = meshgrid(min(edges(1,:)):max(edges(2,:)), ...
                          min(edges(3,:)):max(edges(4,:)));
[panoramaRowSize, panoramaColSize] = size(Xpano);
blendPano = zeros(panoramaRowSize, panoramaColSize);

%% Find boundries between pictures
for i = 1:(numOfImages-1)
    Boundary(i) = (Hcenters(i,1) + Hcenters(i+1,1))/2;
    Boundary(i) = Boundary(i) - min(edges(1,:));
end
Boundary = round(Boundary); %Rounds up all unWhole indices
Boundaries = [1, Boundary, panoramaColSize]';

%% Run on all parts of panorama
for i = 1:numOfImages   
    % Find current boundaries
    leftBoundary = Boundaries(i);
    rightBoundary = Boundaries(i+1); 
    
    % In each case take a bit more of other image for better belnding
    if i==1
        rightBoundary = rightBoundary + 20;
    elseif i==numOfImages
        leftBoundary = leftBoundary - 20;
    else
        rightBoundary = rightBoundary + 20;
        leftBoundary = leftBoundary - 20;
    end
    
    
    % Take boundaries from the panorama indices
    curX = Xpano(:, leftBoundary:rightBoundary);
    curY = Ypano(:, leftBoundary:rightBoundary);
    
    % Find new indices after applying inverse Homography
    curImg = cat(2, curX(:), curY(:));
    Hpos = applyHomography(curImg,inv(H{i}));
    xPan = Hpos(:,1);
    yPan = Hpos(:,2);
    xPan = reshape(xPan,panoramaRowSize,[]);
    yPan = reshape(yPan,panoramaRowSize,[]);
    
    %% Pyramid blending
    % Each run blend the current new image after Homography with 
    % the panorama image that was accmulated so far
    
    %Create temporary pano image for new image
    tempPano = zeros(panoramaRowSize, panoramaColSize);  
    
    % Find new indices of current image to tempPano
    tempPano(:,leftBoundary:rightBoundary) = ...
        interp2(im{i}, xPan, yPan, 'linear', 0);
                 
    % In case is first image just put it right in
    if i == 1
        blendPano = tempPano;
        continue;
    end
    
    %% Pads panoramas for blending to work properly
    newPanoramaRowSize = power(2, nextpow2(panoramaRowSize));
    newPanoramaColSize = power(2, nextpow2(panoramaColSize));
    % Pads right side if needed
    if newPanoramaRowSize > panoramaRowSize
        tempPano = [tempPano, zeros(size(tempPano, 1),...
                                    newPanoramaRowSize - panoramaRowSize)];
        blendPano = [blendPano, zeros(size(blendPano, 1),...
                                    newPanoramaRowSize - panoramaRowSize)];
    end
    % Pads top if needed
    if newPanoramaColSize > panoramaColSize
        tempPano = [tempPano; zeros(newPanoramaColSize - panoramaColSize,...
                                      size(tempPano, 2))];
        blendPano = [blendPano; zeros(newPanoramaColSize - panoramaColSize,...
                                      size(blendPano, 2))];
    end
    
    %% Create mask of proper size
    mask = ones(size(blendPano));
    blackIndicesStart = find(Xpano(1,:) == Boundaries(i));
    blackIndicesEnd = find(Xpano(1,:) == Boundaries(i+1));
    mask(:,Boundaries(i):Boundaries(i+1)) = 0;
    
    %% Actually do the pyramid blending of the two parts and cut leftovers
    blendPano = pyramidBlending(blendPano, tempPano, mask, 7, 9, 9);
    blendPano = blendPano(1:panoramaRowSize, 1:panoramaColSize);
end
panorama = blendPano;

end