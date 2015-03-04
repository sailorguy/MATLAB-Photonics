function [allPositions,allSizes, disorderSites] = setDisorder(lattice, allPositions)
%This function returns arrays of position and size disorder

%Initalize disorder size array
allSizes = lattice.radius*ones(length(allPositions),1);

%Loop over all disorder regions
for k = 1:length(lattice.disorder)
    
    %Extract positions which satisfy constraints for applying disorder
    [positions,indices] = pointCloud(allPositions, lattice.disorder(k).constraints, .001);
    
    disorderSites = positions;
    
    %Get positions for which there is no disorder
    index = true(size(allPositions,1),1);
    index(indices) = false; %Set index to false where there is disorder
    noDisorderPositions = allPositions(index,:);
    
    %Create sizes vector (in the no disorder case)
    noDisorderSizes = allSizes(index);
    
    %Create sizes vector (in the disorder case)
    disorderSizes = allSizes(~index);

    
    %Check if there are any vaccancies
    if(lattice.disorder(k).occupancyProbability ~= 1)
        
        %Get probability for each element
        prob = rand(length(positions),1);
        
        %Keep only those that satisfy the occupancy probability
        disorderSites = positions(prob>=lattice.disorder(k).occupancyProbability,:);
        positions = positions(prob<=lattice.disorder(k).occupancyProbability,:);
        
        %Keep sizes for elements that satisfy probability
        disorderSizes = disorderSizes(prob<=lattice.disorder(k).occupancyProbability,:);
        
    end
    
    %Check if there is any positional displacement
    if(lattice.disorder(k).pDisplacement ~=0)
        r = lattice.a*lattice.disorder(k).pDisplacement*rand(length(positions),1);
        theta = pi*rand(length(positions),1);
        phi = 2*pi*rand(length(positions),1);
        
        if(lattice.disorder(k).pDisplacementX)
            %Set X coordinate
            positions(:,1) = positions(:,1) + r(:).*sin(theta(:)).*cos(phi(:));
        end
        
        if(lattice.disorder(k).pDisplacementY)
            %Set Y coordinate
            positions(:,2) = positions(:,2) + r(:).*sin(theta(:)).*sin(phi(:));
        end
        
        if(lattice.disorder(k).pDisplacementZ)
            %Set Z coordinate
            positions(:,3) = positions(:,3) + r(:).*cos(theta(:));
        end
    end
    
    %Check if there is any size deviation
    if(lattice.disorder(k).rDeviation ~=0)
        
        switch lattice.disorder(k).rDeviationDistribution
            
            case 'Uniform'
                
                randValues = rand(length(positions),1);
                
            case 'Gaussian'
                
                randValues = randn(length(positions),1) + .5;
        end
        
        %Element probability
        prob = rand(length(positions),1);
        
        %Save original size distribution
        disorderSizes_original = disorderSizes;
        
        %Apply radial deviation
        if(lattice.disorder(k).rDeviationPos && lattice.disorder(k).rDeviationNeg) %Positve and negative deviation
            
            %Compute sizes according to radial deviations
            disorderSizes = disorderSizes + lattice.disorder(k).rDeviation*lattice.radius*(2*randValues - 1);
            
        elseif(lattice.rDeviationPos) %Positive deviation only
            
            %Compute sizes according to radial deviations
            disorderSizes = disorderSizes + lattice.disorder(k).rDeviation*lattice.radius*randValues;
            
        elseif(lattice.rDeviationNeg) %Negative deviation only
            
            %Compute sizes according to radial deviations
            disorderSizes = disorderSizes - lattice.disorder(k).rDeviation*lattice.radius*randValues;
            
        end
        
        %Overwrite disordered sizes with original sizes according to element
        %probability
        disorderSizes(prob > lattice.disorder(k).rDeviationProbability) = disorderSizes_original(prob > lattice.disorder(k).rDeviationProbability);
        
    end
    
    if(lattice.disorder(k).defectRadiusProbability)
        %Percentage of elements have different, fixed radius
        
        %Get probability for each element
        prob = rand(length(positions),1);
        
        %Set defect radius
        disorderSizes(prob<=lattice.disorder(k).defectRadiusProbability,:) = lattice.disorder(k).defectRadius;
        
    end
    
    allPositions = [noDisorderPositions; positions];
    allSizes = [noDisorderSizes; disorderSizes];
    
end



