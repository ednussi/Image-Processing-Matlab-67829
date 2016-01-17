function [p_x, p_y,levels, patches] = createDB(pyr)
% CREATEDB Sample 5 ª 5 patches from levels 1,2,3 of the input pyramid.
% N represents the number of patches that are found in the three images.
% Arguments:
% pyr ? 7 ª 1 cell created using createPyramid
% Outputs:
% p x ? N ª 1 vector with the x coordinates of the centers of the patches in the DB
% p y ? N ª 1 vector with the y coordinates of the centers of the patches in the DB
% levels ? N ª 1 vector with the pyramid levels where each patch was sampled
% patches ? N ª 5 ª 5 the patches

%% Finds N size
border = 2; %Given Constant
[pyr1Rows,pyr1Cols] = size(pyr{1});
[pyr2Rows,pyr2Cols] = size(pyr{2});
[pyr3Rows,pyr3Cols] = size(pyr{3});
pyrNumOfPatches = cell(3,1);
pyrNumOfPatches{1} = (pyr1Rows-2*(2+border))*(pyr1Cols-2*(2+border));
pyrNumOfPatches{2} = (pyr2Rows-2*(2+border))*(pyr2Cols-2*(2+border));
pyrNumOfPatches{3} = (pyr3Rows-2*(2+border))*(pyr3Cols-2*(2+border));
N = pyrNumOfPatches{1} + pyrNumOfPatches{2} + pyrNumOfPatches{3};

%% Initialize parameters
p_x = zeros(N,1);
p_y = zeros(N,1);
levels = zeros(N,1);
patches = zeros(N,5,5);

%% For each pyramid
curPos = 1;
for pyrmLevel=1:3
    %% Set current parameters
    curPyr = pyr{pyrmLevel};
    curPyrNumOfPatches = pyrNumOfPatches{pyrmLevel};
    [curPx,curPy,curPatches] = samplePatches(curPyr, border);
    curN = curPos:(curPos + curPyrNumOfPatches - 1);
    
    %% Insert current pyramid info
    p_x(curN) = reshape(curPx,curPyrNumOfPatches,1); % X coords
    p_y(curN) = reshape(curPy,curPyrNumOfPatches,1); % Y coords
    patches(curN,:,:) = reshape(curPatches,curPyrNumOfPatches,5,5); % Patches
    levels(curN) = pyrmLevel;
    
    %% Update for next loop
    curPos = curPos + curPyrNumOfPatches;
end 
