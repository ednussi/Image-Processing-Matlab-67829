function pos2 = applyHomography(pos1,H12)
% APPLYHOMOGRAPHY Transform coordinates pos1 to pos2 using homography H12.
% Arguments:
% pos1 - An Nx2 matrix of [x,y] point coordinates per row.
% H12 - A 3x3 homography matrix.
% Returns:
% pos2 - An Nx2 matrix of [x,y] point coordinates per row obtained from
% transforming pos1 using H12.

%% Turn pos1 into Nx3 so each point will be represented as [x,y,1]'
onesCol = ones(size(pos1,1),1);
pos1 = [pos1, onesCol];

%% Multiplply and Normalize into new coordinates
newPos = (H12*pos1')';
pos2 = [newPos(:,1) ./ newPos(:,3), newPos(:,2) ./ newPos(:,3)]; % normalize

end