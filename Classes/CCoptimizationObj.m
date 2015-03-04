classdef CCoptimizationObj
    %This object stores parameters for the Collective Coordinate
    %Optimization proceedure
    
    properties
        
        v %Potential V(q) driving optimization problem
        q %Vectors in q space over which V is specified
        
        delta = .1%dX for computing gradient
        
        gpu = CCoptGPUdataObj; %Data on GPU's, gpu(1) = data on gpu 1
        
        SF_initial %Inital structure factor
        SF_final %Final structure factor
        P_initial %Initial positions
        P_final %Final positions
        phi_initial %Initial potential
        phi_final %Final potential
       
        nMin %Minimum index for determining q vectors
        nMax %Maximum index for determining q vectors
        
        sz %Vector specifying physical size of lattice region
        
        HUradius %Radius specifying region of K-space to be set to 0 in optimization
        
        D %Number of dimensions
        N %Number of lattice objects
        phiMin %Minimum attainable value of phi
        chi %Degree of hyperuniformity
        
        elapsedTime = 0 %Time elapsed during optimization calculation
    end
    
    
    methods
        
        function obj = setQ(obj)
            
            switch obj.D
                
                case 1
                    
                    %Create square grid of indicies
                    [nX, nY] = meshgrid(obj.nMin:obj.nMax, obj.nMin:obj.nMax);
                    
                    %Compute q vectors from grid
                    obj.q =  [2*pi*nX(:)/obj.sz(1), 2*pi*nY(:)/obj.sz(2)];
                    
                    
                case 3
                    
                    %Create cubic grid of indices 
                    [nX, nY, nZ] = meshgrid(obj.nMin:obj.nMax, obj.nMin:obj.nMax, obj.nMin:obj.nMax);
                    
                    %Create grid in k-space
                    obj.q = [2*pi*nX(:)/obj.sz(1), 2*pi*nY(:)/obj.sz(2), 2*pi*nZ(:)/obj.sz(3)];
                    
            end
        end
        
        
        function obj = setV(obj)
            
            switch obj.D
                
                case 2
                    
                    %Setup potential  array
                    obj.v = zeros(obj.nMax - obj.nMin + 1, obj.nMax - obj.nMin + 1);
                    
                    %Create coordinate grid for array
                    [X,Y] = meshgrid(linspace(obj.nMin, obj.nMax, size(obj.v,1)), linspace(obj.nMin, obj.nMax, size(obj.v,2)));

                    %Set region inside radius to 1
                    obj.v(sqrt(X(:).^2 + Y(:).^2)< obj.HUradius) = 1;
                    
                case 3
                    
                    %Setup potential  array
                    obj.v = zeros(obj.nMax - obj.nMin + 1, obj.nMax - obj.nMin + 1, obj.nMax - obj.nMin + 1);
                    
                    %Create coordinate grid for array
                    [X,Y,Z] = meshgrid(linspace(obj.nMin, obj.nMax, size(obj.v,1)), linspace(obj.nMin, obj.nMax, size(obj.v,2)), linspace(obj.nMin, obj.nMax, size(obj.v,3)));
                    
                    %Set region inside radius to 1
                    
                    obj.v(sqrt(X(:).^2 + Y(:).^2 + Z(:).^2)< obj.HUradius) = 1;
                    obj.v(sqrt(X(:).^2 + Y(:).^2 + Z(:).^2) == 0) = 0; %Knock out contribution to phi sum from C(0)

                    

            end
        end
        
        
        function obj = computeChiandPhiMin(obj)
            
            %Compute number of constrainted wave vectors M(k), depending on
            %dimensionality
            switch obj.D
                
                case 2
                    M = .5*sum(sum(obj.v));
           
                    
                case 3
                    M = .5*sum(sum(sum(obj.v)));
                    
                    
            end
            
            %Compute chi = M(k)/D*N
            obj.chi = M/(obj.N*obj.D);
            
            obj.phiMin = -obj.N*M/prod(obj.sz);
            
            
        end
        
        function obj = setGPUdata(obj)
                          
            switch obj.gpu.precision
                
                case 'single'
                
                %Q vectors on gpu
                obj.gpu.Qx = gpuArray(single(obj.q(:,1)));
                obj.gpu.Qy = gpuArray(single(obj.q(:,2)));
                obj.gpu.Qz = gpuArray(single(obj.q(:,3)));
                
                %Potential on gpu
                obj.gpu.V = gpuArray(single(obj.v(:)));
                
                %Intermediate results
                obj.gpu.VC = gpuArray(single(zeros(size(obj.q,1),1)));
                obj.gpu.SF = gpuArray(single(zeros(size(obj.q,1),1)));
                obj.gpu.rho_real = gpuArray(single(zeros(size(obj.q,1),1)));
                obj.gpu.rho_imag = gpuArray(single(zeros(size(obj.q,1),1)));
                
                %Positions
                obj.gpu.Px = gpuArray(single(zeros(obj.N,1)));
                obj.gpu.Py = gpuArray(single(zeros(obj.N,1)));
                obj.gpu.Pz = gpuArray(single(zeros(obj.N,1)));
                
                %Gradient
                obj.gpu.Gx = gpuArray(single(zeros(obj.N,1)));
                obj.gpu.Gy = gpuArray(single(zeros(obj.N,1)));
                obj.gpu.Gz = gpuArray(single(zeros(obj.N,1)));

                case 'double'
                                           
                %Q vectors on gpu
                obj.gpu.Qx = gpuArray(obj.q(:,1));
                obj.gpu.Qy = gpuArray(obj.q(:,2));
                obj.gpu.Qz = gpuArray(obj.q(:,3));
                
                %Potential on gpu
                obj.gpu.V = gpuArray(obj.v(:));
                
                %Intermediate results
                obj.gpu.VC = gpuArray(zeros(size(obj.q,1),1));
                obj.gpu.SF = gpuArray(zeros(size(obj.q,1),1));
                obj.gpu.rho_real = gpuArray(zeros(size(obj.q,1),1));
                obj.gpu.rho_imag = gpuArray(zeros(size(obj.q,1),1));
                
                %Positions
                obj.gpu.Px = gpuArray(zeros(obj.N,1));
                obj.gpu.Py = gpuArray(zeros(obj.N,1));
                obj.gpu.Pz = gpuArray(zeros(obj.N,1));
                
                %Gradient
                obj.gpu.Gx = gpuArray(zeros(obj.N,1));
                obj.gpu.Gy = gpuArray(zeros(obj.N,1));
                obj.gpu.Gz = gpuArray(zeros(obj.N,1));
                    
            end
        end
        
        function obj = positionsToGPU(obj,Px,Py,Pz)
            
            
            switch obj.gpu.precision
                
                case 'single'
                    
                    obj.gpu.Px = gpuArray(single(Px));
                    obj.gpu.Py = gpuArray(single(Py));
                    obj.gpu.Pz = gpuArray(single(Pz));
                    
                case 'double'
                    
                    obj.gpu.Px = gpuArray(Px);
                    obj.gpu.Py = gpuArray(Py);
                    obj.gpu.Pz = gpuArray(Pz);
                    
            end
                
        end
        
        function obj = resetGPUdataFlags(obj)
        
            for k = 1:obj.maxGPUs
                
               obj.gpu.dataFlag = false; 
                
            end
            
        end
        
        
        function obj = setGPUq(obj)
            
            %Q vectors on gpu
            obj.qx_gpu = gpuArray(single(obj.q(:,1)));
            obj.qy_gpu = gpuArray(single(obj.q(:,2)));
            obj.qz_gpu = gpuArray(single(obj.q(:,3)));
            
            
        end
        
        function obj = setGPUv(obj)
            
            %Potential on gpu
            obj.v_gpu = gpuArray(single(obj.v(:)));
            
        end
        
        function obj = setGPUvc(obj)

           obj.vc_gpu =  gpuArray(single(zeros(size(obj.q,1), 1)));
            
        end
        
        function obj = setGPUsf(obj)
            
           %Structure factor on GPU
           obj.sf = gpuArray(single(zeros(size(obj.q,1), 1))); 
           
        end
            
    end
end




