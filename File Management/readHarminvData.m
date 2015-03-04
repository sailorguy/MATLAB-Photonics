function [SimGroup, dataFound] = readHarminvData(file,SimGroup)

fid = fopen(file);

%Check if file is valid
if(fid == -1)
    return;
end

dataFound = false;

k = 0; %Initalize harminv index, for multiple harminv points
index = 1; %Data index

%Read file line by line until we reach a harminv label
while(1)
    line = fgets(fid);
    if(line == -1)
        break %EOF
    elseif(length(line)>8)
        if(strcmp(line(1:9), 'harminv0:'))
            
            if(strcmp(line(12:20),'frequency'))
                %Header row, skip this data
                
                %Increment harminvIndex counter
                k = k + 1;
                
                %Reset data index
                index = 1;
                
            else
                
                dataFound = true;
                
                %Eliminate Harminv0 Label
                data = line(12:length(line));
                %Read values from CSV data
                %frequency, imag.frequency, Q, |amp|,amplitude, error
                C = textscan(data,'%s');
                
                SimGroup.harminv(k).frequency(index) = str2double(C{1}{1})+1i*str2double(C{1}{2}); %Frequency (real + imag)
                SimGroup.harminv(k).Q(index) = str2double(C{1}{3}); %Q value
                ampTemp =  textscan(C{1}{5},'%f'); %Amplitdue (real + imag)
                SimGroup.harminv(k).amplitude(index) = ampTemp{1};
                SimGroup.harminv(k).error(index) = str2double(C{1}{6}); %Error
                
                index = index + 1;
                
            end
        end
    end
end

fclose(fid);
end