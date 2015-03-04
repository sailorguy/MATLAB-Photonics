function plotResonantModes

directory = {'W:\gpfstest\IDO\X\Resonance-BS\R-0.250_epsS-13.0_epsL-1.0\Occupancy\99\D-10.00',...
    'W:\gpfstest\IDO\X\Resonance-BS\R-0.250_epsS-13.0_epsL-1.0\Occupancy\95\D-10.00',...
    'W:\gpfstest\IDO\X\Resonance-BS\R-0.250_epsS-13.0_epsL-1.0\Occupancy\90\D-10.00',...
    'W:\gpfstest\IDO\X\Resonance-BS\R-0.250_epsS-13.0_epsL-1.0\Occupancy\85\D-10.00'};

%directory = {'W:\gpfstest\IDO\X\Resonance\R-0.250_epsS-13.0_epsL-1.0\Occupancy\90\D-10.00'};

colors = {'r','b','g', 'm'};
legendText = {'1%', '5%', '10%', '15%'};

for dir = 1:length(directory)
    
    %Load harminv data
    [SimGroup, dataFound] = loadHarminvSimulation(directory{dir});
    
    if(~dataFound)
        continue
    end
    
    %Histogram parameters
    minF = .2;
    maxF = .6;
    numBins = 200;
    df = (maxF - minF)/numBins;
    
    %Generate frequency vector (x-data)
    freqs = linspace(minF, maxF, numBins);
    
    %Generate empty dos
    dos = ones(size(freqs));
    
    %Loop over SimGroups
    for k = 1:length(SimGroup)
        
        %Loop over harminv points
        for h = 1:length(SimGroup(k).harminv)
            
            %Extract frequency data
            data = real(SimGroup(k).harminv(h).frequency);
                     
            %Subtract off zero point
            data = data - minF;
            
            %Convert band data to bin number
            data = floor(data/df)+1;
            
            %Add data to dos
            for d = 1:length(data)
                
                dos(data(d)) = dos(data(d)) + 1;
                
            end
            
        end
        
    end
    
    %Normalize dos by number of simulations
    dos = dos/length(SimGroup);
    
    %Plot dos
    plotHandles(dir) = plot(freqs, dos, colors{dir}, 'LineWidth', 1.4);
    
    hold on
    
end

legend(plotHandles, legendText);
set(gcf, 'Renderer', 'painters');

set(gcf, 'Position', [200 200 750 600]);
hXLabel = xlabel('\omegaa/2\pic');
hYLabel = ylabel('DDOS (arb. units)');

set( gca,'FontName'   , 'Helvetica' );
set(gca, 'FontSize', 13);
set([hXLabel, hYLabel],'FontSize', 14);

set(gcf, 'PaperPositionMode', 'auto');
print(gcf, 'DDOSPLOT.pdf', '-dpdf')


end


