function numElems = NumElems(array)
% Returns the number of elements in an array as type uint32.
%
%    usage: numElems = NumElems(array)

    numElems = uint32(numel(array));
    % Convert the output of the built-in numel function from type double to the
    % more appropriate type uint32.

end
