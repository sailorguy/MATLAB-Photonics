classdef ElectromagneticFieldObj
    %This class contains a set of vector fields for the E, D, H and B
    %fields
    
    properties
        
        %Constants
        eps0 = 8.854*10^-12;
        u0 = 4*pi*10^-7;
        
        E = VectorFieldObj %Electric Field
        D = VectorFieldObj %Electric Displacement Field
        H = VectorFieldObj %Magnetizing Field
        B = VectorFieldObj %Magnetic Field
        S = VectorFieldObj %Pointing Vector
        
        E_fft = FFTVectorFieldObj %FFT of Electric Field
        D_fft = FFTVectorFieldObj %FFT of Displacement Field
        H_fft = FFTVectorFieldObj %FFT of Magnetizing Field
        B_fft = FFTVectorFieldObj %FFT of Magnetic field
        
        eps %Epsilon data
        u %Mu data
        
        magnitude %Electromagnetic energy scalar field
        
        normalization = 1 %Coefficient for normalization-multiply by this value to recover original fields
        
        name %Indentifier for field
        uniqueIndex %Index uniquely identifying this field, at simulation setup
        coeff %Basis coefficients for field decomposition
        loaded = false %Flag to indicate that field has been loaded
        
        time %Time at which data was captured
        center %Center location for data collection (x y z)
        XYZsize %Size of collection region
        
        
    end
    
    methods
        
        function obj = ElectromagneticFieldObj()
            
            %Initalize vector field names
            obj.E.name = 'e';
            obj.D.name = 'd';
            obj.H.name = 'h';
            obj.B.name = 'b';
            
        end
        
        function [eEnergy] =timeAverageElectricEnergy(obj)
         
            %Compute electric energy
            eEnergy = .5*(conj(obj.E.X).*obj.D.X + conj(obj.E.Y).*obj.D.Y + conj(obj.E.Z).*obj.D.Z);
            
        end
        
        function [hEnergy] = timeAverageMagneticEnergy(obj)

            %Compute magnetic energy
            hEnergy = .5*(conj(obj.H.X).*obj.B.X + conj(obj.H.Y).*obj.B.Y + conj(obj.H.Z).*obj.B.Z);
            
        end
        
        function [energy] = timeAveragElectromagneticEnergy(obj)
            
            energy = obj.timeAverageElectricEnergy + obj.timeAverageMagneticEnergy;
            
        end
        
        function [eEnergy] =instantaneousElectricEnergy(obj)
         
            %Compute electric energy
            eEnergy = .5*(real(obj.E.X).*real(obj.D.X) + real(obj.E.Y).*real(obj.D.Y) + real(obj.E.Z).*real(obj.D.Z));
            
        end
        
        function [hEnergy] = instantaneousMagneticEnergy(obj)

            %Compute magnetic energy
            hEnergy = .5*(real(obj.H.X).*real(obj.B.X) + real(obj.H.Y).*real(obj.B.Y) + real(obj.H.Z).*real(obj.B.Z));
            
        end
        
        function [energy] =instantaneousElectromagneticEnergy(obj)
            
            energy = obj.instantaneousElectricEnergy + obj.instantaneousMagneticEnergy;
            
        end
        
        function [intEnergy] = integratedElectromagneticEnergy(obj)
            
            %Get electromagnetic energy
            energy = obj.electromagneticEnergy;
            
            %Compute volume of region as deltaX * deltaY * deltaZ
            V = (max(obj.E.ptX(:)) - min(obj.E.ptX(:)))*(max(obj.E.ptY(:)) - min(obj.E.ptY(:)))*(max(obj.E.ptZ(:)) - min(obj.E.ptZ(:)));
            
            %Compute volume of integral element
            dV = V/numel(obj.E.ptX);
            
            %Integrate energy over the volume
            intEnergy = dV*sum(reshape(energy, numel(energy), 1));
            
            
        end
        
        function [obj] = computeMagnitude(obj)
            
            obj.magnitude = .5*(conj(obj.E.X).*obj.D.X + conj(obj.E.Y).*obj.D.Y + conj(obj.E.Z).*obj.D.Z) +...
                .5*(conj(obj.H.X).*obj.B.X + conj(obj.H.Y).*obj.B.Y + conj(obj.H.Z).*obj.B.Z);
            
        end
        
        function [obj] = computePoyntingVector(obj)
            
            E_vec = [obj.E.X(:), obj.E.Y(:), obj.E.Z(:)];
            H_vec = [obj.H.X(:), obj.H.Y(:), obj.H.Z(:)];
            
            S_vec = cross(E_vec,H_vec);
            
            obj.S.X = reshape(S_vec(:,1), size(obj.E.X));
            obj.S.Y = reshape(S_vec(:,2), size(obj.E.X));
            obj.S.Z = reshape(S_vec(:,3), size(obj.E.Z));
            
        end
        
        function [obj] = normalize(obj)
            
            %Compute normalization constant, a
            a = sqrt(obj.integratedElectromagneticEnergy);
            obj.E = obj.E.scalarMultiply(1/a);
            obj.D = obj.D.scalarMultiply(1/a);
            obj.H = obj.H.scalarMultiply(1/a);
            obj.B = obj.B.scalarMultiply(1/a);
            obj.normalization = a;
            
        end
        
        function [obj] = denormalize(obj)
            
            %Multiply fields by normalization coefficient
            a = obj.normalization;
            obj.E = obj.E.scalarMultiply(a);
            obj.D = obj.D.scalarMultiply(a);
            obj.H = obj.H.scalarMultiply(a);
            obj.B = obj.B.scalarMultiply(a);
            obj.normalization = 1;
            
        end
        
        function [obj] = scalarMultiplyField(obj, a)
            
            obj.E = obj.E.scalarMultiply(a);
            obj.D = obj.D.scalarMultiply(a);
            obj.H = obj.H.scalarMultiply(a);
            obj.B = obj.B.scalarMultiply(a);

        end
        
        function [obj] = computeXYZpts(obj)
            %This function populates the point arrays for each of the fields, based on the obj.size. The point arrays are zero-centered
            
            %Get number of points for each direction from (arbitrary) E
            %field
            numPts = size(obj.E.X);
            
            %Handle 2D case
            if(length(numPts) == 2)
                numPts(3) = 1;
            end
            
            %Compute grid vectors
            gx = linspace(-1*obj.XYZsize(1)/2, obj.XYZsize(1)/2, numPts(1));
            gy = linspace(-1*obj.XYZsize(2)/2, obj.XYZsize(2)/2, numPts(2));
            gz = linspace(-1*obj.XYZsize(3)/2, obj.XYZsize(3)/2, numPts(3));
            
            %Compute points
            [X,Y,Z] = meshgrid(gx,gy,gz);
            
            %Set point arrays in each of the fields
            obj.E = obj.E.setPts(X,Y,Z);
            obj.D = obj.D.setPts(X,Y,Z);
            obj.H = obj.H.setPts(X,Y,Z);
            obj.B = obj.B.setPts(X,Y,Z);
            
        end
        
        function [obj] = setLoaded(obj)
            
            if(obj.E.loaded && obj.D.loaded && obj.H.loaded && obj.B.loaded)
                
                obj.loaded = true;
                
            end
        end
        
        function [obj] = computeFFT(obj,mX, mY, mZ, samplingRate)
            %This function computes the FFT of each of the 4 fields,
            %and stores it in its corresponding FFTfieldObj
            
            tic;
            
            %Initialize FFT objects
            obj.E_fft = obj.E_fft.initialize(obj.E);
            obj.D_fft = obj.D_fft.initialize(obj.D);
            obj.H_fft = obj.H_fft.initialize(obj.H);
            obj.B_fft = obj.B_fft.initialize(obj.B);
            
            %Set the sampling rate
            obj.E_fft.samplingRate = samplingRate;
            obj.D_fft.samplingRate = samplingRate;
            obj.H_fft.samplingRate = samplingRate;
            obj.B_fft.samplingRate = samplingRate;
            
            %Pad fields
            obj.E_fft = obj.E_fft.pad(mX,mY,mZ);
            obj.D_fft = obj.D_fft.pad(mX,mY,mZ);
            obj.H_fft = obj.H_fft.pad(mX,mY,mZ);
            obj.B_fft = obj.B_fft.pad(mX,mY,mZ);
            
            %Compute FFT frequencies
            obj.E_fft = obj.E_fft.computeFFTfrequencies;
            obj.D_fft = obj.D_fft.computeFFTfrequencies;
            obj.H_fft = obj.H_fft.computeFFTfrequencies;
            obj.B_fft = obj.B_fft.computeFFTfrequencies;
            
            %Compute FFT for each of the fields
            obj.E_fft = obj.E_fft.computeFFT;
            obj.D_fft = obj.D_fft.computeFFT;
            obj.H_fft = obj.H_fft.computeFFT;
            obj.B_fft = obj.B_fft.computeFFT;
            
            %Shift the FFT
            obj.E_fft = obj.E_fft.shiftFFT;
            obj.D_fft = obj.D_fft.shiftFFT;
            obj.H_fft = obj.H_fft.shiftFFT;
            obj.B_fft = obj.B_fft.shiftFFT;
            
            %Compute magnitude
            obj.E_fft = obj.E_fft.computeMagnitude;
            obj.D_fft = obj.D_fft.computeMagnitude;
            obj.H_fft = obj.H_fft.computeMagnitude;
            obj.B_fft = obj.B_fft.computeMagnitude;
            
            toc
            
        end
        
        
        function obj = computeDfromE(obj)
            
            %D = e0*eR*E
            obj.D.X = obj.E.X.*obj.eps*obj.eps0;
            obj.D.Y = obj.E.Y.*obj.eps*obj.eps0;
            obj.D.Z = obj.E.Z.*obj.eps*obj.eps0;
            
        end
        
        function obj = computeBfromH(obj)
            
            %B = u0*uR*H
            obj.B.X = obj.H.X.*obj.u*obj.u0;
            obj.B.Y = obj.H.Y.*obj.u*obj.u0;
            obj.B.Z = obj.H.Z.*obj.u*obj.u0;
            
        end
    end
    
end
