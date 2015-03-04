function [freq,refl] = computeReflectance(normFlux,reflFlux)
%This function computes reflected power from a set of normlization run and
%reflection run data

%Compute reflected power
refl = abs(reflFlux(:,3)./normFlux(:,3));

%Eliminate spurious data above 1
%refl(:) = min(refl(:),1);

%Get normalized frequency
freq = normFlux(:,1);

