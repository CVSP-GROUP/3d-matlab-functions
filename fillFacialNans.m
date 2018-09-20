function keypoints = fillFacialNans( keypoints, numIter )
% Fill missing facial keypoints by repeatedly fitting missing values through
% least squares on all other facial keypoints. Initial values are taken from
% mean of non-missing values, with added gaussian noise of 1 std.
%
% Inputs:
%  keypoints: N x 54, 3D positions of 18 keypoints of COCO,
%             [X0, Y0, Z0, X1, Y1, Z1 , ..., X17, Y17, Z17]
%  numIter (optional): number of iterations for least squares. Default: 500
%
% Outputs:
%  

if nargin < 2
    numIter = 500;
end

numSamples = size(keypoints, 2);
numFeatures = 15;

facialKeypoints = keypoints(:, [1:3, 14*3+1:end]);
facialKeypoints(facialKeypoints==0) = nan;

nanInd = isnan(facialKeypoints);
for col = 1:numFeatures
    m = mean(facialKeypoints(~nanInd(:,col),col));
    s = randn(1,1) * var(facialKeypoints(~nanInd(:,col),col));
    facialKeypoints(nanInd(:,col),col) = m + s;
end
a = [facialKeypoints(1,end-3),facialKeypoints(60,3),facialKeypoints(700,end)];
for iter = 1:numIter
    for col = 1:numFeatures
        A1 = ones(sum(~nanInd(:,col)), 1);
        A2 = facialKeypoints(~nanInd(:,col),[1:col-1,col+1:end]);
        A = [A1, A2];
        y = facialKeypoints(~nanInd(:,col), col);
        b = A\y;
        temp1 = ones(sum(nanInd(:,col)),1);
        temp2 = facialKeypoints(nanInd(:,col),[1:col-1,col+1:end]);
        facialKeypoints(nanInd(:,col),col) = [temp1, temp2]*b;
    end
    a=[a;facialKeypoints(1,51),facialKeypoints(60,3),facialKeypoints(700,end)];
end

keypoints(:,[1:3,14*3+1:end]) = facialKeypoints;

end

