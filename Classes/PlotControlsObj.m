classdef PlotControlsObj
    
   properties 
    
       plotElementTree %Handle to plot element tree
       plotElementTree_j %Handle to underlying java tree
       plotElementTreeContainer %Container for plot element tree
       
       indices %Indices for current plot element being displayed
       
       exportFolder = '' %Currently selected export folder
    
   end
end