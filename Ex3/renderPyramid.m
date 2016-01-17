function [res] = renderPyramid(pyr,levels)
%RENDERPYRAMID render a pyramid to show in one image
% Strech values to [0,1] and insert them into a long strip
% Args
% pyr -  is either a Gaussian or Laplacian pyramid as defined above. 
% levels - is the number of levels to present in the result ? maxLevels.
% Return
% res -  is a single black image in which the pyramid levels of
% the given pyramid pyr are stacked horizontally 
% (after stretching the values to [0,1]).

% Levels size check
if levels > size(pyr,1)
    error('Error: levels Requested is larger than the pyrm conatins');
end

% Calc the dimensions of the res table
[lvl1RowSize, lvl1ColSize] = size(pyr{1});
colDim = lvl1ColSize*(0.5^levels -1)/(-0.5); %assumimg is power of 2
if colDim ~= round(colDim)
    error('Error: Pyramids image columns are not powers of 2');
end
res = zeros(lvl1RowSize,colDim);

% Run on level strech and add each one
startInsertRow = 1;
startInsertCol = 1;
for i=1:levels
    %Strech values to [0:1]
    [curRowSize, curColSize] = size(pyr{i});
    minVal = min(min(pyr{i}));
    maxVal = max(max(pyr{i}));
    if maxVal ~= minVal %In case not mono colored photo
        pyr{i} = (pyr{i} - minVal)/(maxVal-minVal);
    end
    
    %insert to res
    res(startInsertRow:startInsertRow+curRowSize-1,...
        startInsertCol:startInsertCol+curColSize-1) = pyr{i};
    
    %update starting vals
    startInsertCol = startInsertCol + curColSize;
    
end

end

