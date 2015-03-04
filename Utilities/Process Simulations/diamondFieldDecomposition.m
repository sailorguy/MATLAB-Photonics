function diamondFieldDecomposition

useLoadedField = true;

%Load X basis
pathX = 'C:\Scratch\IDO-FD\Xbasis\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__1-T-1000';
simName = 'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__1-T-1000';
[SimGroup_X] = loadSimulationFields(pathX, simName, [9,36, 45], false);

%Load L basis
pathL = 'C:\Scratch\IDO-FD\Lbasis\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__1-T-1000';
simName = 'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__1-T-1000';
[SimGroup_L] = loadSimulationFields(pathL, simName, [9], useLoadedField);

if(~useLoadedField) %Compute L basis if needed
    SimGroup_L.field = rotateBasisField(SimGroup_L.field,[1 0 0], 'L', 'diamond');
    SimGroup_L.field = interpolateElectromagneticField(SimGroup_L.field,SimGroup_X.field);
end

SimGroup_X.save(pathX);
SimGroup_L.save(pathL);

basis = [SimGroup_X.field, SimGroup_L.field];

%Load field for analysis
path = 'C:\Scratch\IDO-FD\Radial Disorder\0.05\S-IDO_O-100_R-0.250+-0.050_P+-0.000_D-10.0_F-0.42__1-T-1000';
simName = 'S-IDO_O-100_R-0.250+-0.050_P+-0.000_D-10.0_F-0.42__1-T-1000';
path = 'C:\Scratch\IDO-FD\Xbasis\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__1-T-1000';
simName = 'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__1-T-1000';
[SimGroup_analysis] = loadSimulationFields(path, simName, [], false);


%Compute field decomposition
field = fieldDecomposition(SimGroup_analysis.field,basis);

% 
% %Print basis coefficients
% for k = 1:length(field)
%    
%     fprintf(1,'%s :  %.4f\n', field(k).name, basis(k).coeff);
%     
% end

end