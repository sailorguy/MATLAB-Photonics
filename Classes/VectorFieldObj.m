classdef VectorFieldObj
    
    %This class describes a vector field, used primarily for projecting
    %MEEP/MPB field patterns
    

    properties
        
        name %Name for identifying vector field
        
        %Vector field components, in array form. In general these are
        %complex
        X
        Y
        Z
        
        magnitude %Magnitude of vector field
        
        %X,Y,Z locations for field components described above
        ptX
        ptY
        ptZ
        
        coefficient %Projection coefficient used in vector field projection
        loaded = false%Flag to indicate data has been loaded

    end

    
    methods
        
        function pts = ptVec(obj)
            %This function returns a vector of points extracted from the
            %above point arrays
               
            pts = [reshape(obj.ptX,numel(obj.ptX),1), reshape(obj.ptY,numel(obj.ptY),1), reshape(obj.ptZ,numel(obj.ptZ),1)];
            
        end
        
        function [obj] = scalarMultiply(obj,a)
            %This function multiplies the vector field coefficients by a
            %scalar, a
            
            obj.X = a*obj.X;
            obj.Y = a*obj.Y;
            obj.Z = a*obj.Z;
               
        end 
        
        function [obj] = setPts(obj, ptX,ptY,ptZ)
           
            obj.ptX = ptX;
            obj.ptY = ptY;
            obj.ptZ = ptZ;
            
        end
        
        function [obj] = setPtsVec(obj, pts)
            %This function assumes that the X field is populated
            
            obj.ptX = reshape(pts(:,1), size(obj.X));
            obj.ptY = reshape(pts(:,2), size(obj.X));
            obj.ptZ = reshape(pts(:,3), size(obj.X));
            
            
        end
        
        function plot(obj)
            
           quiver3(obj.ptX, obj.ptY, obj.ptZ, obj.X, obj.Y, obj.Z);
            
        end
        
        function saveHDF5(obj,file)
            
            %Seperate each component into real and imag, write to file
            
            %Write x data
            dataset = [obj.name 'x.r'];
            writeHDF5(file,dataset,real(obj.X));
            
            dataset = [obj.name 'x.i'];
            writeHDF5(file,dataset,imag(obj.X));
            
            %Write y data
            dataset = [obj.name 'y.r'];
            writeHDF5(file,dataset,real(obj.Y));
            
            dataset = [obj.name 'y.i'];
            writeHDF5(file,dataset,imag(obj.Y));
            
            %Write z data
            dataset = [obj.name 'z.r'];
            writeHDF5(file,dataset,real(obj.Z));
            
            dataset = [obj.name 'z.i'];
            writeHDF5(file,dataset,imag(obj.Z));
         
        end
        
        
        function [obj] = computeMagnitude(obj)
           %Returns a scalar field equal to the magnitude of the vector
           %field
            
            obj.magnitude = sqrt(abs(obj.X).^2 + abs(obj.Y).^2 + abs(obj.Z).^2);            
            
        end
        
        function mag = getMagnitudeAtPts(obj,pts)
            %This function returns the magnitude at the specified points
            
            %Get point vectors
            ptsX = obj.ptX(:,1,1);
            ptsY = obj.ptY(1,:,1);
            ptsZ = reshape(obj.ptZ(1,1,:),1,size(obj.ptZ,3));
            
            %Preallocate magnitude vector
            mag = zeros(size(pts,1),1);
            
            %Loop over input points
            for k = 1:size(pts,1)
                
                %Find closest indicies
                [~,index(1)] = min(abs(ptsX - pts(k,1)));
                [~,index(2)] = min(abs(ptsY - pts(k,2)));
                [~,index(3)] = min(abs(ptsZ - pts(k,3)));
                
                %Use index to extract cube of points from point and magnitude
                %arrays
                box = 1; %1 point on either side
                
                minPt = index - box;
                maxPt = index + box;
                
                %Points
                xPts = obj.ptX(minPt(1):maxPt(1),minPt(2):maxPt(2), minPt(3):maxPt(3));
                yPts = obj.ptZ(minPt(1):maxPt(1),minPt(2):maxPt(2), minPt(3):maxPt(3));
                zPts = obj.ptZ(minPt(1):maxPt(1),minPt(2):maxPt(2), minPt(3):maxPt(3));
                magPts = obj.magnitude(minPt(1):maxPt(1),minPt(2):maxPt(2), minPt(3):maxPt(3));
                
                %Problem with scattered interpolant and empty triangulation
                    
%                 %Form vectors
%                 xPts = reshape(xPts, numel(xPts),1);
%                 yPts = reshape(yPts, numel(yPts),1);
%                 zPts = reshape(zPts, numel(zPts),1);
%                 magPts = reshape(magPts, numel(magPts),1);
%                 
%                 %Compute scattered interpolant
%                 Fmag = scatteredInterpolant(xPts,yPts,zPts,magPts, 'nearest');
%                 
%                 %Evaluate scattered interpolant at (x,y,z)
%                 mag(k) = Fmag(pts(k,1),pts(k,2),pts(k,3));

                 
                mag = sum(magPts(:));
        
            end
        end
    end
end
