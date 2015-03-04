classdef MPBh5FileObj
   
    properties
       inUse_FLAG = false %Flag to indicate that h5 file output is in use
       name %file name
       periods = 3 %periods to expand file to
       resolution = 32 %resolution

    end
end