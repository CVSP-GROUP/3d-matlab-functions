function Y = interpolateNans( X )

nanX = isnan(X);
t = 1:numel(X);
Y = X;
Y(nanX) = interp1(t(~nanX), Y(~nanX), t(nanX));

end

