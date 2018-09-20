function [lh, rh] = LookupNeighbors(neighbors, queries)
% Return the neighbors immediately preceding and following each query.
% Assumes neighbors is nonempty and strictly monotonically increasing. Assumes
% neighbors and queries have the same dimensions.
%
% If the query is greater than the greatest neighbor:
% 
%     lh = NumElems(neighbors) - 1;
%     rh = NumElems(neighbors);
%
% If the query is smaller than the smallest neighbor:
% 
%     lh = uint32(1);
%     rh = uint32(2);
%
% If there is only 1 neighbor:
% 
%     lh = uint32(neighbors);
%     rh = uint32(neighbors);
%
%    usage: [lh, rh] = LookupNeighbors(neighbors, queries)

    numNeighbors = numel(neighbors);
    % Cache the number of neighbors as type double for compatibility with
    % Logarithm.

    lh = ones(size(queries), 'uint32');
    % Place left hands on smallest neighbor. Initialize the left hands as
    % unsigned integers, so rounding occurs automatically.

    rh = uint32(numNeighbors) * lh;
    % Place right hands on largest neighbor.

    if (numNeighbors > 2)
    % Avoid taking the logarithm of nonpositive values.

        for i = 1:(1 + uint32(floor(Logarithm(numNeighbors - 2, 2))))
        % Determine the minimum number of iterations of binary search necessary
        % to ensure that the left and right hands meet.

            mh = ElementWiseMean(lh, rh);
            % Find the middle indices of the remaining neighbors for each query.
            % Round up if there are two possible choices.

            inRightHalf = (neighbors(mh) <= queries);
            lh(inRightHalf) = mh(inRightHalf);
            % Move the left hands to the middle for the queries in the right
            % half of the remaining neighbors.

            inLeftHalf = ~inRightHalf;
            rh(inLeftHalf) = mh(inLeftHalf);
            % Move the right hands to the middle for the queries in the left
            % half of the remaining neighbors.

        end

    end

end
