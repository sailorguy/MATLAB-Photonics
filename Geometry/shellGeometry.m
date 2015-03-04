function SimGroup = shellGeometry(SimGroup,position)
%Function adds sphere geometry objects at specified position in accordance
%with the shell list in GeoPropertieObj

g = length(SimGroup.geometry); %Current length of sim group geometry

for k = 1:length(SimGroup.geoProperties.shellList)
    
    g = g+1; %Increment to next object in list
    
    %Define sphere properties for current shell
    SimGroup.geometry(g).type = 'sphere';
    SimGroup.geometry(g).center.X = position(1);
    SimGroup.geometry(g).center.Y = position(2);
    SimGroup.geometry(g).center.Z = position(3);
    SimGroup.geometry(g).radius = SimGroup.geoProperties.shellList(k).radius;
    SimGroup.geometry(g).epsilonRE = SimGroup.geoProperties.shellList(k).eps;
    
end
end