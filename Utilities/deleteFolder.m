function deleteFolder

%Folder name
folder = 'gpfstest\IDO\Clean';

%Replace \ by /
folder = strrep(folder, '\', '/');

%Open file
[fid, messsage] = fopen('W:\data\delete.sh', 'w');

%Print remove directory commnad
fprintf(fid, 'rm -r %s', folder);

%Close file
fclose(fid);

end