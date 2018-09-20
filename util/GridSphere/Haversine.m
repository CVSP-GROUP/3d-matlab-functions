function haversines = Haversine(anglesInDegrees)
% Calculates the haversine function of the given angles.
% Assumes the angles are given in degrees. Refer to
% http://en.wikipedia.org/wiki/Haversine_formula.
%
%    usage: haversines = Haversine(anglesInDegrees)

    haversines = 0.5 * (1 - cosd(anglesInDegrees));

end
