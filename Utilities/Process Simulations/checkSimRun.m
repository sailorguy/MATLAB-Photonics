function runComplete = checkSimRun(file)
%This function checks an output file (norm.txt, refl.txt) for the presence
%of flux data, and returns true if it is there, indicating that run was
%completed

%Make sure the file exists
if(~exist(file, 'file'))
    runComplete = false;
    return
end

fid = fopen(file);

%Flag to indicate if the run completed or not
runComplete = false;

%Read file line by line until
while(1)
    line = fgets(fid);
    
    if(line == -1)
        break %eof
    elseif(length(line)>7)
        if(strcmp(line(1:6), 'flux1:'))
            
            runComplete = true; %flux data found
            break
            
        end
    end
end

fclose(fid);

end