classdef DisorderObj
    
    properties
        
        %Disorder
        
        constraints = PlaneConstraintObj %Constratints on regin of disorder
        
        %Occupancy
        occupancyProbability = 1 %Probability that any individual lattice site is occupied. 1 for perfect structure
        
        %Radial Deviation (distribution)
        rDeviation = 0 %Percent deviation (+/-) from nominal radius, default is 0
        rDeviationPos = true; %Allow positive radial deviations
        rDeviationNeg = true; %Allow negative radial deviations
        rDeviationDistribution = 'Uniform' %Distribution of radii, "Uniform", "Gaussian"
        rDeviationProbability = 1 %Probability for any given element to deviate from it's nominal value
        
        %Positional Displacement (distribution)
        pDisplacement = 0 %Maximum deviation from nominal position for lattice elements
        pDisplacementX = true; %Enable dispalcement in X direction
        pDisplacementY = true; %Enable displacement in Y direction
        pDisplacementZ = true; %Enable dispalcement in Z direction
        
        %Defect Radius
        defectRadiusProbability = 0 %Proabability of a particular lattice element having a different (but fixed) radius. Default = 0
        defectRadius %Radius for randomly selected defect radius elements
        
        
    end
    
    
end