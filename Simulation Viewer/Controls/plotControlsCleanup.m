function plotControlsCleanup(controlsType)

global SimViewer_g

switch controlsType
    
    case 'Reflectance'
        
        %Delete container for plot element tree
        delete(SimViewer_g.reflPlotControls.plotElementTree);
        
    case 'Band'
        
        %Delete container for plot element tree
        delete(SimViewer_g.bandPlotControls.plotElementTree);
        
        
end


end