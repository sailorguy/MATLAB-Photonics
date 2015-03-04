classdef PbsEpilogueObj
    
   
    properties
       
        %PBS Epilogue Data
        
        JobID %Job number assigned to completed simualtion
        UserID %User who submitted simulation
        JobName %Name of submitted job
        Resources %Requested resources
        
        %Resources Used
        cput %CPU Time
        mem %Memory
        vmem %Virtual Memory
        walltime %Walltime Used
        
        
        
        
        
        
    end
    
end