function archaversinesInRadians = Archaversine(values)
% Calculates the inverse haversine function of the given values.
% Output is given in radians. Refer to
% http://en.wikipedia.org/wiki/Haversine_formula.
%
%    usage: archaversinesInRadians = Archaversine(values)

    archaversinesInRadians = acos(1 - (2 * values));

end
