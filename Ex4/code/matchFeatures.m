function [ind1,ind2] = matchFeatures(desc1,desc2,minScore)
% MATCHFEATURES Match feature descriptors in desc1 and desc2.
% Arguments:
% desc1 - A kxkxn1 feature descriptor matrix.
% desc2 - A kxkxn2 feature descriptor matrix.
% minScore - Minimal match score between two descriptors required to be
% regarded as matching.
% Returns:
% ind1,ind2 - These are m-entry arrays of match indices in desc1 and desc2.
%
% Notes:
% 1. The descriptors of the ith match are 
%    desc1(ind1(:,:,i)) and desc2(ind2(:,:,i)).
% 2. The number of feature descriptors n1 generally differs from n2
% 3. ind1 and ind2 have the same length.

%% Reshape descriptors kXkXn1 into k^2Xn1
desc1 = reshape(desc1,size(desc1,1)*size(desc1,2),size(desc1,3)); 
desc2 = reshape(desc2,size(desc2,1)*size(desc2,2),size(desc2,3)); 

% Check all pairs and assign Score as the dot product
S = desc1' * desc2;

%% Match is considered good only if:
S1 = S; S2 = S; 

%Get cols maximas
colMaxVector = max(S,[],1); %row vector of maximas
maxMatrix = repmat(colMaxVector,size(S,1),1);
S(S == maxMatrix) = 0; %Initalize 1st maximas of cols to 0
colMaxVector = max(S,[],1); %row vector of 2nd maximas
maxMatrix = repmat(colMaxVector,size(S,1),1);
S(S == maxMatrix) = 0; %Initalize 2nd maximas of cols to 0
S = ~S; %Create binary map of 1st and 2nd maximas of cols

%Get rows maximas
rowMaxVector = max(S1,[],2); %col vector of maximas
maxMatrix = repmat(rowMaxVector,1,size(S1,2));
S1(S1 == maxMatrix) = 0; %Initalize 1st maximas of rows to 0
rowMaxVector = max(S1,[],2); %col vector of 2nd maximas
maxMatrix = repmat(rowMaxVector,1,size(S1,2));
S1(S1 == maxMatrix) = 0; %Initalize 2nd maximas of rows to 0
S1 = ~S1; %Create binary map of 1st and 2nd maximas of rows

S2(S2 > minScore) = 0; %Above minScore
S2 = ~S2; %Create binary map of all above minScore

% Find all relevant "Good" matches
secondBestMatches = S.*S1.*S2;
[ind1,ind2] = find(secondBestMatches);
end

