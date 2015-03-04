function [flux, fluxFound] = FluxRead(filename)

fid = fopen(filename);
flux = [0 0];
fluxFound = false;

%Check if file is valid
if(fid == -1)
    return;
end

%Read file line by line until 
while(1)
    line = fgets(fid);
    
    if(line == -1)
        break
    elseif(length(line)>7)
        if(strcmp(line(1:6), 'flux1:'))
            
            fluxFound = true;
            
            %Eliminate Frequency Label
            Data = line(8:length(line));
            %Read values from CSV Data
            Data = strread(Data,'%f', 'delimiter', ',');
           
            %Append to flux matrix
            if(length(flux) == 2)%Check if flux is empty
                flux=Data';
            else
            flux = [flux;Data'];
            end
            
        end
    end
end

fclose(fid);

end