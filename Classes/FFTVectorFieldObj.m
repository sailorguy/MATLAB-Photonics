classdef FFTVectorFieldObj < VectorFieldObj
    
    properties
        samplingRate %Samples/unit
        
        
    end
    
    methods
        
        function obj = initialize(obj,field)
            %This function initalizes an FFTVectorFieldObj from a
            %VectorFieldObj
            obj.name = field.name;
            obj.X = field.X;
            obj.Y = field.Y;
            obj.Z = field.Z;
            
            obj.magnitude = field.magnitude;
            
            obj.ptX = field.ptX;
            obj.ptY = field.ptY;
            obj.ptZ = field.ptZ;
            
            obj.coefficient = field.coefficient;
            obj.loaded = field.loaded;
            
        end
        
        
        function obj = computeFFT(obj)
            %This function computes an FFT of the fields in X,Y,Z
            
            obj.X = fftn(obj.X);
            obj.Y = fftn(obj.Y);
            obj.Z = fftn(obj.Z);
            
        end
        
        function obj = computeFFTfrequencies(obj)
            %This function populates the obj.pt matricies with the
            %frequencies corresponding to the sampling rate
            
            %Compute FFT indicies
            
            xgv = 0:size(obj.X,1)-1;
            ygv = 0:size(obj.X,2)-1;
            zgv = 0:size(obj.X,3)-1;
            
            [kX,kY,kZ] = ndgrid(xgv,ygv,zgv);
            
            %Frequency is k/N*samplingRate, accounting for nyquist rate
            
            obj.ptX = kX/size(obj.X,1);
            obj.ptY = kY/size(obj.X,2);
            obj.ptZ = kZ/size(obj.X,3);
            
            obj.ptX(obj.ptX>.5) = obj.ptX(obj.ptX>.5) - 1;
            obj.ptY(obj.ptY>.5) = obj.ptY(obj.ptY>.5) - 1;
            obj.ptZ(obj.ptZ>.5) = obj.ptZ(obj.ptZ>.5) - 1;
            
            obj.ptX = obj.ptX*obj.samplingRate;
            obj.ptY = obj.ptY*obj.samplingRate;
            obj.ptZ = obj.ptZ*obj.samplingRate;
            
            
        end
        
        function obj = shiftFFT(obj)
            %This function performs an fftshift on the X,Y,Z and ptX, ptY,
            %ptZ arrays. It assumes the unshifted fft is stored in X,Y,Z,
            %and the corresponding frequencies stored in ptX, ptY, ptZ
            
            obj.X = fftshift(obj.X);
            obj.Y = fftshift(obj.Y);
            obj.Z = fftshift(obj.Z);
            
            obj.ptX = fftshift(obj.ptX);
            obj.ptY = fftshift(obj.ptY);
            obj.ptZ = fftshift(obj.ptZ);
            
        end
        
        function obj = pad(obj,mX,mY, mZ)
            
            %This function pads the arrays X,Y,Z in each dimension by the
            %number of extra copies specified by mX, mY and mZ
            
            szX = size(obj.X,1);
            szY = size(obj.X,2);
            szZ = size(obj.X,3);
            
            obj.X = padarray(obj.X,[mX*szX, mY*szY, mZ*szZ], 'circular');
            obj.Y = padarray(obj.Y,[mX*szX, mY*szY, mZ*szZ], 'circular');
            obj.Z = padarray(obj.Z,[mX*szX, mY*szY, mZ*szZ], 'circular');
            
            
        end
    end
end