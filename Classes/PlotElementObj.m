classdef PlotElementObj < handle %Defined as HANDLE
    %This class defines a plot element (such as a fitted line)
    properties
        
        dataType %Bands or reflectance
        
        children %Sub elements for current plot element
        
        name %Name of current plot element
        legendNumber %Index for legend
        type = 'Fitted Line' %Type of plot element, (i.e. fitted line, primary daata)
        typeOptions = {'Fitted Line'}; %Only include type options other than primary data, read only
        visible = true %Indicates the current element is visible on the plot
        
        fitType = 'Smoothed Line' %Type of fit for fitted lines (i.e. exponential)
        fitTypeOptions = {'Smoothed Line', 'Urbach Tail', 'Model'}; %List of options for fit type, read only
        
        %Properties for different fit types
        smoothedProperties = SmoothLinePropertiesObj;
        urbachProperties = UrbachTailPropertiesObj;
        modelProperties = ModelPropertiesObj;
        fitPanelPosition = [2, 1, 84, 22]; %Position for fit panel, read only
        
        %Reflectance Data (computed from parent data)
        xData %X values for plot element, in normalized frequency
        yData %Y values for plot element
        
        %Bands data
        kDist %Linear distance along critical point path
        kPoints % (kx, ky, kz)
        bands %Frequnecy data by band
        
        %Appearance
        color = [0 0 1] %Plot element color vector
        
        %Line plot
        lineStyle = '-'
        lineStyleOptions = {'none', '-', '--', ':', '-.'};
        lineWidth = 2 %Plot line thickness
        
        %Scatter plot
        markerType = 'none' %Marker type
        markerTypeOptions = {'none', '+', 'o', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'}; %Read only
        markerSize = 6 %Marker size
        decimationFactor = 1 %Decimation factor to reduce number of markers displayed
        
        
    end
    
    methods
        
        function obj = computeElement(obj, parentX, parentY, k)
            
            %Compute plot element
            obj = computePlotElement(obj,parentX, parentY, k);
            
        end
        function drawElement(obj)
            
            %Call draw function for the type of element we have
            switch obj.dataType
                
                case 'Reflectance'
                    obj.drawReflectanceElement;
                    
                case 'Bands'
                    obj.drawBandsElement;
                    
            end
            
        end
        
        function drawReflectanceElement(obj)
            %This function draws a plot element
            
            global SimViewer_g
            
            %Check if the current element is set to visible
            if(~obj.visible)
                return
            end
            
            %Check if plotting by normalized frequency or wavelength
            if(SimViewer_g.normfreq)
                x = obj.xData;
            else
                x = 1./obj.xData;
            end
            
            y = obj.yData;
            
            %Check if plotting logarithmically
            if(SimViewer_g.yAxisLogarithmic)
                
                %Eliminate negative values
                x = x(obj.yData > 0);
                y = y(obj.yData > 0);
                
                %Take log of y data
                %y = log10(y);
                
                %Plot data, based upon plot type
                set(gca, 'yscale', 'log');
                h = semilogy(x, y);
                set(h, 'LineWidth', obj.lineWidth, 'LineStyle', obj.lineStyle, 'Color', obj.color);
                
                switch obj.markerType
                    
                    case 'none'
                        
                    otherwise
                        
                        set(gca, 'yscale', 'log');
                        h = semilogy(x(1:obj.decimationFactor:length(x)), y(1:obj.decimationFactor:length(y)), obj.markerType);
                        set(h, 'MarkerSize', obj.markerSize, 'MarkerEdgeColor', obj.color, 'LineWidth', .75);
                        
                end
                
            else
                
                %Plot data, marker type
                switch obj.markerType
                    
                    case 'none'
                        
                        set(gca, 'yscale', 'linear');
                        h = line(x, y);
                        set(h, 'LineWidth', obj.lineWidth, 'LineStyle', obj.lineStyle, 'Color', obj.color);
                        
                    otherwise
                        
                        set(gca, 'yscale', 'linear');
                        h = plot(x(1:obj.decimationFactor:length(x)), y(1:obj.decimationFactor:length(y)), obj.markerType);
                        set(h, 'MarkerSize', obj.markerSize, 'MarkerEdgeColor', obj.color, 'LineWidth', .75);
                        
                end
                
            end
            
            %Add legend entry if number is specified
            if(~isempty(obj.legendNumber))
                
                %Store handle to plotted item for use in legend
                SimViewer_g.reflectanceHandles(length(SimViewer_g.reflectanceHandles)+1) = h;
                
                %Store name of plotted item for use in legend
                SimViewer_g.reflectanceNames(length(SimViewer_g.reflectanceNames)+1) =  cellstr(obj.name);
                
                %Store legend number to put legend entries in correct order
                SimViewer_g.reflectanceLegendNumbers(length(SimViewer_g.reflectanceLegendNumbers)+1) = obj.legendNumber;
                
                
            end
        end
        
        function drawBandsElement(obj)
            
            %Function plots reflectance data in SimViewer_g.SimGroup(k)
            global SimViewer_g
            
            %Check if the current element is set to visible
            if(~obj.visible)
                return
            end
            
            hold on
            
            %Get number of bands
            numBands = size(obj.bands,1);
            
            h = zeros(numBands,1);
            
            %Loop over each band and plot
            for n = 1:numBands
                
                %Get data for current band
                bandData = obj.bands(n,:);
                
                %Plot
                h(n) = line(obj.kDist, bandData, 'Marker', obj.markerType, 'MarkerSize', obj.markerSize);
                
                %Plot Lines
                set(h(n), 'Color', obj.color, 'MarkerFaceColor', obj.color, 'LineWidth', obj.lineWidth, 'LineStyle', obj.lineStyle);
                
            end
            
              %Add legend entry if number is specified
            if(~isempty(obj.legendNumber))
                
                %Store handle to plotted item for use in legend
                SimViewer_g.bandHandles(length(SimViewer_g.bandHandles)+1) = h(1);
                
                %Store name of plotted item for use in legend
                SimViewer_g.bandNames(length(SimViewer_g.bandNames)+1) =  cellstr(obj.name);
                
                %Store legend number to put legend entries in correct order
                SimViewer_g.bandLegendNumbers(length(SimViewer_g.bandLegendNumbers)+1) = obj.legendNumber;
                
                
            end
        end
        
    end
end
