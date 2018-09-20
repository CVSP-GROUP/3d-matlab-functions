function outputData = dataSmoothing( inputData )
% Interpolates nan values and filters input
% Operates on each column seperately

d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2,0.5,0.5,40,30);
Hd = design(d,'equiripple');
fvtool(Hd)

%Repeat initial values to avoid ripple
inputData = [repmat(inputData(1,:),164,1); inputData];

outputData = zeros(size(inputData));
for i = 1:size(inputData, 2)
  inputWithoutNans = interpolateNans(inputData(:,i));
  outputData(:,i) = filter(Hd, inputWithoutNans);
end

%Remove the initial section
outputData = outputData(165:end,:);

end

