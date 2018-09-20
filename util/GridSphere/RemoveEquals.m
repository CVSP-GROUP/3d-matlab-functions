function [uniqueVals, uniqueIndices] = RemoveEquals(values)
% Return only the unique elements of values.
% Assumes values is a sorted column vector of type double. The first output,
% uniqueVals is a sorted column vector of type double containing the unique
% elements of values. The second output, uniqueIndices, is a column vector of
% doubles containing the lowest index at which the unique values appear in
% values.
%
%    usage: [uniqueVals, uniqueIndices] = RemoveEquals(values)

    uniqueIndices = DistinctFromPrevious(values);
    % Find the lowest index at which each unique value appears in values.

    uniqueVals = values(uniqueIndices);
    % Populate uniqueVals with the unique values of values.

end
