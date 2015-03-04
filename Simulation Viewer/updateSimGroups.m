function updateSimGroups(TreePath, checked)
%This function updates the loaded sim groups based upon user selections

global SimViewer_g

%If function call origniated from usere changing checkbox status, clear all
%checked flags in SimViewer_g
if(checked)
    resetCheckedFlag;
end

%Loop over all selected paths (1 if mouse press, multiple if checkbox)
for k = 1: length(TreePath)
    
    %Check folder and all sub directories to see if they are simulations
    checkDirectory(TreePath(k), checked);
    
    %Conver tree path to folder
    [folder, ~] = convertTreePathToFolders(TreePath(k));
    
end

%Call functions to update display with new SimGroups, as appropriate

%Call came from user selecting folder, check if folder is actually sim
if(~checked && isFolderSim([SimViewer_g.rootDirectory '/' folder]))
    SimDataDisplay([SimViewer_g.rootDirectory '/' folder], false);
    
    %Call came from changing checkbox, call plotting update
elseif (checked)
    ReflectancePlotUpdate('normal');
    BandPlotUpdate('normal');
    
end

end


function checkDirectory(treePath, checked)
%This function checks a directory tree for folders containing
%simulations
import java.lang.Object
import javax.swing.*;
import javax.swing.tree.*;
import com.jidesoft.swing.tree.TreePath.*
global SimViewer_g

%Conver tree path to folder
[folder, folderName] = convertTreePathToFolders(treePath);

%Check if folder is simulation
if(isFolderSim([SimViewer_g.rootDirectory '/' folder]))
    %Load simulation data
    addSimulation([SimViewer_g.rootDirectory '/' folder], folderName, checked);
    return
end

%Folder is not simulation, process children

%Get last node
node = treePath.getLastPathComponent();

%Process node children
if(node.getChildCount())
    
    %Loop over all children
    for k = 0:node.getChildCount() - 1 %Java indices start at 0
        
        %Get current child node
        currentChild = node.getChildAt(k);
        
        %Create path from child
        newTreePath = treePath.pathByAddingChild(currentChild);
        
        %Recusively call checkDirectory on new path
        checkDirectory(newTreePath, checked);
        
    end
    
    %Node has no children, uncheck checkbox
else
    
    SimViewer_g.treeSelectionModel.removeSelectionPath(treePath);
    
end
end


function sim = isFolderSim(folderPath)

%Check to see if out.txt file exists as expected in completed simulation
%folder
global SimViewer_g

%Handle average data
if(exist([folderPath '/average_data.mat'], 'file') == 2)
    sim = true;
    return;
end

%Default to false
sim = false;

if(exist([folderPath '/output/out.txt'], 'file')==2)
    
    %Check if the normalization run completed
    if(checkSimRun([folderPath '/output/norm.txt']))
        
        %Check if reflection run completed
        if(checkSimRun([folderPath '/output/refl.txt']))
            
            %Simulation completed
            sim = true;
            
        end
        
        %Check MPB Simulation
    elseif(exist([folderPath '/output/MPBout.txt'], 'file') && ...
            ((exist([folderPath '/output/MPBFreqs.txt'], 'file')) || ...
             exist([folderPath '/output/MPBFreqsTE.txt'], 'file')))
        
        %MPB Simulation
        sim = true;
        
    end
end
end


function addSimulation(folderPath, folderName, checked)
%This function adds a simulation to the global listing
global SimViewer_g

%Loop over all previously loaded simulations
for l = 1:length(SimViewer_g.SimGroup)
    %Check if current folderPath matches already loaded simulation
    if(strcmp(folderPath, SimViewer_g.SimGroup(l).SVpath))
        %Update checkbox status, if function call originated from user
        %changing checkbox
        if(checked)
            SimViewer_g.SimGroup(l).checked = true;
        end
        return
    end
end

%Simulation not already loaded, load into SimGroupObj

%Index of new SimGroup
index = length(SimViewer_g.SimGroup)+1;

%Check if index should be 1, on first object load
if(index == 2 && isempty(SimViewer_g.SimGroup(1).SVpath))
    index = 1;
end

%Check if regular simulation or averaged data
if(~exist([folderPath '/average_data.mat']))
    
    %Check to see how data is saved in .mat file
    matFile = [folderPath '/save/' folderName '.mat'];
    vars = whos('-file', matFile);
    
    %Variables stored in SimGroupObj
    if(length(vars) == 1)
        
        temp = load(matFile);
        SimViewer_g.SimGroup(index) = temp.SimGroup;
        
        %Variables stored in seperate data structures
    else
        pbs = PbsObj;
        simulation = SimulationObj;
        geometry = GeometryObj;
        sources = SourceObj;
        
        load(matFile, 'pbs', 'simulation', 'geometry', 'sources')
        
        SimViewer_g.SimGroup(index).pbs = pbs;
        SimViewer_g.SimGroup(index).simulation = simulation;
        SimViewer_g.SimGroup(index).geometry = geometry;
        SimViewer_g.SimGroup(index).sources = sources;
        
    end
    
else %Averaged data
    
    temp = load([folderPath '/average_data.mat']);
    
    SimViewer_g.SimGroup(index).normFlux = temp.norm_data;
    SimViewer_g.SimGroup(index).reflFlux = temp.refl_data;
    SimViewer_g.SimGroup(index).name = 'Average';
    SimViewer_g.SimGroup(index).averagedData = true;
    
    %Ensure simulation.type is set
    if(isempty(SimViewer_g.SimGroup(index).simulation.type))
        SimViewer_g.SimGroup(index).simulation.type = 'Reflection';
    end
        
    
    
end

%Set SimViewer flags
SimViewer_g.SimGroup(index).SVpath = folderPath;
SimViewer_g.SimGroup(index).checked = checked;

end


function resetCheckedFlag
%This function clears the checked flag for all loaded
%simulations.This flag will be set if the simulation is still
%checked.
global SimViewer_g

for l = 1:length(SimViewer_g.SimGroup)
    SimViewer_g.SimGroup(l).checked = false;
end

end


function [folder, folderName] = convertTreePathToFolders(TreePath)

%Initalize folder and path variables
folder = '';
folderName = '';

for j = 2:TreePath.getPathCount %Start at 2 to skip root folder already included in rootDirectory
    folderName = char(TreePath.getPathComponent(j-1).toString);
    folder = [folder folderName '/']; %Java indices start at 0
end

%Remove last '/' from folder
folder = folder(1:length(folder) -1 );


end