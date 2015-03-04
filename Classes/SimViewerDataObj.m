classdef SimViewerDataObj
   %This class stores data in a global data structure for access between different functions of the SimViewer application
   
   properties
      %Windows
      main_h %Handle to main window 
      reflectance_h %Handle to reflectance plot
      reflectanceControls_h %Handle to reflectance plot controls window (not always open)
      bandControls_h %Handle to MPB plot controls window (not always open)
      band_h %Handle to band plot
      
      %Reflectance Window Controls

      %X-Axis
      normfreq %Flag to indicate normalized frequency has been selected
      normfreqmin %Minimum axes value for normalized frequency
      normfreqmax %Maximum axes value for normalized frequency
      
      wavelength %Flag to indicate wavelength has been selected
      wavelengthmin %Minimum axes value for wavelength
      wavelengthmax %Maximum axes value for wavelength 
      
      %Y-Axis
      rcoeffmin %Maximum axes value for reflection coefficient
      rcoeffmax %Minimum axes value for reflection coefficient
      yAxisLogarithmic = false; %If true, use logarithmic axis
      
      %Plotting
      reflectanceColors = ColorSpecObj; %Array of ColorSpecObj, used to keep track of in-use colors while plotting
      
      %Reflectance Legend
      reflectanceHandles %Array of handles to individual scatter groups for reflectance plot
      reflectanceNames   %Array of names corresponding to each scatter group handle
      reflectanceLegendNumbers %Indices for legend numbers, allowing user to specifiy order on plot
      
      %Data smoothing
      smoothData = false %Boolean to store checkbox value for data smoothing
      smoothDataAll = false %Boolean to store radio value for data smoothing on all datasets
      smoothDataIndividual = false %Boolean to store radio value for individual dataset smoothing 
      hideData = false; %Boolean to store value of "Hide Data" checkbox
      smoothingCoefficient = .03;

      %Reflection plot element controls window
      reflPlotControls = PlotControlsObj %Control values and handles for reflectance plot controls
      
      %Band Window Controls
      
      %X-Axis, min and max computed from data
      band_xmin
      band_xmax
      
      %Y-Axis
      band_normfreqmin %Minimum axis value for normalized frequency
      band_normfreqmax %Maximum axis value for normalized frequency
      
      %Band Legend
      bandHandles %Array of handles to individual scatter groups for reflectance plot
      bandNames   %Array of names corresponding to each scatter group handle
      bandLegendNumbers %Indices for legend numbers, allowing user to specifiy order on plot
      
      %Band plot k point labels
      labels
      labelPoints
      labelIndex
      
      %Band plot element controls window
      bandPlotControls = PlotControlsObj %Control values and handles for band plot controls
      
      %Plotting
      bandColors = ColorSpecObj; %Array of ColorSpecObj, used to keep track of in-use colors while plotting

      %Objects
      tree %Handle to java tree
      treeSelectionModel %Tree selection model
      
      %Data
      rootDirectory %Root directory for folder tree
      recentlyChecked = false %Flag to indicate if a checkbox has recently been changed
      uncheck = false %Flage to indicate a checkbox has recently been unchecked programatically    
      
      %SimGroup
      SimGroup = SimGroupObj; %Data structure for storing information about individual simulation runs
        
      %Simulation data display
      currentFolderPath %Path to folder of simulation data currently being displayed 
        
      
   end
   
   methods
   
       %Called on creation of SimViewerDataObj
       function obj = SimViewerDataObj
           
           %Initialization for reflectance colors
           %colors = ['k', 'b', 'g', 'r', 'm', 'c', 'y'];
           
           colors = [0 0 128; %dark blue
               34 139 34; %forrest green
               179 0 0; %red
               8 26 139; %purple
               255 215  0; %gold
               124 252 0; %Lime green
               79 209 204; %Turquoise
               205 41 144; %Maroon
               0 0 0]; %Black
           
            %Get rgb in matlab form
            colors = colors/255;
            
            for k = 1:length(colors)
               
                obj.reflectanceColors(k).RGB = colors(k,:);
                obj.bandColors(k).RGB = colors(k,:);
                
            end
           
           
       end
       
       
       function obj = clearReflectanceLegendData(obj)
           
          obj.reflectanceNames = {};
          obj.reflectanceHandles = [];
          obj.reflectanceLegendNumbers = [];
           
           
       end
       
        function obj = clearBandLegendData(obj)
           
          obj.bandNames = {};
          obj.bandHandles = [];
          obj.bandLegendNumbers = [];
           
           
       end
   end
end