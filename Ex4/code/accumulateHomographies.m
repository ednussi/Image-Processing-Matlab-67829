function [Htot] = accumulateHomographies(Hpair,m)
% ACCUMULATEHOMOGRAPHY Accumulate homography matrix sequence.
% Arguments:
% Hpair ? Cell array of M?1 3x3 homography matrices where Hpair{i} is a
% homography that transforms between coordinate systems i and i+1.
% m - Index of coordinate system we would like to accumulate the
% given homographies towards (see details below).
% Returns:
% Htot - Cell array of M 3x3 homography matrices where Htot{i} transforms
% coordinate system i to the coordinate system having the index m.
% Note:
% In this exercise homography matrices should always maintain
% the property that H(3,3)==1. This should be done by normalizing them as
% follows before using them to perform transformations H = H/H(3,3).

%% Args check
numOfHomographies = size(Hpair,1)+1;
if m > numOfHomographies
    error('Error: m must be int in the range bewteen 0 and size of Hpair.');
end

%% Create cell array Htot of proper size
Htot = cell(numOfHomographies,1);
Htot{m} = eye(3);  %initialize identity matrix for center image

%% Run on "left" side of cell Array to create Homographies
for i=m-1:-1:1
   unormalizedH = Hpair{i} * Htot{i + 1}; %change order?
   Htot{i} = unormalizedH/ unormalizedH(3,3); %normalize H
end

%% Run on "right" side of cell Array to create Homographies
for i=m+1:numOfHomographies
   unormalizedH = Htot{i - 1}/Hpair{i-1}; %Htot{i-1} * inv(Hpair{i-1})
   Htot{i} = unormalizedH/ unormalizedH(3,3); %normalize H
end

end