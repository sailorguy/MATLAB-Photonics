function computeVectorFieldFFT

%Load field
field = FFTVectorFieldObj;
field.name = 'e';
field = loadHDF5VectorData('W:\gpfstest\IDO\X\Fields\R-0.250_epsS-13.0_epsL-1.0\Radial\0.150\D-10.00\S-IDO_O-100_R-0.250+-0.150_P+-0.000_D-10.0_F-0.42__2-T-1000\data\Structure-e-000800.00.h5', field);
%field = loadHDF5VectorData('W:\gpfstest\IDO\X\Fields\R-0.250_epsS-13.0_epsL-1.0\None\D-10.00\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-10.0_F-0.42__2-T-1000\data\Structure-e-000800.00.h5', field);

%Pad field array
field = field.pad(0,1,1);

%Compute FFT on each component, save to new vector field
FFTfield = field;
FFTfield = FFTfield.computeFFT;
FFTfield.name = 'e';
FFTfield.samplingRate = 32;
FFTfield = FFTfield.computeFFTfrequencies;
FFTfield = FFTfield.shiftFFT;
FFTfield = FFTfield.computeMagnitude;
magnitude = FFTfield.magnitude;

%Create lattice object
lattice = latticeGenObj;
lattice.a = 1;
lattice.type = 'diamond';
lattice = lattice.setLattice;

zpos = 97;
Z = FFTfield.ptZ(1,1,zpos)*ones(size(FFTfield.ptZ));
surface(FFTfield.ptX(:,:,1),FFTfield.ptY(:,:,1),Z(:,:,1), magnitude(:,:,zpos),'EdgeColor', 'none');

hold on

CPtsXYZ = (1/(2*pi))*lattice.CPtsXYZ;

%Plot K points
 scatter3(CPtsXYZ(:,1), CPtsXYZ(:,2), CPtsXYZ(:,3), 'r');
 
%Draw line from origin to each L point
LPts = (1/(2*pi))*lattice.getCPtsXYZ('L');

for k = 1:size(LPts,1)
   
    pts = [.25 0 0];
    pts = [pts; LPts(k,:)];
    plot3(pts(:,1), pts(:,2), pts(:,3), 'r');
        
end

%Save FFTfield
file = 'C:\Scratch\IDO-FD\FFTfield_X.h5';
FFTfield.saveHDF5(file);

putvar(FFTfield);

end