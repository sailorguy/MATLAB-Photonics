classdef SimulationObj
    
    
    properties
        %General simulation Properties
        resolution %Computational cell resolution
        courantFactor = .5 %Courant factor for simulation: c*deltaT = courantFactor*deltaX
        lat %Size of the computational cell
        PML = pmlClass % perflectly matched layer properties
        epsAvg = true %Averaging for epsilon
        forceComplexFields = false %Default to using real fields
        epsInputFile = false %Use input file for epsilon if true
        type %Type of simulation being run, i.e. reflection, bands etc.
        kPoint = VectorObj %K-Point for periodic boundary conditions
        kPoint_FLAG = false %Flag to indicate periodic boundary conditions are in use
        
        %Normalization data handling
        usePreGeneratedNormData = false; %Flag to indicate norm data will be loaded from file rather than computed
        preGeneratedNormDataPath = '' %File path for pregenerated normalization data, if used
        
        %Reflectance Properties
        normalization = false %Boolean to indicate if run is for normalization
        reflOnly = false %Boolean to indicate that run is only for reflectance, used in pbs scrit resubmits
        geometryNormalizationLimit %Specify number of gemoetric objects to load during normalization run
        fluxRegion = FluxRegionObj %Flux region properties
        outputFlag = false %Set flag to true to enable HDF5 outputs
        output = SimOutputObj %Output properties, for fields, power etc.
        
        %Run Properties
        runType %Type of run function: run-until, run-sources, run-sources+
        runTermination %Type of run termination: time, field-decay
        fieldDecay = FieldDecayObj %Field decay properties to terminate simulation
        runTime %Time argument to terminate simulation
        
        %Harminv
        harminv = false %Flag to indicate harminv in use

        %Band Diagram properties
        kmin %Minimum K value
        kmax %Maximum K
        harminvCenter = VectorObj %Location for harmonic inversion
        
    end
    
    methods
        function obj = SimulationObj
            %Set up PML layers
            obj.PML.Xh.direction = 'X';
            obj.PML.Xh.side = 'High';
            obj.PML.Xl.direction = 'X';
            obj.PML.Xl.side = 'Low';
            
            obj.PML.Yh.direction = 'Y';
            obj.PML.Yh.side = 'High';
            obj.PML.Yl.direction = 'Y';
            obj.PML.Yl.side = 'Low';
            
            obj.PML.Zh.direction = 'Z';
            obj.PML.Zh.side = 'High';
            obj.PML.Zl.direction = 'Z';
            obj.PML.Zl.side = 'Low';
            
        end
        
        function SimText = print(obj)
            %This function returns a cell array of formated text with the
            %values of all properties of the Simulation Object
            
            k=1; %Index of current line in array, allows for future expansion with new fields
            
            string = sprintf('Simulation Parameters:\n');
            SimText(k) = {string};
            k = k+1;
            
            string = sprintf('Simulation Type: %s', obj.type);
            SimText(k) = {string};
            k = k+1;
            
            string = sprintf('\nLattice Properties:\n');
            SimText(k) = {string};
            k = k+1;
            
            string = sprintf('Resolution: %u', obj.resolution);
            SimText(k) = {string};
            k = k+1;
            
            string = sprintf('Dimensions (X,Y,Z): %u,%u,%u', obj.lat(1), obj.lat(2), obj.lat(3));
            SimText(k) = {string};
            k = k+1;
            
            String = sprintf('\n\n');
            SimText(k) = {String}; %Print some extra lines to leave space before next data set
            
        end
    end
end
