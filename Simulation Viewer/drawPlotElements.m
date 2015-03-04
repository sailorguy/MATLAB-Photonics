function drawPlotElements(k)
%This function loops over plot elements and their children, drawing them to
%the current axes, for the SimGroup with index k

global SimViewer_g

%Hold to allow plotting of multiple elements
hold on

%Loop over all root level elements (that don't use parent data)
for n = 1:length(SimViewer_g.SimGroup(k).plotElement)
    
    %Draw current element
    SimViewer_g.SimGroup(k).plotElement(n).drawElement;
    
    %Process child elements if they exist
    if(~isempty(SimViewer_g.SimGroup(k).plotElement(n)))
        processChildElements(SimViewer_g.SimGroup(k).plotElement(n), k);
        
    end
    
end
end

function processChildElements(parentElement, k)

%Get parent data
parentX = parentElement.xData;
parentY = parentElement.yData;

%Loop over all child elements
for n = 1:length(parentElement.children)
    
    %Compute element
    parentElement.children(n) = parentElement.children(n).computeElement(parentX, parentY, k);
    
    %Draw element
    parentElement.children(n).drawElement;
    
    %Process any children of the current element using recursive call
    processChildElements(parentElement.children(n), k);
    
end

end

