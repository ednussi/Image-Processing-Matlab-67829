function displayMatches(im1,im2,pos1,pos2,inliers)
% DISPLAYMATCHES Display matched pt. pairs overlayed on given image pair.
% Arguments:
% im1,im2 ? two grayscale images
% pos1,pos2 ? Nx2 matrices containing n rows of [x,y] coordinates of matched
% points in im1 and im2 (i.e. the i’th match’s coordinate is
% pos1(i,:) in im1 and and pos2(i,:) in im2).
% inliers - A kx1 vector of inlier matches (e.g. see output of
% ransacHomography.m)

%% Concut the two images together
[row1,col1] = size(im1); [row2,col2] = size(im2);
if row1 ~= row2 
    %In case pictures are not of same dimesnion to concat
    if row1 < row2
       im1expand = zeros(row2,col1);
       im1expand(1:row1,:) = im1;
       concatImgs = cat(2,im1expand,im2);
    else
       im2expand = zeros(row1,col2);
       im2expand(1:row2,:) = im2;
       concatImgs = cat(2,im1,im2expand);
    end
else
    concatImgs = [im1,im2];
end
% Updates Shifted pos2 indxs
pos2(:,1) = pos2(:,1) + col1;

%% Plotting
figure; imshow(concatImgs); 
hold on;

%Plot feature points as red dots
plot(pos1(:,1),pos1(:,2),'r.');
plot(pos2(:,1),pos2(:,2),'r.');

% Plots blue lines between outliers and yellow lines between inliers
for i = 1:size(pos1,1)
    if ~isempty(find(inliers == i, 1)) 
        % Plot inliers
        plot([pos1(i,1),pos2(i,1)], [pos1(i,2),pos2(i,2)], 'y-');
    else
        % Plot outliers
        plot([pos1(i,1),pos2(i,1)], [pos1(i,2),pos2(i,2)], 'b-');
    end
end

hold off;


end
