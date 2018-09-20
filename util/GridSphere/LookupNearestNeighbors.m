function indicesOfNearest = LookupNearestNeighbors(neighbors, queries)
% Returns the indices of the nearest neighbors to the given queries.
% Returns 1 for queries less than the least neighbor, and returns
% NumElems(neighbors) for queries greater than the greatest neighbor. Selects
% the neighbor with the lowest index in the event of a tie. Assumes neighbors is
% nonempty and strictly monotonically increasing. Assumes neighbors and queries
% have the same dimensions.
%
%    usage: indicesOfNearest = LookupNearestNeighbors(neighbors, queries)

    [lh, rh] = LookupNeighbors(neighbors, queries);
    % The left hands must either equal or immediately precede the right hands,
    % and the queries must lie closest to one of these two neighbors.

    indicesOfNearest = lh;
    % Assume all queries lie closest to the left hands.

    closerToRightHand = ((queries - neighbors(lh)) > (neighbors(rh) - queries));
    indicesOfNearest(closerToRightHand) = rh(closerToRightHand);
    % Overwrite the queries that lie closer to the right hands.

end
