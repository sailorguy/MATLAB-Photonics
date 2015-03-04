classdef PbsObj
   
    properties
        nodes %Number of of nodes requested
        ppn %Processors per node    
        mem = 0 %total memory for job (must be zero if pmem~=0) [gb]
        pmem= 0 %memory per processor (instead of mem, must be zero if mem~=0) [gb]
        walltime %walltime [hr]
        queue = 'ece' %queue name
        
        emailFlag = 0 %Set to true to send notification emails
        email = 'jkeilman3@gatech.edu' %Address to send emails too
        notify = 'abe' %Default to sending mail on begin, end and abort
        
        %Configuration Options
        default = 1 %Use default options
        compiler = 'intel/12.1.4' %Compiler for MEEP when not using default
        mpiVersion = 'openmpi/1.5.4' %MPI version when not using default
        hdf5Version = 'hdf5/1.8.9' %Version of hdf5
        meepVersion = 'meep/1.2' %Version of meep 
        mpbVersion = 'mpb/1.5' %Version of MPB
        fftwVersion = 'fftw/2.1.5' %Version of fftw
        libctlVersion = 'libctl/3.1' %Version of libctl
        
        
        %Shell Script for job submission
        discard = true %Set to true to delete existing shell script, false to append
       
        
    end
       
    methods
        
        function PbsText = print(obj)
           %This function returns a cell array of formated text with the
           %values of all properties of the pbs Object
           
           k=1; %Index of current line in array, allows for future expansion with new fields
           
           string = sprintf('PBS Parameters:\n');
           PbsText(k) = {string};
           k = k+1;
           
           string = sprintf('Nodes: %u', obj.nodes);
           PbsText(k) = {string};
           k = k+1;
          
           string = sprintf('PPN: %u', obj.ppn);
           PbsText(k) = {string};
           k = k+1;
          
           string = sprintf('Memory (GB): %u', obj.mem);
           PbsText(k) = {string};
           k = k+1;
          
           string = sprintf('Walltime (hr): %u', obj.walltime);
           PbsText(k) = {string};
           k = k+1;
           
           %Print compilers if default is not set
           if(obj.default)

           CompilerVersion = sprintf('Compiler Version: Default');
           MPIVersion = sprintf('MPI Version: Default');
           
           else
           CompilerVersion = sprintf('Compiler Version: %s', obj.compiler);
           MPIVersion = sprintf('MPI Version: %s', obj.mpiVersion);
           
           end
          
           PbsText(k) = {CompilerVersion};
           k = k+1;
           
           PbsText(k) = {MPIVersion};
           k = k+1;
           
           String = sprintf('\n\n');
           PbsText(k) = {String}; %Print some extra lines to leave space before next data set
            
        end
        
    end
    
end