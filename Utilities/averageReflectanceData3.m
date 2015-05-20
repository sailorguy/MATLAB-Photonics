function [freq, refl_avg, trans_avg] = averageReflectanceData3(frequency, refl_data, trans_data)

freq = mean(frequency)';
refl_avg = mean(refl_data)';
trans_avg = mean(trans_data)';