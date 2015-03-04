function cancelJobs

%Starting and ending job id's to be canceled
startJobId = 1306741 ;
endJobId = 1306758 ;

[fid, messsage] = fopen('W:\data\cancel.sh', 'w');

%Loop over all job id's
for k = startJobId:endJobId
    
    %Print cancel command
    fprintf(fid,'canceljob Moab.%u\n', k);
    
end

fclose(fid);

end