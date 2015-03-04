classdef CCoptGPUdataObj
    
    properties
        
        %Data on GPU
        Qx %Q x coordinates on gpu
        Qy %Q y coordinates on gpu
        Qz %Q z coordinates on gpu
        
        Px %Position x coordinates on gpu
        Py %Position y coordinates on gpu
        Pz %Position z coordinates on gpu
        Gx %X gradient on gpu
        Gy %Y gradient on gpu
        Gz %Z gradient on gpu
        
        V  %V potential on gpu
        VC %Intermediate results storage on gpu
        rho_real %Real part of rho on gpu
        rho_imag %Imaginary part of rho on gpu
        SF %Structure factor array
        
        dataFlag = false; %Flag to indicate data is on GPU
        
        precision = 'single' %Use 'single' or 'double' precision computations
        
    end
    
    
end