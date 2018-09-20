function indexOfNearest = LookupNearestNeighbor(neighbors, query)
% Returns the indices of the nearest neighbor to the given query.
% Returns 0 for queries outside the range of the neighbors. Selects the neighbor
% with the lowest index in the event of a tie. Assumes neighbors is nonempty and
% strictly monotonically increasing.
%
%    usage: indexOfNearest = LookupNearestNeighbor(neighbors, query)

    rh = NumElems(neighbors);
    % Place right hand on largest neighbor.

    if ((query < neighbors(1)) || (neighbors(rh) < query))
        indexOfNearest = 0;
        return
    end
    % Handle the case in which the query lies outside the range of the
    % neighbors.

    lh = uint32(1);
    % Place left hand on smallest neighbor.

    while ((lh + 1) < rh)

        mh = ElementWiseMean(lh, rh);
        % Find the middle index of the remaining neighbors. Round up if there
        % are two possible choices.

        if (neighbors(mh) <= query)

            lh = mh;
            % The query lies in the right half of the remaining neighbors.

        else

            rh = mh;
            % The query lies in the left half of the remaining neighbors.

        end

    end
    % Now the left hand must either equal or immediately precede the right hand,
    % and the query must lie closest to one of these two neighbors.

    if ((query - neighbors(lh)) <= (neighbors(rh) - query))

        indexOfNearest = lh;
        % The query lies closest to the left hand, or midway between the two
        % hands.

    else

        indexOfNearest = rh;
        % The query lies closest to the right hand.

    end

end
