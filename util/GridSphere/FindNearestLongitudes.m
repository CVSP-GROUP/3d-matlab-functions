function nearestLongitudes = FindNearestLongitudes(queryLongInDegrees, ...
                neighborLongsInDegrees, lineOfLatStarts)
% Finds the indices of the neighbors nearest to the query in longitude.
% Returns a column vector containing indices into the neighbors. Assumes that
% numLinesOfLatToSearch is a scalar and all other inputs are column vectors.
% Assumes that all coordinates are given in degrees. Assumes the neighbors are
% sorted in order of increasing latitude. Assumes ties between latitudes that
% differ only by floating point errors are broken by a secondary sort in order
% of increasing longitude. Assumes that for all lines of latitude containing
% more than one point, the least longitude is negative, and the greatest is
% positive. Geodesic grids produced by the icosahedron splitting algorithm of
% the GridSphere function satisfy all of these properties. lineOfLatStarts
% contain the indices into neighborLongsInDegrees of the first neighbor in each
% line of latitude to search. lineOfLatStarts also contains an extra element at
% the end with value 1 greater than the end of the last line of latitude to
% prevent indexing out of bounds.
%
%    usage: nearestLongitudes = FindNearestLongitudes(queryLongInDegrees, ...
%                neighborLongsInDegrees, numLinesOfLatToSearch, lineOfLatStarts)

    DEGREES_IN_A_CIRCLE = 360;
    % The number of a degrees in a full circle.

    numLinesOfLatToSearch = numel(lineOfLatStarts) - 1;
    % The number of lines of latitude to search is one less than the number of
    % elements in lineOfLatStarts because of the extra element that has been
    % appended to prevent indexing out of bounds.

    nearestLongitudes = zeros(numLinesOfLatToSearch, 1, 'uint32');
    % Initialze the result matrix up front to optimize the loop.

    for currLatIndex = 1:numLinesOfLatToSearch

        lineOfLat = RangeToNext(lineOfLatStarts, currLatIndex);
        % Lookup the indices of all neighbors on the current line of latitude.

        longsAtLineOfLatInDegrees = neighborLongsInDegrees(lineOfLat);
        % Lookup the longitudes of all neighbors on the current line of
        % latitude.

        nearestLongitudes(currLatIndex) = ...
                            LookupNearestNeighbor(longsAtLineOfLatInDegrees, ...
                            queryLongInDegrees);
        % At the current line of latitude, find the neighbor with the closest
        % longitude to the query.

        if (nearestLongitudes(currLatIndex) == 0)
        % Handle the case where the query's longitude is outside the range of
        % the longitudes at the current line of latitude.

            if ((2 * queryLongInDegrees - ...
                    (sign(queryLongInDegrees) * DEGREES_IN_A_CIRCLE)) > ...
                    sum(longsAtLineOfLatInDegrees([1, ...
                    NumElems(longsAtLineOfLatInDegrees)])))
            % Whether the query's longitude is less than the least longitude or
            % greater than the greatest longitude at the current line of
            % latitude, this expression is true if and only if the query's
            % longitude is closer to the least longitude (after accounting for
            % the circular nature of longitudes). This assumes that the least
            % longitude is always negative, and the greatest longitude is always
            % positive, so that the two cases can be handled by checking the
            % sign of the query's longitude.

                nearestLongitudes(currLatIndex) = 1;
                % The query's longitude is closest to the least longitude in the
                % list.

            else

                nearestLongitudes(currLatIndex) = ...
                                            NumElems(longsAtLineOfLatInDegrees);
                % The query's longitude is closest to the greatest longitude in
                % the list.

            end

        end

    end

    nearestLongitudes = nearestLongitudes + ...
                                lineOfLatStarts(1:numLinesOfLatToSearch) - 1;
    % Offset the indices of the points with the nearest longitudes to the query
    % within their respective lines of latitude by the first index from their
    % respective lines of latitude. Subtract 1 because indices start from 1
    % rather than 0.

end
