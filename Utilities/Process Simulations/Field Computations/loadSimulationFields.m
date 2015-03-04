function [SimGroup] = loadSimulationFields(path, simName, indices, useLoadedFields)

matFile = [path '/save/' simName '.mat'];

field = ElectromagneticFieldObj;
SimGroup = SimGroupObj;

%Load matlab data file
temp = load(matFile);
SimGroup = temp.SimGroup;

if(~isempty(SimGroup.field) && useLoadedFields)
    return
end

%Get file listing
listing = dir([path '/data']);

for k = 1:length(listing)
    
    %Make sure we aren't looking at a directory
    if(~listing(k).isdir)
        
        %Get file identifier
        identifier = str2double(listing(k).name(1:5));
        
        if(isnan(identifier))          
            continue;
        end
        
        %Get unique index for storage in electromagnetic field object
        uniqueIndex = SimGroup.simulation.output(identifier).uniqueIndex;
        
        if(isempty(uniqueIndex))
            continue;
        end
        
        %Only process file if the list of identifiers is empty (all files),
        %or the current file is in the list
        if(isempty(indices) || ismember(uniqueIndex, indices))
            
            %Get local index
            [index,field] = localIndex(uniqueIndex, field);
            
            %Switch on out function
            switch SimGroup.simulation.output(identifier).outFcn
     
                case 'epsilon'
                    %For now, do nothing
                    
                otherwise
                    
                    
                    %Loop over step modifiers to get data
                    for q = 1:length(SimGroup.simulation.output(identifier).StepMod)
                        
                        switch SimGroup.simulation.output(identifier).StepMod(q).condition
                            
                            case 'at-time'
                                %Get time data was saved at
                                field(index).time = SimGroup.simulation.output(identifier).StepMod(q).data;
                                
                            case 'in-volume'
                                %Get center and size of output volume
                                field(index).center = SimGroup.simulation.output(identifier).StepMod(q).volume.center;
                                field(index).XYZsize = SimGroup.simulation.output(identifier).StepMod(q).volume.size;
                                
                        end
                    end
                    
                    %Load data from file
                    h5Path = [path '/data/' listing(k).name];
                    
                    %Switch on field type
                    switch SimGroup.simulation.output(identifier).outFcn
                        
                        case 'efield' %E field
                            field(index).E = loadHDF5VectorData(h5Path, field(index).E);
                            
                        case 'hfield' %H field
                            field(index).H = loadHDF5VectorData(h5Path, field(index).H);
                            
                        case 'bfield' %B field
                            field(index).B = loadHDF5VectorData(h5Path, field(index).B);
                            
                        case 'dfield' %D field
                            field(index).D = loadHDF5VectorData(h5Path, field(index).D);
                            
                    end
                    

            end
        end
    end
end


%Loop over fields to normalize and set XYZ points
for k = 1:length(field)
    
    %Check if field is loaded
    field(k) = field(k).setLoaded;
    
    %Set XYZ points
    field(k) = field(k).computeXYZpts;
    
    %Compute field magnitude
    field(k) = field(k).computeMagnitude;
    
    %Compute Poynting Vector
    field(k) = field(k).computePoyntingVector;
    
    %Normalize
    %field(k) = field(k).normalize;
    
    
end

SimGroup.field = field;

end


function [index,field] =  localIndex(uniqueIndex,field)

%Get existing unique indices
uniqueIndices = [field.uniqueIndex];
    
    %See if there is already a ElectromagneticFieldObj for that unique
    %index
    if(ismember(uniqueIndex,uniqueIndices))
       
        index = find(uniqueIndices == uniqueIndex);
        
    else %Allocate a new object
        
        index = length(field);
        
        %Increment field, unless on first object
        if(length(field) == 1 && isempty(field(index).uniqueIndex))
            %do nothing
        else
            index = index  + 1;
        end
        
        field(index).uniqueIndex = uniqueIndex;
        
    end



end
