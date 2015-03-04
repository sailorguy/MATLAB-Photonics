classdef pmlObj
   
    properties
       thickness = 0 %PML layer thickness in each direction
       direction %Specify directon of PML layer
       side %high or low (i.e. X+ or X-)
       strength = 1 %Multiplier for PML absoroption
       rAsymptotic = 1e-15 %Infinite limit on reflection coefficient
       profile = '(lambda (u) (* u u))' %Function describing turn on behavior for PML- default is u^2
       
       
    end
    
end