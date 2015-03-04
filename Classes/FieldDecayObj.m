%Class definition for field decay parameters, used to terminate simulation

classdef FieldDecayObj
   
    properties
        dT %run increment time
        component %component
        pt = VectorObj %location to check fields
        tolerance %Amount fields have decayed by since previous run
    
    end
end