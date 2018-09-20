function nnIndices = ...
            FindNearestNeighborsWithinNearbyLatitudes(queryLatsInDegrees, ...
            queryLongsInDegrees, neighborLatsInDegrees, ...
            neighborLongsInDegrees, nearestLats, uniqueLatIndices)
% Finds the neighbor closest to each query point on the surface of a sphere.
% Returns a column vector containing indices into the neighbors. Assumes all
% inputs are column vectors and that all coordinates are given in degrees.
% Assumes the neighbors are sorted in order of increasing latitude. Assumes ties
% between latitudes that differ only by floating point errors are broken by a
% secondary sort in order of increasing longitude. Assumes the neighbors are
% clustered along at least three lines of latitude. Furthermore, the clustering
% must be of such density that the nearest neighbor to any point lies either in
% the latitudinal cluster nearest that point or in those immediately bracketing
% said cluster. Assumes that for all lines of latitude containing more than one
% point, the least longitude is negative, and the greatest is positive. Geodesic
% grids produced by the icosahedron splitting algorithm of the GridSphere
% function satisfy all of these properties. nearestLats contain the indices into
% uniqueLatIndices of the line of latitude closest to each query.
% uniqueLatIndices contain the indices into neighborLatsInDegrees of the first
% instance of each latitude along with an extra element at the end with value
% NumElems(neighborLatsInDegrees) + 1 to prevent indexing out of bounds.
%
%    usage: nnIndices = ...
%            FindNearestNeighborsWithinNearbyLatitudes(queryLatsInDegrees, ...
%            queryLongsInDegrees, neighborLatsInDegrees, ...
%            neighborLongsInDegrees, nearestLats, uniqueLatIndices)

    NUM_LINES_OF_LAT_TO_SEARCH = 3;
    % The total number of lines of latitude to search for the nearest neighbor
    % to point. The specific latitudes chosen are that closest to the neighbor,
    % and the two bracketing the first.

    OFFSET_TO_FURTHEST_LINE_OF_LAT_TO_SEARCH = 0.5 * ...
                                            (NUM_LINES_OF_LAT_TO_SEARCH - 1);
    % The positive offset of the index in nearestLats between the line of
    % latitude with the least (or greatest) latitude of those to search for a
    % given point relative to the line of latitude closest to the query point.

    numQueries = numel(queryLatsInDegrees);
    resultSize = [NUM_LINES_OF_LAT_TO_SEARCH, numQueries];
    % Cache values.

    toSearch = zeros(resultSize, 'uint32');
    distancesInRadians = zeros(resultSize, 'double');
    % Optimize loop by initializing the result arrays up front.

    for queryIndex = 1:numQueries

        currQueryLongInDegrees = queryLongsInDegrees(queryIndex);
        % Lookup the current query's longitude.

        nearestLatIndex = nearestLats(queryIndex);
        % Lookup the index into uniqueLatIndices of the latitude nearest the
        % current query's.

        lineOfLatStarts = uniqueLatIndices((nearestLatIndex - ...
                OFFSET_TO_FURTHEST_LINE_OF_LAT_TO_SEARCH):(nearestLatIndex + ...
                OFFSET_TO_FURTHEST_LINE_OF_LAT_TO_SEARCH + 1));
        % Lookup the indices into the neighbors of the start of each of the
        % lines of latitude sandwiching the current query. The start of one
        % extra line is added to mark the end of the final line to be searched.

        nearestLongitudes = ...
                        FindNearestLongitudes(currQueryLongInDegrees, ...
                        neighborLongsInDegrees, lineOfLatStarts);
        % Within each of the latitdues sandwiching the current query, find the
        % neighbor nearest to the query in longitude.

        toSearch(:, queryIndex) = nearestLongitudes;
        % Record the indices of the candidate nearest neighbors for reference
        % outside the loop.

        distancesInRadians(:, queryIndex) = ...
                        GreatCircleDistance(queryLatsInDegrees(queryIndex), ...
                        currQueryLongInDegrees, ...
                        neighborLatsInDegrees(nearestLongitudes), ...
                        neighborLongsInDegrees(nearestLongitudes));
        % Calculate the distance from the query to each of the candidate nearest
        % neighbors.

    end

    [minDistancesInRadians, minIndices] = min(distancesInRadians);
    % Find the neighbors closest to the queries.

    nnIndices = toSearch(sub2ind(resultSize, minIndices, 1:numQueries))';
    % Convert the indices into distancesInRadians into a column vector of
    % indices into the queries.

end
