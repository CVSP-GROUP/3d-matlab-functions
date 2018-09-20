function Y = interpolateMissingDetections( X )
% Interpolate -1 values, but only using previous values. Initial values are
% set from first available value.
%
% Inputs:
%  X: N X 3, where N is number of frames

windowSize = 15;
padding = zeros(windowSize, 3);

X(isnan(X)) = 0;

missing = X(:,3) == 0;
missingTotals = cumsum(missing);
numMissing = missingTotals(windowSize+1:end) - missingTotals(1:end-windowSize);
numMissing = [padding(:,1); numMissing];

C = cumsum(X);
runningSum = C(windowSize+1:end,:) - C(1:end-windowSize,:);
runningSum = [padding; runningSum];
runningAvg = runningSum./repmat(windowSize-numMissing, 1, 3);

Y=runningAvg;
Y(isnan(Y)) = 0;
lastValid = [nan,nan,nan];
for i = 1:length(X)
    if Y(i,3) == 0
        if isnan(lastValid(3))
            temp = Y(Y(:,3)~=0,:);
            Y(i,:) = temp(1,:);
        else
            Y(i,:) = lastValid;
        end
    else
        lastValid = Y(i,:);
    end
end


end

