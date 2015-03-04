function [kDist, kPoints, bands] = MPBFreqRead(filename)
%This function reads MPB frqequency data


%Read data, starting at (1,1) to avoid row/column labels
data = csvread(filename, 1, 1);

%Get number of kpoints
numPts = size(data,1);

%Extract k indicies
kIndex = data(1:numPts, 1);

%Extract k points
kPoints = data(1:numPts, 2:4);

%Extract band data
bands = data(:,6:size(data,2));
bands = bands';

%Compute linear distance along K-path
kDist = zeros(size(kIndex));

for k = 2:length(kDist)
    
    %Compute distance to previous point
    delta = kPoints(k,:) - kPoints(k-1,:);
    dist = norm(delta);
    
    kDist(k) = kDist(k-1) + dist;
    
end