function distanceInRadians = GreatCircleDistance(latOnesInDegrees, ...
                        longOnesInDegrees, latTwosInDegrees, longTwosInDegrees)
% Approximates the great-circle distance between two points on a unit sphere.
% The great-circle distance is the length of the shortest path along the surface
% of the sphere connecting the two points. latOnesInDegrees and
% longOnesInDegrees are the latitudes and longitudes, respectively, of the first
% points. latTwosInDegrees and longTwosInDegrees are the latitudes and
% longitudes, respectively of the second points. Expects all inputs to be in
% degrees. The approximation breaks down for antipodal points, that is, points
% opposite one another on the sphere. Distance is given in radians. Refer to
% http://en.wikipedia.org/wiki/Haversine_formula.
%
%    usage: distanceInRadians = GreatCircleDistance(latOnesInDegrees, ...
%                        longOnesInDegrees, latTwosInDegrees, longTwosInDegrees)

    dLatsInDegrees = latOnesInDegrees - latTwosInDegrees;
    dLongsInDegrees = longOnesInDegrees - longTwosInDegrees;
    % Calculate the differences between the latitudes and longitudes.

    distanceInRadians = Archaversine(Haversine(dLatsInDegrees) + ...
            (cosd(latOnesInDegrees) .* cosd(latTwosInDegrees) .* ...
            Haversine(dLongsInDegrees)));
    % Approximate the great-circle distance between the two points using the
    % Haversine formula. Note that Haversine takes in degrees, but Archaversine
    % puts out radians.

end
