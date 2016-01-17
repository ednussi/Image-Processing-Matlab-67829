function displayPyramid(pyr,levels)
%DISPLAYPYRAMID Display the given pyramid by levels
% Args
% pyr -  is either a Gaussian or Laplacian pyramid as defined above. 
% levels - is the number of levels to present in the result ? maxLevels.
figure; imshow(renderPyramid(pyr,levels));
end

