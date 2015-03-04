function [freq, trans] = computeSingleRunTransmission(reflFlux)
%This function computes reflected power from a set of normlization run and
%reflection run data

%Compute reflected power
trans = abs(reflFlux(:,3)./reflFlux(:,2));

%Eliminate spurious data above 1
%trans(:) = min(trans(:),1);

%Get normalized frequency
freq = reflFlux(:,1);

