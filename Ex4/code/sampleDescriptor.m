function [desc] = sampleDescriptor(im,pos,descRad)
% SAMPLEDESCRIPTOR Sample a MOPS?like descriptor at given positions in the image.
% Arguments:
% im - nxm grayscale image to sample within.
% pos - A Nx2 matrix of [x,y] descriptor positions in im.
% descRad - ”Radius” of descriptors to compute (see below).
% Returns:
% desc - A kxkxN 3d matrix containing the ith descriptor
% at desc(:,:,i). The descriptor dimensions kxk are related to the
% descRad argument as follows k = 1+2*descRad.

%Initallize empty descriptor of proper size 
DEFAULT = 0.0001;
desc = zeros(descRad*2+1,descRad*2+1,size(pos,1));

for i=1:size(pos,1)
    
    %Seperate coordinates
    xVal = pos(i,1); yVal = pos(i,2);
    [Xcoords, Ycoords] = meshgrid(xVal-descRad:xVal+descRad,...
                                  yVal-descRad:yVal+descRad);
                              
    %Warp coordinates
    pointDesc = interp2(im ,Xcoords ,Ycoords);
    pointDesc(isnan(pointDesc)) = 0;
    
    %Normalize using the mean
    m = mean(pointDesc(:));
    if norm(pointDesc - m) == 0
        pointDesc(:) = DEFAULT;
    else
        pointDesc = (pointDesc - m) / norm(pointDesc - m);
    end
    desc(:,:,i) = pointDesc;
end

end
