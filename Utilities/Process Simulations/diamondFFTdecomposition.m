function diamondFFTdecomposition

%Folders


path = {'C:\Scratch\IDO-FFT\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.41__1'};
simName = {'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.41__1'};

path = {'W:\gpfstest\IDO\X\Fields\R-0.250_epsS-13.0_epsL-1.0\None\D-10.00\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.41__1'};
simName = {'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.41__1'};


%Create lattice object
lattice = latticeGenObj;
lattice.a = 1;
lattice.type = 'diamond';
lattice = lattice.setLattice;

%Get L points
LPts = (1/(2*pi))*lattice.getCPtsXYZ('L');

useLoadedFields = false;

%Loop over paths
for k = 1:length(path)
    
    Emag = 0;
    Dmag = 0;
    Hmag = 0;
    Bmag = 0;
    
    %Load simualtion fields
     SimGroup(k) = loadSimulationFields(path{k}, simName{k},[20],useLoadedFields);
    
    %Loop over fields
    for f = 1:length(SimGroup(k).field)
        %Compute FFT
        SimGroup(k).field(f) = SimGroup(k).field(f).computeFFT(0,1,1,32); %X,Y,Z padding, sampling rate
        
        %Compute magnitude at L points
        Emag = Emag + SimGroup(k).field(f).E_fft.getMagnitudeAtPts(LPts);
        Dmag = Dmag + SimGroup(k).field(f).D_fft.getMagnitudeAtPts(LPts);
        Hmag = Hmag + SimGroup(k).field(f).H_fft.getMagnitudeAtPts(LPts);
        Bmag = Bmag + SimGroup(k).field(f).B_fft.getMagnitudeAtPts(LPts);
    end
    
    %Save sum of magnitude as coefficient
    coeff = [Emag Dmag Hmag Bmag]/length(SimGroup.field);
    
end

end