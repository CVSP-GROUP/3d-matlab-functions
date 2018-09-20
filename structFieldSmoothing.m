function outputFeatures = structFieldSmoothing( inputFeatures )
% Interpolates nan values and filters of each field of struct inputFeatures

d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2,0.5,0.5,40,30);
Hd = design(d,'equiripple');

fields = fieldnames(inputFeatures);
for i = 1:numel(fields)
  fieldVals = interpolateNans(inputFeatures.(fields{i}));
  outputFeatures.(fields{i}) = filter(Hd, fieldVals);
end

end

