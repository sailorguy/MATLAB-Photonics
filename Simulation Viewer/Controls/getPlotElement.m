function [element, found] = getPlotElement(indices)

global SimViewer_g

%Initalize found to indcate an element was found
found = true;
element = [];

%No element selected
if(length(indices) < 2)
    found = false;
    return;
end

%Get parent element from indices, indices will be at  least two  in length
%(SimGroup and parent data)
element = SimViewer_g.SimGroup(indices(1)).plotElement(indices(2));

if(length(indices) > 2)
    
    %Loop over length of indices to get to element
    for k = 3:length(indices)
        element = element.children(indices(k));
    end
end
