function defectDOSX

directory = 'W:\gpfstest\IDO\X\Resonance\R-0.250_epsS-13.0_epsL-1.0\Occupancy\85\D-20.00';


%Load harminv data
SimGroup = loadHarminvSimulation(directory);

%Histogram parameters

%X distance
minX = -10;
maxX = 10;
xBins = 20;
dX = (maxX - minX)/xBins;

%Generate X distance basis
X = linspace(minX, maxX, xBins);

%Y frequency
minF = .3;
maxF = .5;
fBins = 100;
df = (maxF - minF)/fBins;

%Generate frequency basis
freqs = linspace(minF, maxF, fBins);


%Generate empty dos
dos = zeros(size(X,2),size(freqs,2));

%Loop over SimGroups
for k = 1:length(SimGroup)
    
    %Loop over harminv points
    for h = 1:length(SimGroup(k).harminv)
        
        %Get X value for monitoring point
        xPt = SimGroup(k).harminv(h).pt(1);
        
        if(xPt>=minX && xPt<=maxX)
            
            %Determine X bin
            xPt = xPt - minX;
            
            xBin = floor(xPt/dX) + 1;
            
            %Extract frequency data
            data = real(SimGroup(k).harminv(h).frequency);
            
            %Subtract off zero point
            data = data - minF;
            
            %Convert band data to bin number
            data = floor(data/df)+1;
            
            %Add data to dos
            for d = 1:length(data)
                
                dos(xBin,data(d)) = dos(xBin,data(d)) + 1;
                
            end
            
        end
        
    end
    
end

%Plot dos

surf(X,freqs, dos');

end


