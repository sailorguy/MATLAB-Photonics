function readPlotElementData(controlsType)

global SimViewer_g

handles = [];
indices = [];

%Get the right handles for the current controls window
switch controlsType
    
    case 'Reflectance'
        
        %Get handle to GUI elements
        handles = guihandles(SimViewer_g.reflectanceControls_h);
        
        %Get indices for currently selected element
        indices = SimViewer_g.reflPlotControls.indices;
        
    case 'Bands'
        
        %Get handle to GUI elements
        handles = guihandles(SimViewer_g.bandControls_h);
        
        %Get indices for currently selected element
        indices = SimViewer_g.bandPlotControls.indices;
       
end

%Determine if reading SimGroup or element data
if(length(indices) < 2)
    
    %Get name
    SimViewer_g.SimGroup(indices(1)).overrideName = get(handles.edit_name, 'String');
    
else %Read element data
    
    %Get currently selected element
    [element, found] = getPlotElement(indices);
    
    %Check to make sure an element was selected
    if(~found)
        return;
    end
    
    %Get element name
    element.name = get(handles.edit_name, 'String');
    
    %Get Legend number
    element.legendNumber = uint8(str2double(get(handles.edit_legendNumber, 'String')));
    
    %Set legend number to [] if it is 0--MATLAB reads an empty edit as 0
    if(~element.legendNumber)
        element.legendNumber = [];
    end
        
    
    %Get visible toggle
    element.visible = get(handles.tog_visible, 'Value');
    
    %Get element type
    element.type = readPopup(handles.popup_elementType);
    
    %Read data based on element type
    switch element.type
        case 'Primary Data'
            %Nothing to do here
        case 'Fitted Line'
            
            %Read fit type
            element.fitType = readPopup(handles.popup_fitType);
            
            switch element.fitType
                
                case 'Smoothed Line'
                    
                    %Smoothing method
                    element.smoothedProperties.method = readPopup(handles.popup_smoothingMethod);
                    
                    %Smoothing coefficient
                    element.smoothedProperties.coeff = str2double(get(handles.edit_smoothingCoeff, 'String'));
                    
                case 'Urbach Tail'
                    
                    %X Min
                    element.urbachProperties.xMin = str2double(get(handles.edit_xMin, 'String'));
                    %X Max
                    element.urbachProperties.xMax = str2double(get(handles.edit_xMax, 'String'));
                    
                    %E1
                    element.urbachProperties.E1 = str2double(get(handles.edit_E1, 'String'));
                    
                    
                case 'Model'
                    %Data range
                    
                    %X min
                    element.modelProperties.dataXmin = str2double(get(handles.edit_modelDataXmin, 'String'));
                    %Xmax
                    element.modelProperties.dataXmax = str2double(get(handles.edit_modelDataXmax, 'String'));
                    
                    %Display Range
                    
                    %X min
                    element.modelProperties.displayXmin = str2double(get(handles.edit_modelDisplayXmin, 'String'));
                    %Xmax
                    element.modelProperties.displayXmax = str2double(get(handles.edit_modelDisplayXmax, 'String'));
                    
                    %Model Type
                    element.modelProperties.modelType = readPopup(handles.popup_modelType);
                    
            end
    end
    
    
    %Color
    element.color = get(handles.btn_color, 'BackgroundColor');
    
    %Get marker type
    element.markerType = element.markerTypeOptions{get(handles.popup_markerType, 'Value')};
    
    %Get marker size
    element.markerSize = str2double(get(handles.edit_markerSize, 'String'));
    
    %Get decimation factor
    element.decimationFactor = str2double(get(handles.edit_decimationFactor, 'String'));

    %Get line style
    element.lineStyle = element.lineStyleOptions{get(handles.popup_lineStyle, 'Value')};
    
    %Get line width
    element.lineWidth = str2double(get(handles.edit_lineWidth, 'String'));
    
end

end
