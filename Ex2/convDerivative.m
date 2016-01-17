function [magnitude] = convDerivative(inImage)
%convDerivative Compute the magnitude of image derivatives 
%   and displays the result.
%   Finding the derivatives of each direction seperatly
%   (rows & cols)using simple convolotion and using them to
%   compute the magnitude image.

%Constants
Y_DER_CONV_MAT = [1.0, 0.0, -1.0];
X_DER_CONV_MAT = Y_DER_CONV_MAT';

% Calculate the Derative for the y axis & x axis
yDerative = conv2(inImage, Y_DER_CONV_MAT, 'same');
xDerative = conv2(inImage, X_DER_CONV_MAT, 'same');

% Adds up derative to create the magnitude
magnitude = sqrt(yDerative.^2 + xDerative.^2);
figure; imshow(magnitude);

end

