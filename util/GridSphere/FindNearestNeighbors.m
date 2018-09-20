function nnIndices = FindNearestNeighbors(queryLatsInDegrees, ...
            queryLongsInDegrees, neighborLatsInDegrees, neighborLongsInDegrees)
% Finds the neighbor closest to each query point on the surface of a sphere.
% Returns a column vector containing indices into the neighbors. Assumes all
% inputs are column vectors with units of degrees. Assumes the neighbors are
% sorted in order of increasing latitude. Assumes ties between latitudes that
% differ only by floating point errors are broken by a secondary sort in order
% of increasing longitude. Assumes the neighbors are clustered along at least
% three lines of latitude. Furthermore, the clustering must be of such density
% that the nearest neighbor to any point lies either in the latitudinal cluster
% nearest that point or in those immediately bracketing said cluster. Assumes
% that for all lines of latitude containing more than one point, the least
% longitude is negative, and the greatest is positive. Geodesic grids produced
% by the icosahedron splitting algorithm of the GridSphere function satisfy all
% of these properties.
%
%    usage: nnIndices = FindNearestNeighbors(queryLatsInDegrees, ...
%            queryLongsInDegrees, neighborLatsInDegrees, neighborLongsInDegrees)

    [latListing, uniqueLatIndices] = RemoveEquals(neighborLatsInDegrees);
    % Create a listing of the unique latitudes sorted in increasing order.
    % uniqueLatIndices are the indices in neighborLatsInDegrees at which the
    % values in latListing are found. When there are multiple appearances of a
    % latitude in neighborLatsInDegrees, the lowest index is chosen.

    uniqueLatIndices = [uniqueLatIndices; NumElems(neighborLatsInDegrees) + 1];
    % Prevent indexing out of bounds by appending a final fence post to the list
    % of unique latitude indices.

    nearestLats = LookupNearestNeighbors(latListing, queryLatsInDegrees);
    % Get the index into uniqueLatIndices of the latitude closest to
    % queryLatsInDegrees. If there are multiple equal latitudes, then pick the
    % lowest corresponding index.

    numUniqueLats = NumElems(latListing);
    % Cache the number of unique lines of latitude.

    nearestLats(nearestLats == 1) = 2;
    nearestLats(nearestLats == numUniqueLats) = numUniqueLats - 1;
    % Prevent indexing out of bounds at the poles.

    nnIndices = ...
            FindNearestNeighborsWithinNearbyLatitudes(queryLatsInDegrees, ...
            queryLongsInDegrees, neighborLatsInDegrees, ...
            neighborLongsInDegrees, nearestLats, uniqueLatIndices);
    % Find each query's nearest neighbor. Because of the properties assumed
    % about the distribution of the neighbors, it is only necessary to search
    % the line of latitude nearest to the query and the two lines of latitude
    % sandwiching the first.

end
