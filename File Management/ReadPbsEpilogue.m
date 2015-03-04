function  pbsEpi = ReadPbsEpilogue(filename)

%Open output file for processing
[fid,message] = fopen(filename);


%Create data structure to store epilogue data
pbsEpi = PbsEpilogueObj;


%Read file line by line until 
while(1)
    line = fgets(fid);
    
    if(line == -1)
        break
    elseif(length(line)>=18)
        if(strcmp(line(1:18), 'Begin PBS Epilogue'))
            
            %Get Job ID
            line = fgets(fid);
            pbsEpi.JobID = line(14:length(line)-1);
            
            %Get User ID
            line = fgets(fid);
            pbsEpi.UserID = line(14:length(line)-1);
            
            %Get Job Name
            line = fgets(fid);
            pbsEpi.JobName = line(13:length(line)-1);
            
            %Get Resources
            line = fgets(fid);
            pbsEpi.Resources = line(13:length(line)-1);
            
            %Get Resources Used
            line = fgets(fid);
            Data = line(14:length(line));
            
            %Read values from CSV Data
            Data =  textscan(Data, '%s %s %s %s', 1, 'delimiter', ',');
           
            %Read in resources
            %CPU Time
            pbsEpi.cput = char(Data{1});
            pbsEpi.cput = pbsEpi.cput(5:length(pbsEpi.cput));
            
            %Memory
            pbsEpi.mem = char(Data{2});
            pbsEpi.mem = pbsEpi.mem(5:length(pbsEpi.mem)-2);
            
            %Virtual Memory
            pbsEpi.vmem = char(Data{3});
            pbsEpi.vmem = pbsEpi.vmem(6:length(pbsEpi.vmem)-2);
            
            %Walltime
            pbsEpi.walltime = char(Data{4});
            pbsEpi.walltime = pbsEpi.walltime(10:length(pbsEpi.walltime));
            
            
        end
    end
end


end