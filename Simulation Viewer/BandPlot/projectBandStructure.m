function projectBandStructure

global SimViewer_g

%Loop over all imported SimGroups
for k = 1:length(SimViewer_g.SimGroup)
    
    %Check to see if the group is checked
    if(SimViewer_g.SimGroup(k).checked)
        
        %Check if simulation is an MPB simulation
        if(strcmp(SimViewer_g.SimGroup(k).type,'MPB'))
            
            plotProjectedBandStructure(k);
            
        end
        
    end
end

end

function plotProjectedBandStructure(k)

global SimViewer_g

%Get band data
kDist = SimViewer_g.SimGroup(k).kDist;
kPoints = SimViewer_g.SimGroup(k).kPoints;
bands = SimViewer_g.SimGroup(k).bands;

KptsXYZ = kPoints(:,1)*SimViewer_g.SimGroup.lattice.b1 + kPoints(:,2)*SimViewer_g.SimGroup.lattice.b2 + kPoints(:,3)*SimViewer_g.SimGroup.lattice.b3;
KptsXYZ = KptsXYZ/(2*pi);
Kyz = zeros(size(kPoints,1),1);

%Loop over all kPoints
for m = 1:size(KptsXYZ,1)
    
    %Extract Kyz
    Kyz(m) = norm(KptsXYZ(m,2:3));
       
end

%Plotting
figure
hold on

%Loop over bands
for n = 1:size(bands,1)
 
    bandData = bands(n,:);
    
    scatter(Kyz, bandData);

end

%Plot light line
plot(Kyz, Kyz, 'r');

end