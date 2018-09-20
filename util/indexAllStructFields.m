function y = indexAllStructFields( s, ind )
% Input: struct s, index vector ind
% Output: new struct with all fields of s indexed by ind

fields = fieldnames(s);
for i = 1:numel(fields)
  fieldVals = s.(fields{i});
  y.(fields{i}) = fieldVals(ind,:);
end

end

