function createPlotElementTree(controlsType)
global SimViewer_g

%Get handles to correct plot type
switch controlsType
    
    case 'Reflectance'
        
        %Get handles for reflectance controls window
        handles = guihandles(SimViewer_g.reflectanceControls_h);
        SimViewer_g.reflPlotControls = buildTree(handles, SimViewer_g.bandPlotControls,controlsType);
        
    case 'Bands'
        
        %Get handles for reflectance controls window
        handles = guihandles(SimViewer_g.bandControls_h);
        SimViewer_g.bandPlotControls = buildTree(handles, SimViewer_g.bandPlotControls,controlsType);
        
end
end

function [plotControls] = buildTree(handles, plotControls, controlsType)
import javax.swing.tree.*;
import javax.swing.*;
import java.util.Enumeration.*;

global SimViewer_g

%Create root node
root = uitreenode('v0', '0' ,'Plot Elements',[],false);
selectNode = [];

simFound = false;

%Process plot elements to create tree nodes and children
%Loop over all imported SimGroups
for k = 1:length(SimViewer_g.SimGroup)
    
    %Check if simulation is right kind
    if(  (strcmp(SimViewer_g.SimGroup(k).type, 'MEEP') && strcmp(controlsType, 'Reflectance')) || ...
         (strcmp(SimViewer_g.SimGroup(k).type, 'MPB') && strcmp(controlsType, 'Bands'))  )
        
        
        %Check to see if the group is checked
        if(SimViewer_g.SimGroup(k).checked)
            
            name = SimViewer_g.SimGroup(k).name;
            
            %Create node for current simulation
            simNode = uitreenode('v0', num2str(k), name, [], false);
            
            
            %Loop over all plot elements in current SimGrouo
            for n = 1:length(SimViewer_g.SimGroup(k).plotElement)
                
                %Get plot element name
                name = SimViewer_g.SimGroup(k).plotElement(n).name;
                
                %Define new plot element nodes
                plotElementNode = uitreenode('v0', num2str(n), name, [], false);
                
                %Store node to be selected if first simulation
                if (simFound == false)
                    
                    simFound = true;
                    selectNode = plotElementNode;
                end
                
                %Recursively process children
                plotElementNode = addPlotElementChildren(SimViewer_g.SimGroup(k).plotElement(n),plotElementNode);
                
                %Add node to current simulation
                simNode.add(plotElementNode);
                
            end
            root.add(simNode);
        end
        
    end
    
    %Create tree, set container to tree panel
    treeModel = DefaultTreeModel(root);
    [plotControls.plotElementTree, plotControls.plotElementTreeContainer] ...
        = uitree('v0', 'Root',root,'Parent',handles.pnl_plotElementTree, ...
        'SelectionChangeFcn', {@selectionChanged_cb,controlsType}); % Parent is ignored
    
    set(plotControls.plotElementTreeContainer, 'Parent', handles.pnl_plotElementTree);  % fix the uitree Parent
    
    %Get Java handle
    jtree =  handle(plotControls.plotElementTree.getTree, 'CallbackProperties');
    plotControls.plotElementTree_j = jtree;
    
    %Expand root node
    plotControls.plotElementTree.expand(root);
    
    %Expand and select first simulation
    plotControls.plotElementTree.expand(selectNode);
    plotControls.plotElementTree.setSelectedNode(selectNode);
    
    %Set tree size to panel size
    old_units = get(handles.pnl_plotElementTree, 'Units');
    set(handles.pnl_plotElementTree, 'Units', 'pixels');
    panelPos = get(handles.pnl_plotElementTree, 'Position');
    set(handles.pnl_plotElementTree, 'Units', old_units);
    
    %Define border
    border = 0*panelPos(3);
    
    %Calculate panel width and height, and left bottom corner location
    width = panelPos(3) - 2*border;
    height = panelPos(4) - 2*border;
    left = panelPos(1) + border;
    bottom = panelPos(2) + border;
    
    %Set tree size and placement
    plotControls.plotElementTree.Position = [left, bottom, width, height];
    
    %Set jtree callback functions
    set(jtree, 'MousePressedCallback', {@mousePressed_cb, controlsType});
    
    
end
end

function selectionChanged_cb(~, ~, controlsType)

global SimViewer_g

switch controlsType
    
    case 'Reflectance'
        
        %Get handle to underlying java tree
        jtree = SimViewer_g.reflPlotControls.plotElementTree_j;
        
        %Set indices currently selected
        SimViewer_g.reflPlotControls.indices = getIndicesFromTreePath(jtree.getSelectionPath);
        
    case 'Bands'
        %Get handle to underlying java tree
        jtree = SimViewer_g.bandPlotControls.plotElementTree_j;

        %Set indices currently selected
        SimViewer_g.bandPlotControls.indices = getIndicesFromTreePath(jtree.getSelectionPath);
        
end

%Update plot element display
displayPlotElementData(controlsType);

end

function mousePressed_cb(htree, eventData, controlsType)

global SimViewer_g

if eventData.isMetaDown  % right-click is like a Meta-click
    
    %Get the right jtree handle
    switch controlsType
        case 'Reflectance'
            %Get handle to underlying java tree
            jtree = SimViewer_g.reflPlotControls.plotElementTree_j;
            
        case 'Bands'
            
            %Get handle to underlying java tree
            jtree = SimViewer_g.bandPlotControls.plotElementTree_j;         
    end
    
    % Get the clicked node
    clickX = eventData.getX;
    clickY = eventData.getY;
    treePath = jtree.getPathForLocation(clickX, clickY);
    
    if(isempty(treePath)) %Click is not on a node
        return;
    end
    
    % Prepare the context menu (note the use of HTML labels)
    menu_add = javax.swing.JMenuItem('Add new child element');
    menu_delete = javax.swing.JMenuItem('Delete element');
    
    % Set the menu items' callbacks
    set(handle(menu_add, 'CallbackProperties'),'ActionPerformedCallback',{@addPlotElement_cb, treePath, controlsType});
    set(handle(menu_delete, 'CallbackProperties'),'ActionPerformedCallback',{@deletePlotElement_cb, treePath, controlsType});
    
    % Add all menu items to the context menu (with internal separator)
    jmenu = javax.swing.JPopupMenu;
    jmenu.add(menu_add);
    jmenu.add(menu_delete);
    
    %Display the context menu menu
    jmenu.show(jtree, clickX, clickY);
    jmenu.repaint;
    
end

end

function addPlotElement_cb(hObject, eventData, treePath, controlsType)

global SimViewer_g

%Get handle to correct tree depending on controls type
tree = [];
switch controlsType
    
    case 'Reflectance'
        tree = SimViewer_g.reflPlotControls.plotElementTree;
        
    case 'Bands'
        tree = SimViewer_g.bandPlotControls.plotElementTree;
end

%Get indices from treePath
indices = getIndicesFromTreePath(treePath);

%Get parent of item being added
parent = getPlotElement(indices);

%Get parent node of item being added
parentNode = treePath.getPathComponent(treePath.getPathCount - 1); %Java indices start at 0

%Add new child
index = length(parent.children) + 1;

%Instantiate PlotElementObj class as children, if nessecary
if isempty(parent.children)
    parent.children = PlotElementObj;
end

%Inherit color, name and data type from parent
parent.children(index).name = parent.name;
parent.children(index).color = parent.color;
parent.children(index).dataType = parent.dataType;

%Build new node for child
childNode = uitreenode('v0', num2str(index), parent.children(index).name, [], false);

%Add child node
parentNode.add(childNode)

%Reload parent
tree.reloadNode(parentNode);

%Set new child as  selected node
tree.setSelectedNode(childNode)

end

function deletePlotElement_cb(hObject, eventData, treePath,controlsType)

global SimViewer_g

%Get handle to correct tree depending on controls type
tree = [];
switch controlsType
    
    case 'Reflectance'
        tree = SimViewer_g.reflPlotControls.plotElementTree;
        
    case 'Bands'
        tree = SimViewer_g.bandPlotControls.plotElementTree;
end

%Get indices from treePath
indices = getIndicesFromTreePath(treePath);

%Get index of item to be deleted, referenced to its parent
childIndex = indices(length(indices));

%Crop indices by one element to get parent for item being deleted
indices = indices(1:length(indices)-1);

%Get parent of item being deleted
parent = getPlotElement(indices);

%Delete child
parent = deletePlotElementFromParent(parent, childIndex);

%Get node to be deleted
node = treePath.getPathComponent(treePath.getPathCount - 1); %Java indices start at 0

%Get parent
parentNode = node.getParent;

%Set parent as new selected node
tree.setSelectedNode(parentNode)

%Remove all children of the parent node
parentNode.removeAllChildren();

%Rebuild parent node
parentNode = addPlotElementChildren(parent, parentNode);

%Reload parent
tree.reloadNode(parentNode);

end

function [parentNode] = addPlotElementChildren(plotElement, parentNode)

%Return if no children
if(isempty(plotElement.children))
    return;
end

%Loop over all children of current plot element
for  k = 1:length(plotElement.children)
    
    %Get name
    name = plotElement.children(k).name;
    
    %Define new node
    childNode = uitreenode('v0', num2str(k), name, [], false);
    
    %Recursively add sub-children
    addPlotElementChildren(plotElement.children(k), childNode);
    
    %Add new node to parent
    parentNode.add(childNode);
    
end
end


function [indices] = getIndicesFromTreePath(treePath)

%Initialize indices
indices = [];

%Get indices for path, first component is root
for k = 1:(treePath.getPathCount - 1)
    
    indices(k) = uint16(str2double(treePath.getPathComponent(k).getValue)); %Java indices start at 0
    
end
end

function [parent] = deletePlotElementFromParent(parent, childIndex)

%Check if parent has more than one child
if(length(parent.children) == 1)
    parent.children = [];
    return
end

if childIndex < length(parent.children)
    %Loop over all children after the one being deleted, move them up in index
    for k = (childIndex + 1):length(parent.children)
        
        %Move up element k to position k-1
        parent.children(k-1) = parent.children(k);
        
    end
end

%Delete last element (either one to be delted, or dupilcate)
parent.children = parent.children(1:length(parent.children) - 1);

end