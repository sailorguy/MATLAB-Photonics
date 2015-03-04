classdef h5FileObj
    
   properties
       fileName %Name of file
       ez %ez dataset
       
       inUse_FLAG = false %Flag to indicate current dataset has been loaded
       maxValue %Maximum value in dataset
    
   end 
    
end