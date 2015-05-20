function [cropData] = midCropVector(data,percentage)

minIndex = floor(.5*(1-percentage)*length(data));
maxIndex = ceil((.5*(1-percentage)+percentage)*length(data));

cropData = data(minIndex:maxIndex);


end