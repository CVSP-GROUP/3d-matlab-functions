function y = concatAllStructFields( s )
% Input: struct s
% Output: matrix of concatenation of all fields (row-wise)

fields = fieldnames(s);

for i = 1:numel(fields)
    if i == 1
        first_length = size(s.(fields{i}), 1);
    else
        if size(s.(fields{i}), 1) ~= first_length
            error('All fields must be equal in size along first dimension')
        end
    end
end

y = [];
for i = 1:numel(fields)
  y = [y, s.(fields{i})];
end

end

