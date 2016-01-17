function [pos] = HarrisCornerDetector(im)
%HARRISCORNERDETECTOR Extract key points from the image
% Args:
% im - grayscale image to find key points inside
% Return:
% pos - a Nx2 matrix of [x,y] key points positions in im

%% Get the Ix and Iy derivatives of the image using
% [1 0 -1] and [1; 0; -1] kernels respectively
X_DERIVATIVE_KERNEL = [1 0 -1];
Y_DERIVATIVE_KERNEL = X_DERIVATIVE_KERNEL';
Ix = conv2(im, X_DERIVATIVE_KERNEL, 'same');
Iy = conv2(im, Y_DERIVATIVE_KERNEL, 'same');

%% Blurs the images Ix^2, Iy^2, IxIy
BLUR_KERNEL_SIZE = 3;
IxIy = blurInImageSpace(Ix.*Iy, BLUR_KERNEL_SIZE);
Iy2 = blurInImageSpace(Iy.^2, BLUR_KERNEL_SIZE); 
Ix2 = blurInImageSpace(Ix.^2, BLUR_KERNEL_SIZE);

%% Calculate R - Mesuring how big are the two eigenvalues of M are
% M = [Ix2, IxIy; IxIy, Iy2]     - for each pixel
% R =  det(M) -k*(trace(M))^2    - for each pixel
k = 0.04;
R = Ix2.*Iy2-IxIy.^2 -k*(Ix2+Iy2).^2; 

%% Using non Maximum Suppression algortihem finds maximums
localMaximumPoints = nonMaximumSuppression(R);
[row,col] = find(localMaximumPoints);
pos = [col,row]; %Put in to table


%figure; imshow(im); hold on;
%plot(col,row,'r.');
%hold off;

end

