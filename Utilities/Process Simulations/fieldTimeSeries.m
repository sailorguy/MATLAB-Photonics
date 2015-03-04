function fieldTimeSeries

%Folders

path = {'D:\Scratch\O-100_R-0.480+-0.000_P+-0.000_D-15.0_F-0.474__1'};
simName = {'O-100_R-0.480+-0.000_P+-0.000_D-15.0_F-0.474__1'};
movieFile = 'Field Time Series/Hfield.mp4';


times = 1:1;

useLoadedFields = false;

curMax = 0;

for k = 1:length(path)
    
    %Load simualtion fields
    SimGroup(k) = loadSimulationFields(path{k}, simName{k},times, useLoadedFields);
    
    
    
end

frames = zeros(390,482,1);
framesX = zeros(390,482,1);
framesY = zeros(390,482,1);

%Set up movie
times = linspace(0,2*pi,1000);

%Loop over times
for t = 1:length(times)
    
    %Rotate fields
    SimGroup.field = SimGroup.field.scalarMultiplyField(exp(1i*times(t)));
    
    SimGroup.field = SimGroup.field.computePoyntingVector;
    SimGroup.field.S = SimGroup.field.S.computeMagnitude;
    
    %     energy = SimGroup.field.instantaneousElectromagneticEnergy;
    %
    %     imagesc(energy);
    %
    %     max(energy(:))
    
    maxVal = max(abs(sqrt(SimGroup.field.H.X(:).^2 + SimGroup.field.H.Y(:).^2)));
    
    normVal = maxVal/sqrt(2);
    
    x = real(SimGroup.field.H.X)/normVal;
    y = real(SimGroup.field.H.Y)/normVal;
    
    framesX(:,:,t) = x;
    framesY(:,:,t) = y;
    frames(:,:,t) = real(SimGroup.field.E.Z);
    
    maxEVal = max(abs(SimGroup.field.E.Z(:)));
    
    
    %     file = sprintf('Field Time Series/Ez/%.2f.jpg', times(t));
    %     print(gcf, file, '-djpeg');
    
    %Undo field rotation
    SimGroup.field = SimGroup.field.scalarMultiplyField(1/exp(1i*times(t)));
    
end


%Set up movie
writerObj = VideoWriter(movieFile, 'MPEG-4');
writerObj.open;

%Normalize frames
framesX = framesX/max(abs(framesX(:)));
framesY = framesY/max(abs(framesY(:)));

for k = 1:size(framesX,3)
    
    
    [szY, szX, ~] = size(framesX);
     xmin = .4*szX;
     xmax = .6*szX;
     ymin = .4*szY;
     ymax = .6*szY;
    
    %surf(frames(:,:,k), 'LineStyle', 'none', 'FaceLighting', 'gouraud');
    %camlight right
    
    quiver(framesX(:,:,k),framesY(:,:,k),0);
    
    axis([xmin xmax ymin ymax]);
    
    %imagesc(frames(:,:,k),[-1*maxEVal,maxEVal])

    set(gcf, 'Position', [0 0 800 600]);

    writerObj.writeVideo(getframe(gcf));
end

writerObj.close;

end
