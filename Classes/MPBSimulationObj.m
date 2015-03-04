classdef MPBSimulationObj
   
    properties
       
        %Lattice Properties
        latticeType %diamond, hexagaonal etc.
        simulationType = 'bands' %Set to 'dos' for density of states calculations
        dimensionality = '3D' %dimensionality of the problem, default to 3D. 2D problems have no Z
        a = 1 %Lattice constant
        lattice = LatticeVectorObj %Lattice vectors and lengths (a1, a2, a3)
        radius %Radius of lattice elements
        epsSubstrate %Dielelectric constant of the substrate
        epsLattice %Dielectric constant of the lattice elements
        coreShell = false %If true, lattice elemetns use core-shell properties
        
        %K-points
        kPoints = KPointObj % n x 1 array of KPointObj describing the kpoints for the simulation
        kPointInterp = 4 %Number of k-points to interpoalte

        %Density of states
        constraints = PlaneConstraintObj %Points defining a constraint plane for density of states k-points
        maxBound = VectorObj %Point defining maximum of rectangular bounding box
        minBound = VectorObj %Point defining minimum of rectangular bounding box
        pointDensityDOS %Points per unit in k-space
        
        %Epsilon Input
        epsFileFlag = false %Flag to indicate epsilon input file is in use (instead of geometry objects)
        epsFile %Name of HDF5 epsilon input file
        
        %Simulation Properties
        resolution = 16 %Resolution of computational cell
        meshSize = 5 %Grid over which dielectric averaging occurs
        numBands = 10 %Number of bands to solve for
        
        %Ouput
        output_FLAG = false %Flag to indicate ouput is in use
        output = SimOutputObj %Ouput fields, power etc etc.
        MPBh5Files = MPBh5FileObj%H5 files for post processing
        
    end
    
end