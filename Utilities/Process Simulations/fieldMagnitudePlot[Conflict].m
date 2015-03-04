function fieldMagnitudePlot

%Folders


path = {'D:\Scratch\Directional\-X\0.100\D-10.00\S-IDO_O-100_R-0.250+-0.100_P+-0.000_D-10.0_F-0.42__1'};
simName = {'S-IDO_O-100_R-0.250+-0.100_P+-0.000_D-10.0_F-0.42__1'};

% path = {'W:\gpfstest\IDO\X\Fields\R-0.250_epsS-13.0_epsL-1.0\None\D-10.00\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.41__1'; ...
%     'W:\gpfstest\IDO\X\Fields\R-0.250_epsS-13.0_epsL-1.0\Radial\0.050\D-10.00\S-IDO_O-100_R-0.250+-0.050_P+-0.000_D-10.0_F-0.41__1'};
% simName = {'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.41__1'; 'S-IDO_O-100_R-0.250+-0.050_P+-0.000_D-10.0_F-0.41__1'};


useLoadedFields = false;

%Loop over paths
for k = 1:length(path)
 
    %Load simualtion fields
     SimGroup(k) = loadSimulationFields(path{k}, simName{k},[2],useLoadedFields);
     
     %Normalize fields
     SimGroup(k).field.normalize;
     
     %Compute E field magnitude
     SimGroup(k).field = SimGroup(k).field.computeMagnitude;
     
     %Compute magnitude(k,x)
     mag(k,:) = real(sum(sum(SimGroup(k).field.magnitude,2),3));
     
end

%Plot magnitude of each simulatio
figure
plot(mag(1,:), 'b');
hold on
plot(mag(2,:), 'r');


end