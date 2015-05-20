function writeCSV(file, headers, data)

%Open file
fid = fopen(file, 'w');

%Write headers in first row
for k = 1:(length(headers) - 1);
    
    %Write header and ,
    fprintf(fid, '%s', [headers{1,k}, ', ']);
    
end

%Write last header
fprintf(fid, '%s', headers{1,length(headers)});

%Write EOL
fprintf(fid, '\n');

%Write data, loop over rows and columns
for row = 1:size(data,1)
    for col = 1:(size(data,2)-1)
        
        %Write out current data element
        fprintf(fid, '%e ,', data(row,col));
        
    end
    
    %Write out current last element
    fprintf(fid, '%e', data(row,size(data,2)));
    
    %Write EOL
    fprintf(fid, '\n');
    
end

%Close file
fclose(fid);

end