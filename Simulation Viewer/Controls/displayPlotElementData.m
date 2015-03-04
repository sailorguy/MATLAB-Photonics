function displayPlotElementData(controlsType)

global SimViewer_g

switch controlsType
    
    case 'Reflectance'
        
        %Get handle to GUI elements
        handles = guihandles(SimViewer_g.reflectanceControls_h);
        
        %Display currently selected export folder
        set(handles.txt_exportFolder, 'String', SimViewer_g.reflPlotControls.exportFolder);
        
        %Get indices for currently selected element
        indices = SimViewer_g.reflPlotControls.indices;
        
    case 'Bands'
        
        %Get handle to GUI elements
        handles = guihandles(SimViewer_g.bandControls_h);
        
        %Display currently selected export folder
        set(handles.txt_exportFolder, 'String', SimViewer_g.bandPlotControls.exportFolder);
        
        %Get indices for currently selected element
        indices = SimViewer_g.bandPlotControls.indices;
        
end

%Determine if displaying SimGroup or element data
if(length(indices) < 2)
    
    %Hide unessecary controls
    set(handles.pnl_derived, 'visible', 'off');
    set(handles.pnl_plotAppearance, 'visible', 'off');
    
end
    
    %Set simulation name
    set(handles.txt_simName, 'String', SimViewer_g.SimGroup(indices(1)).name);
    
    %Set name
    set(handles.edit_name, 'String', SimViewer_g.SimGroup(indices(1)).overrideName);
 
    %Get currently selected element
    [element, found] = getPlotElement(indices);
      
    %Check to make sure an element was selected
    if(~found)
        return;
    end
    
    %Update display
    %Set simulation name
    set(handles.txt_simName, 'String', SimViewer_g.SimGroup(indices(1)).name);
    
    %Set element name
    set(handles.edit_name, 'String', element.name);

    %Set legend number
    set(handles.edit_legendNumber, 'String', num2str(element.legendNumber));
    
    %Show plot apperaance controls
    set(handles.pnl_plotAppearance, 'visible', 'on');
    
    %Set visible toggle
    set(handles.tog_visible, 'Value', element.visible);
    
    %Adjust display for visible toggle
    if(element.visible)
        set(handles.tog_visible, 'String', 'Visible')
        set(handles.tog_visible, 'BackgroundColor', [0 1 0]); %Green
    else
        set(handles.tog_visible, 'String', 'Hidden');
        set(handles.tog_visible, 'BackgroundColor', [1 0 0]); %Red
    end
    
    %Setup element type
    switch element.type
        case 'Primary Data'
            
            %Hide panel for derived data controls
            set(handles.pnl_derived, 'visible', 'off');
            
            %Set popup for data read
            set(handles.popup_elementType, 'String', {element.type});
            set(handles.popup_markerType, 'Value', 1);
            
        case 'Fitted Line'
            
            %Show panel for derived data controls
            set(handles.pnl_derived, 'visible', 'on')
            
            %Element type popup
            setupPopup(handles.popup_elementType, element.type, element.typeOptions);
            
            %Fit type popup
            setupPopup(handles.popup_fitType, element.fitType, element.fitTypeOptions);
            
            switch element.fitType
                
                case 'Smoothed Line'
                    
                    %Set panel location for smoothed line panel
                    set(handles.pnl_smoothedLine, 'position', element.fitPanelPosition);
                    
                    %Set panel visibility for smoothed line panel
                    set(handles.pnl_smoothedLine, 'visible', 'on');
                    
                    %Set panel visibility for Urbach tail
                    set(handles.pnl_urbachTail, 'visible', 'off');
                    
                    %Set panel visibility for Model type 
                    set(handles.pnl_model, 'visible', 'off');
                    
                    %Smoothing option
                    setupPopup(handles.popup_smoothingMethod, element.smoothedProperties.method, element.smoothedProperties.methodOptions);
                    
                    %Smoothing coefficient
                    set(handles.edit_smoothingCoeff, 'String', num2str(element.smoothedProperties.coeff));
                    
                case 'Urbach Tail'
                    
                    %Set panel location for smoothed line panel
                    set(handles.pnl_urbachTail, 'position', element.fitPanelPosition);
                    
                    %Set panel visibility for smoothed line panel
                    set(handles.pnl_smoothedLine, 'visible', 'off');
                    
                    %Set panel visibility for Urbach tail
                    set(handles.pnl_urbachTail, 'visible', 'on');
                    
                    %Set panel visibility for Model type 
                    set(handles.pnl_model, 'visible', 'off');
                    
                    %Set X Min
                    set(handles.edit_xMin, 'String', num2str(element.urbachProperties.xMin));
                    
                    %Set X Max
                    set(handles.edit_xMax, 'String', num2str(element.urbachProperties.xMax));
                    
                    %Set E1
                    set(handles.edit_E1, 'String', num2str(element.urbachProperties.E1));
                    
                    %Set text display for coefficients
                    string = sprintf('Alpha: %.3f\nE0: %.3f\nE1: %.3f\nBeta: %.3f', element.urbachProperties.alpha, ...
                        element.urbachProperties.E0, element.urbachProperties.E1, element.urbachProperties.beta);
                    set(handles.txt_urbachOutput, 'String', string);
                    
                case 'Model'
                    
                    %Set panel location for smoothed line panel
                    set(handles.pnl_model, 'position', element.fitPanelPosition);
                    
                    %Set panel visibility for smoothed line panel
                    set(handles.pnl_smoothedLine, 'visible', 'off');
                    
                    %Set panel visibility for Urbach tail
                    set(handles.pnl_urbachTail, 'visible', 'off');
                     
                    %Set panel visibility for Model type 
                    set(handles.pnl_model, 'visible', 'on');
                    
                    
                    %Data range
                    
                    %X min
                    set(handles.edit_modelDataXmin, 'String', num2str(element.modelProperties.dataXmin));
                    %Xmax
                    set(handles.edit_modelDataXmax, 'String', num2str(element.modelProperties.dataXmax));
                    
                    %Display Range
                    
                    %X min
                    set(handles.edit_modelDisplayXmin, 'String', num2str(element.modelProperties.displayXmin));
                    %Xmax
                    set(handles.edit_modelDisplayXmax, 'String', num2str(element.modelProperties.displayXmax));
                    
                    %Model Type
                    setupPopup(handles.popup_modelType, element.modelProperties.modelType, element.modelProperties.modelTypeOptions);
                    
                    %Set text display for coefficients
                    modelText = element.modelProperties.print;
                    set(handles.txt_modelOutput, 'String', modelText);
                    
            end
    end
    
    %Color
    set(handles.btn_color, 'BackgroundColor',element.color);
    
    %Marker type popup
    setupPopup(handles.popup_markerType, element.markerType, element.markerTypeOptions);
    
    %Set marker size
    set(handles.edit_markerSize, 'String', num2str(element.markerSize));
    
    %Line style popup
    setupPopup(handles.popup_lineStyle, element.lineStyle, element.lineStyleOptions);
    
    %Set marker size
    set(handles.edit_lineWidth, 'String', num2str(element.lineWidth));
    
    %Set decimation factor
    set(handles.edit_decimationFactor, 'String', num2str(element.decimationFactor));
    
    %Set scatter  and line controls to visible, line controls to hidden
    set(handles.pnl_lineControls, 'visible', 'on');
    set(handles.pnl_scatterControls, 'visible', 'on');

end
