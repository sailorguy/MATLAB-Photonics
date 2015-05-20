function deleteFolder

%Folder name
folder = 'gpfs-scratch\test\IDO';

%Replace \ by /
folder = strrep(folder, '\', '/');

%Open file
[fid, messsage] = fopen('W:\data\delete.sh', 'w');

%Print remove directory commnad
fprintf(fid, 'rm -r %s', folder);

%Close file
fclose(fid);

end