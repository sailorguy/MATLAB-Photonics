function computeDOS

%Get data from k-point mesh
path = 'W:\data\simulation\MPB\IDO\DOS\R-0.250_epsS-13.0_epsL-1.0\IDO-R-0.250_epsS-13.0_epsL-1.0_a-1.0';
filename = [path '\output\MPBFreqs.txt'];
data = csvread(filename,2,7);

%Histogram parameters
minF = 0;
maxF = .8;
numBins = 300;
df = (maxF - minF)/numBins;

%Generate frequency vector (x-data)
freqs = linspace(minF, maxF, numBins);

%Generate empty dos
dos = zeros(size(freqs));

%Extract band data
band_data = data;

%Convert band data to bin number
band_data = floor(band_data/df)+1;


for x = 1:size(band_data,1)
    for y = 1:size(band_data,2)
        
        if(band_data(x,y)<length(dos))
            
            dos(band_data(x,y)) = dos(band_data(x,y))+1;
        end
        
    end
    
end

dos_plot = plot(freqs,dos);
set(gcf, 'Renderer', 'painters');
set(gcf, 'Position', [200 200 750 600]);
set(dos_plot, 'Color', [0 0 .5], 'LineWidth', 1.4);
%hTitle  = title (plot_title);
hXLabel = xlabel('\omegaa/2\pic');
hYLabel = ylabel('DOS (arb. units)');
axis([0 .6 0 5000]);

set( gca, 'FontName'   , 'Helvetica' );
%set([hTitle, hXLabel, hYLabel], 'FontName'   , 'AvantGarde');
set(gca, 'FontSize', 13);
set([hXLabel, hYLabel],'FontSize', 14);
%set( hTitle,'FontSize', 12,'FontWeight' , 'bold');

set(gcf, 'PaperPositionMode', 'auto');
print(gcf, 'DOSPLOT.pdf', '-dpdf')
