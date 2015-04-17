function pbsScript(SimGroup)
%This function generates PBS scripts to run MEEP on a computing cluster

%Open create .pbs file in simulation directory, see 'writeSimFiles' for
%details
[fid, message] = fopen([SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/' SimGroup.name '.pbs'], 'w');

%File name
fprintf(fid,'#PBS -N %s\n', SimGroup.name);

%Physical requirements
%fprintf(fid,'#PBS -l nodes=%u:ppn=%u\n',SimGroup.pbs.nodes, SimGroup.pbs.ppn);
fprintf(fid,'#PBS -l nodes=%u\n',SimGroup.pbs.nodes); %Modified to allow flexible scheduling with new PACE scheduler, JK 2014
%fprintf(fid,'#PBS -l nodes=%u:ibQDR\n',SimGroup.pbs.nodes); %Modified to allow flexible scheduling with new PACE scheduler, JK 2014

if(SimGroup.pbs.mem~=0)
    fprintf(fid,'#PBS -l mem=%ugb\n',SimGroup.pbs.mem);
else
    fprintf(fid,'#PBS -l pmem=%ugb\n', SimGroup.pbs.pmem);
end

fprintf(fid, '#PBS -l walltime=%u:00:00\n',SimGroup.pbs.walltime);

% Queue
fprintf(fid, '#PBS -q %s\n', SimGroup.pbs.queue);

%File management
fprintf(fid, '#PBS -o %s\n', [SimGroup.dir '/' SimGroup.name '/output/out.txt']);
fprintf(fid, '#PBS -e %s\n', [SimGroup.dir '/' SimGroup.name '/output/error.txt']);
% fprintf(fid, '#PBS -j -oe\n');
% fprintf(fid, '#PBS -o %s\n', [SimGroup.dir '/' SimGroup.name '/output/out.txt']);

%Email
if(SimGroup.pbs.emailFlag)
    fprintf(fid, '#PBS -m %s\n', SimGroup.pbs.notify);
    fprintf(fid, '#PBS -M %s\n', SimGroup.pbs.email);
end

%Leave space before commnads for readaiblity
fprintf(fid, '\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Commands to be run
%This section describes command line inputs to be run on the cluster, once
%the resources described above have been allocated.

fprintf(fid, 'source /etc/profile.d/modules.csh\n');

%Ensure that command prompt is at home directory
fprintf(fid, 'cd\n');

%Clear any loaded modules
fprintf(fid, 'module purge\n\n');

switch SimGroup.type
    
    
    case 'MEEP'
        
        %Ensure that modules are loaded
        if(SimGroup.pbs.default)
            fprintf(fid, 'source ~/.pacemodules\n');
        else
            fprintf(fid, 'module load %s\n',SimGroup.pbs.compiler);
            fprintf(fid, 'module load %s\n',SimGroup.pbs.mpiVersion);
            fprintf(fid, 'module load %s\n',SimGroup.pbs.harminvVersion);
            fprintf(fid, 'module load %s\n',SimGroup.pbs.libctlVersion);
            fprintf(fid, 'module load %s\n',SimGroup.pbs.fftwVersion);
            fprintf(fid, 'module load %s\n', SimGroup.pbs.hdf5Version);
            fprintf(fid, 'module load %s\n', SimGroup.pbs.meepVersion);
            
        end
        
        %Debugging runtime parameters (2)
        fprintf(fid, '\n\n');
        %         fprintf(fid, 'export     OMPI_MCA_mpool_rdma_rcache_size_limit=209715200\n');
        %         fprintf(fid, 'export     OMPI_MCA_btl_openib_flags=1\n');
        %         fprintf(fid, 'export     OMPI_MCA_plm_rsh_num_concurrent=768\n');
        %         fprintf(fid, 'export     OMPI_MCA_btl=openib,self\n');
        fprintf(fid, '\n\n');
        
        
        %Check to see if pre-generated normalization data needs to be
        %copied to the simulation directory
        if(SimGroup.simulation.usePreGeneratedNormData)
            
            dataPath = [SimGroup.dir '/' SimGroup.name '/data'];
            outputPath = [SimGroup.dir '/' SimGroup.name '/output'];
            fprintf(fid, '%s\n', ['cp ' SimGroup.simulation.preGeneratedNormDataPath '/data/refl-flux.h5 ' dataPath]); %.h5 file
            fprintf(fid, '%s\n', ['cp ' SimGroup.simulation.preGeneratedNormDataPath '/output/norm.txt ' outputPath]); %output data from normalization run
        end
        
        
        %Meep Command
        meepMPI = ['mpirun -np ' num2str(SimGroup.pbs.nodes*SimGroup.pbs.ppn) ...
            ' -hostfile $PBS_NODEFILE meep-mpi '];
        
        %Run MEEP, using cluster referenced file path to .ctl file(s)
        if(strcmp(SimGroup.simulation.type, 'Reflection'))
            
            %Check if simulation run is only for reflectance (no
            %normalization)
            if(~SimGroup.simulation.reflOnly)
                %Reflectance simulation run, run normalization file first
                fprintf(fid, [meepMPI  SimGroup.dir '/' SimGroup.name '/' SimGroup.name 'Norm.ctl | tee '...
                    SimGroup.dir '/' SimGroup.name '/output/norm.txt\n']);
            end
            %Run reflectance simulation
            fprintf(fid, [meepMPI  SimGroup.dir '/' SimGroup.name '/' SimGroup.name '.ctl | tee '...
                SimGroup.dir '/' SimGroup.name '/output/refl.txt\n']);
            %Extract frequencies from refl.txt, after simulation has
            %completed
            fprintf(fid,['grep flux1' SimGroup.dir '/' SimGroup.name  '/' 'output/refl.txt > '...
                SimGroup.dir '/' SimGroup.name '/' 'output/freqs.txt\n']);
            
        else
            
            %Standard simulation run
            fprintf(fid, [meepMPI SimGroup.dir '/' SimGroup.name '/' SimGroup.name '.ctl | tee '...
                SimGroup.dir '/' SimGroup.name '/output/refl.txt\n']);
            
        end
        
    case 'MPB'
        
        
        %Ensure that modules are loaded
        fprintf(fid, 'module load %s\n',SimGroup.pbs.compiler);
        fprintf(fid, 'module load %s\n',SimGroup.pbs.mpiVersion);
        fprintf(fid, 'module load %s\n',SimGroup.pbs.fftwVersion);
        fprintf(fid, 'module load %s\n',SimGroup.pbs.libctlVersion);
        fprintf(fid, 'module load %s\n', SimGroup.pbs.hdf5Version);
        fprintf(fid, 'module load %s\n', SimGroup.pbs.mpbVersion);
        
        switch  SimGroup.MPBSimulation.dimensionality
            
            case '1D'
                
                %Ensure that modules are loaded
                fprintf(fid, 'module load %s\n',SimGroup.pbs.compiler);
                fprintf(fid, 'module load %s\n',SimGroup.pbs.mpiVersion);
                fprintf(fid, 'module load fftw/2.1.5\n');
                fprintf(fid, 'module load libctl/3.1\n');
                fprintf(fid, 'module load %s\n', SimGroup.pbs.hdf5Version);
                fprintf(fid, 'module load %s\n', SimGroup.pbs.mpbVersion);
                
                
                %Change directory to simulation directory
                fprintf(fid, ['cd ' SimGroup.dir '/' SimGroup.name '\n']);
                
                %Run MPB using path to .ctl file
                fprintf(fid, ['mpb ' SimGroup.name 'MPB.ctl | tee ' 'output/MPBout.txt\n']);
                
                %Extract frequencies from MPBout.txt, after simulation has
                %completed
                fprintf(fid, 'grep freqs output/MPBout.txt > output/MPBFreqs.txt\n');
                
                 %Post process output files, propagate for extra periods
                for k = 1:length(SimGroup.MPBSimulation.MPBh5Files)
                    %Check if current file output is in use
                    if(SimGroup.MPBSimulation.MPBh5Files(k).inUse_FLAG)
                        fprintf(fid, 'mpb-data -r -m %u -n %u %s\n',...
                            SimGroup.MPBSimulation.MPBh5Files(k).periods, SimGroup.MPBSimulation.MPBh5Files(k).resolution, ...
                            SimGroup.MPBSimulation.MPBh5Files(k).name);
                    end
                end
                
                
            case '3D' 
                
%                 %Ensure that modules are loaded
%                 fprintf(fid, 'module load gcc/4.4.5\n');
%                 fprintf(fid, 'module load openmpi/1.4.3\n');
%                 fprintf(fid, 'module load fftw/2.1.5\n');
%                 fprintf(fid, 'module load libctl/3.1\n');
%                 fprintf(fid, 'module load hdf5/1.8.9_parallel\n');
%                 fprintf(fid, 'module load mpb-hdf_1.8.9-test/1.4.2_hdf_test\n');
                
                %MPB Command
                mpbMPI = ['mpirun -np ' num2str(SimGroup.pbs.nodes*SimGroup.pbs.ppn)  ' -hostfile $PBS_NODEFILE mpb-mpi '];
                
                %Change directory to simulation directory
                fprintf(fid, ['cd ' SimGroup.dir '/' SimGroup.name '\n']);
                
                %Run MPB using path to .ctl file
                fprintf(fid, [mpbMPI SimGroup.name 'MPB.ctl | tee ' 'output/MPBout.txt\n']);
                
                %Extract frequencies from MPBout.txt, after simulation has
                %completed
                fprintf(fid, 'grep freqs output/MPBout.txt > output/MPBFreqs.txt\n');
                
                %Remove loaded modules
                fprintf(fid, 'module rm %s\n',SimGroup.pbs.compiler);
                fprintf(fid, 'module rm %s\n',SimGroup.pbs.mpiVersion);
                fprintf(fid, 'module rm %s\n',SimGroup.pbs.fftwVersion);
                fprintf(fid, 'module rm %s\n',SimGroup.pbs.libctlVersion);
                fprintf(fid, 'module rm %s\n', SimGroup.pbs.hdf5Version);
                fprintf(fid, 'module rm %s\n', SimGroup.pbs.mpbVersion);
                
                %Reload non MPI version of MPB
                fprintf(fid, 'module load gcc/4.4.5\n');
                fprintf(fid, 'module load fftw/2.1.5\n');
                fprintf(fid, 'module load libctl/3.1\n');
                fprintf(fid, 'module load hdf5/1.8.9\n');
                fprintf(fid, 'module load mpb/1.4.2\n');
                
                %Post process output files, propagate for extra periods
                for k = 1:length(SimGroup.MPBSimulation.MPBh5Files)
                    %Check if current file output is in use
                    if(SimGroup.MPBSimulation.MPBh5Files(k).inUse_FLAG)
                        fprintf(fid, 'mpb-data -r -m %u -n %u %s\n',...
                            SimGroup.MPBSimulation.MPBh5Files(k).periods, SimGroup.MPBSimulation.MPBh5Files(k).resolution, ...
                            SimGroup.MPBSimulation.MPBh5Files(k).name);
                    end
                end
                
                
            otherwise
                
                %Ensure that modules are loaded
                fprintf(fid, 'module load gcc/4.4.5\n');
                fprintf(fid, 'module load openmpi/1.4.3\n');
                fprintf(fid, 'module load fftw/2.1.5\n');
                fprintf(fid, 'module load libctl/3.1\n');
                fprintf(fid, 'module load hdf5/1.8.9_parallel\n');
                fprintf(fid, 'module load mpb-hdf_1.8.9-test/1.4.2_hdf_test\n');
                
                %MPB Command
                mpbMPI = ['mpirun -np ' num2str(SimGroup.pbs.nodes*SimGroup.pbs.ppn)  ' -hostfile $PBS_NODEFILE mpb-mpi '];
                
                %Change directory to simulation directory
                fprintf(fid, ['cd ' SimGroup.dir '/' SimGroup.name '\n']);
                
                %Run MPB using path to .ctl file
                fprintf(fid, [mpbMPI SimGroup.name 'MPB.ctl | tee ' 'output/MPBout.txt\n']);
                
                %Extract frequencies from MPBout.txt, after simulation has
                %completed
                fprintf(fid, 'grep tefreqs output/MPBout.txt > output/MPBFreqsTE.txt\n');
                fprintf(fid, 'grep tmfreqs output/MPBout.txt > output/MPBFreqsTM.txt\n');
                
                
                %Remove loaded modules
                fprintf(fid, 'module rm gcc/4.4.5\n');
                fprintf(fid, 'module rm openmpi/1.4.3\n');
                fprintf(fid, 'module rm fftw/2.1.5\n');
                fprintf(fid, 'module rm libctl/3.1\n');
                fprintf(fid, 'module rm hdf5/1.8.9_parallel\n');
                fprintf(fid, 'module rm mpb-hdf_1.8.9-test/1.4.2_hdf_test\n');
                
                %Reload non MPI version of MPB
                fprintf(fid, 'module load gcc/4.4.5\n');
                fprintf(fid, 'module load fftw/2.1.5\n');
                fprintf(fid, 'module load libctl/3.1\n');
                fprintf(fid, 'module load hdf5/1.8.9\n');
                fprintf(fid, 'module load mpb/1.4.2\n');
                
                %Post process output files, propagate for extra periods
                for k = 1:length(SimGroup.MPBSimulation.MPBh5Files)
                    %Check if current file output is in use
                    if(SimGroup.MPBSimulation.MPBh5Files(k).inUse_FLAG)
                        fprintf(fid, 'mpb-data -r -m %u -n %u %s\n',...
                            SimGroup.MPBSimulation.MPBh5Files(k).periods, SimGroup.MPBSimulation.MPBh5Files(k).resolution, ...
                            SimGroup.MPBSimulation.MPBh5Files(k).name);
                    end
                end
                
                
                % fprintf(fid, 'mpb-data -r -m 3 -n 32 epsilon.h5\n');
                
        end
end

%Write submit command into file as a comment in case pbs script needs to be
%resubmitted
submitCommand = [SimGroup.dir '/' SimGroup.name '/' SimGroup.name '.pbs'];
fprintf(fid, ['\n\n#  msub ' SimGroup.dir '/' SimGroup.name '/' SimGroup.name '.pbs']);

%Submit .pbs file to queue
SubmitToQueue(SimGroup.pbs, submitCommand)


%Close File
fclose(fid);

end