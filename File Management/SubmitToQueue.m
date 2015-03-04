function SubmitToQueue(pbs,PbsFile)

global SimGroup

%Shell script file location
queueFile = [SimGroup.localPath '/data/qf.sh'];

%Append to end of file if discard is not set and file currently exists
if(~pbs.discard && exist(queueFile, 'file'))
   [fid,message] = fopen(queueFile, 'a');
   
%Open file, discard any data present    
else
   [fid,message] = fopen(queueFile, 'w');
end

%Write .pbs submission to file
fprintf(fid, ['\nmsub ' PbsFile '\n']);

fclose(fid);
end