function Y = clip( X, minVal, maxVal )

Y = X;
Y(Y < minVal) = minVal;
Y(Y > maxVal) = maxVal;

end

