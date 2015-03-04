function fieldMagnitudePlot

%Folders


% path = {'W:\gpfstest\1D\Fields\defectRadius\dr-0.400\R-0.217_epsS-1.0_epsL-13.0\D-6.00\n2--4.100\Log10Amp--1.000\S-1D_R-0.217_D-6.0_F-0.34__1'};
% simName = {'S-1D_R-0.217_D-6.0_F-0.34__1'};

% path = {'D:\Scratch\Directional\Radial\0.100\D-10.00\S-IDO_O-100_R-0.250+-0.100_P+-0.000_D-10.0_F-0.42__1'};
% simName = {'S-IDO_O-100_R-0.250+-0.100_P+-0.000_D-10.0_F-0.42__1'};

path = {'W:\gpfstest\IDO\X\Fields\R-0.250_epsS-13.0_epsL-1.0\Occupancy-T2000\100\D-20.00\S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-20.0_F-0.40__2'};
simName = {'S-IDO_O-100_R-0.250+-0.000_P+-0.000_D-20.0_F-0.40__2'};


useLoadedFields = false;

%Loop over paths
for k = 1:length(path)
 
    %Load simualtion fields
     SimGroup(k) = loadSimulationFields(path{k}, simName{k},[1],useLoadedFields);
          
     %Compute E field magnitude
     SimGroup(k).field = SimGroup(k).field.computeMagnitude;
     
     SimGroup(k).field.E = SimGroup(k).field.E.computeMagnitude;
     
     %Compute magnitude(k,x)
     mag(k,:) = sum(sum(abs(SimGroup(k).field.E.magnitude),2),3);
     
     x = SimGroup(k).field.E.ptX(1,:,1);
     
     %Plot magnitude
     semilogy(x,mag(1,:), 'b');
     hold on
    
     %Draw structure boundaries
     structXmin = SimGroup.geometry(2).center(1) - .5*SimGroup.geometry(2).size(1);
     structXmax = SimGroup.geometry(2).center(1) + .5*SimGroup.geometry(2).size(1);
     
     plot([structXmin, structXmin], ylim, 'g', 'linewidth', 2, 'LineStyle', '--');
     plot([structXmax, structXmax], ylim, 'g', 'linewidth', 2, 'LineStyle', '--');
     
     %Check to see if this is a half disordered slab
     if(~isempty(SimGroup.lattice.disorder.constraints(1).pt) && SimGroup.lattice.disorder.constraints(1).pt(1) == 0) 
     
         plot([0 0], ylim, 'g', 'linewidth', 2, 'LineStyle', '--');
         text(-2.5,.5*10^-3,'Ideal PC', 'FontSize', 10, 'HorizontalAlignment', 'center');
         text(2.5,.5*10^-3,'Disordered PC', 'FontSize', 10, 'HorizontalAlignment', 'center');
    
     end
     
     %Draw source
     sourceX = SimGroup.sources(1).center(1);
     
     plot([sourceX, sourceX], ylim, 'r', 'linewidth', 2);
     
     
end

set(gcf, 'Renderer', 'painters');
set(gcf, 'Position', [200 200 750 600]);
%hTitle  = title (plot_title);
hXLabel = xlabel('Position');
hYLabel = ylabel('Electromagnetic Energy Density');

set( gca, 'FontName', 'Helvetica', 'FontSize', 13);
%set([hTitle, hXLabel, hYLabel], 'FontName'   , 'AvantGarde');
set([hXLabel, hYLabel],'FontSize', 14);
%set( hTitle,'FontSize', 12,'FontWeight' , 'bold');

set(gcf, 'PaperPositionMode', 'auto');
print(gcf, 'FieldMagnitudePlot.pdf', '-dpdf')

end