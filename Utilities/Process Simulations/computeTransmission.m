function [freq,trans] = computeTransmission(normFlux,reflFlux)
%This function computes reflected power from a set of normlization run and
%reflection run data

%Compute reflected power
trans = abs(reflFlux(:,2)./normFlux(:,2));

%Eliminate spurious data above 1
%trans(:) = min(trans(:),1);

%Get normalized frequency
freq = normFlux(:,1);