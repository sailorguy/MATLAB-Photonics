function deleteFolder

%Folder name
folder = 'gpfstest\IDO\PRM\X\Reflectance-band-src\R-0.215_epsS-11.9_epsL-1.0\angularfcen-0.94_Y-10__Z-0';

%Replace \ by /
folder = strrep(folder, '\', '/');

%Open file
[fid, messsage] = fopen('W:\data\delete.sh', 'w');

%Print remove directory commnad
fprintf(fid, 'rm -r %s', folder);

%Close file
fclose(fid);

end