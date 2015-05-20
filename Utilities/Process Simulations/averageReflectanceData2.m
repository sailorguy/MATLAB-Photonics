function [unique_freq, refl_avg, trans_avg] = averageReflectanceData2(frequency, refl_data, trans_data)

%Get unique frequencies
unique_freq = unique(frequency);

%Preallocate norm_avg and refl_avg

refl_avg = zeros(length(unique_freq), 1);
trans_avg = zeros(length(unique_freq), 1);

%Write in frequency values
refl_avg(:,1) = unique_freq;
trans_avg(:,1) = unique_freq;

%Loop over unique frequencies
for k = 1:length(unique_freq)
    
    rows = frequency == unique_freq(k);
    refl_avg(k) = mean(refl_data(rows));
    trans_avg(k) = mean(trans_data(rows));
    
end