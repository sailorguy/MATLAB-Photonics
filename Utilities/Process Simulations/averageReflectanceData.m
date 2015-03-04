function [norm_avg, refl_avg] = averageReflectanceData(norm_data, refl_data)

%Get frequencies
freq_data = norm_data(:,1);

numBins = 2000;

%Get min and max values for bin edges
minFreq = min(freq_data);
maxFreq = max(freq_data);

%Generate bin edges for numBins bins
bin_edges = linspace(minFreq, maxFreq, numBins+1);

%Sort frequency data into bins
[h, whichBin] = histc(freq_data,bin_edges);

%Preallocate average data arrays
norm_avg = zeros(numBins,1);
refl_avg = zeros(numBins,1);


for k = 1:numBins

    %Get reflectance data corresponding to current bin
    flagBinMembers = (whichBin == k);
    normBinMembers = norm_data(flagBinMembers);
    reflBinMembers = refl_data(flagBinMembers);
    
    %Average normalization data
    norm_avg(k) = mean(normBinMembers);
    
    %Average reflectance data
    refl_avg(k) = mean(reflBinMembers);
    
end
