# PALM

PALM is a Large Eddie Simulation tool (LES). A Description of PALM can be found on it's
[wiki page](http://palm.muk.uni-hannover.de/trac/wiki/palm).

## Build

There are two versions of PALM tested on ZIH system's partition `haswell`: One is compiled with
Intel and another with the GNU compiler suite. You can use one of the following build workflows
and run each of the commands seperately on the console.
- Replace `<user>` with your ZIH login name (lines 1 and 3)

More information about the installation process can be found on the
[PALM Installation wiki page](http://palm.muk.uni-hannover.de/trac/wiki/doc/install/advanced).

???+ tip "Building PALM"
    === gpalm (GCC 2021a)
        ```bash linenums="1"
        ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

        export wm=/scratch/ws/0/<user>-palm
        cd $wm

        module load gompi/2021a
        module load FFTW/3.3.9-gompi-2021a
        module load netCDF-Fortran/4.5.3-gompi-2021a
        module load Python/3.9.5-GCCcore-10.3.0
        module load CMake/3.20.1-GCCcore-10.3.0
        #module load Score-P/7.0-gompi-2021a

        wget https://gitlab.palm-model.org/releases/palm_model_system/-/archive/master/palm_model_system-master.tar.gz
        tar -xvf palm_model_system-master.tar.gz
        mv palm_model_system-master palm_model_system
        mkdir gpalm
        $(cd palm_model_system; chmod +x install)

        virtualenv --system-site-packages palm
        source palm/bin/activate
        python3 -m pip install -r palm_model_system/requirements.txt

        bash palm_model_system/install -p $wm/gpalm
        export PATH=$wm/gpalm/bin:$PATH

        cd $wm/gpalm
        cp $wm/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_gnu .
        palmbuild -c taurus_gnu -V
        ```

    === gpalm (GCC 2019a)
        ```bash linenums="1"
        ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

        export wm=/scratch/ws/0/<user>-palm
        cd $wm

        module load gompi/2019a
        module load FFTW/3.3.8-gompi-2019a
        module load netCDF-Fortran/4.4.5-gompi-2019a
        module load Python/3.7.2-GCCcore-8.2.0
        module load CMake/3.13.3-GCCcore-8.2.0
        #module load Score-P/6.0-gompi-2019a

        wget https://gitlab.palm-model.org/releases/palm_model_system/-/archive/master/palm_model_system-master.tar.gz
        tar -xvf palm_model_system-master.tar.gz
        mv palm_model_system-master palm_model_system
        mkdir gpalm
        $(cd palm_model_system; chmod +x install)

        virtualenv --system-site-packages palm
        source palm/bin/activate
        python3 -m pip install -r palm_model_system/requirements.txt

        bash palm_model_system/install -p $wm/gpalm
        export PATH=$wm/gpalm/bin:$PATH

        cd $wm/gpalm
        cp $wm/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_gnu .
        palmbuild -c taurus_gnu -V
        ```

    === ipalm (Intel 2021b)
        ```bash linenums="1"
        ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

        export wm=/scratch/ws/0/<user>-palm
        cd $wm

        module load iimpi/2021b
        module load FFTW/3.3.10-iimpi-2021b
        module load netCDF-Fortran/4.5.3-iimpi-2021b
        module load Python/3.9.6-GCCcore-11.2.0
        module load CMake/3.22.1-GCCcore-11.2.0
        #

        wget https://gitlab.palm-model.org/releases/palm_model_system/-/archive/master/palm_model_system-master.tar.gz
        tar -xvf palm_model_system-master.tar.gz
        mv palm_model_system-master palm_model_system
        mkdir ipalm
        $(cd palm_model_system; chmod +x install)

        virtualenv --system-site-packages palm
        source palm/bin/activate
        python3 -m pip install -r palm_model_system/requirements.txt

        bash palm_model_system/install -p $wm/ipalm -c mpiifort
        export PATH=$wm/ipalm/bin:$PATH

        cd $wm/ipalm
        cp $wm/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_intel .
        bash palmbuild -c taurus_intel -V
        ```

    === ipalm (Intel 2020a)
        ```bash linenums="1"
        ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

        export wm=/scratch/ws/0/<user>-palm
        cd $wm

        module load iimpi/2020a
        module load FFTW/3.3.8-intel-2020a
        module load netCDF-Fortran/4.5.2-iimpi-2020a
        module load Python/3.8.2-GCCcore-9.3.0
        module load CMake/3.16.4-GCCcore-9.3.0
        export I_MPI_HYDRA_TOPOLIB=ipl

        wget https://gitlab.palm-model.org/releases/palm_model_system/-/archive/master/palm_model_system-master.tar.gz
        tar -xvf palm_model_system-master.tar.gz
        mv palm_model_system-master palm_model_system
        mkdir ipalm
        $(cd palm_model_system; chmod +x install)

        virtualenv --system-site-packages palm
        source palm/bin/activate
        python3 -m pip install -r palm_model_system/requirements.txt

        bash palm_model_system/install -p $wm/ipalm -c mpiifort
        export PATH=$wm/ipalm/bin:$PATH

        cd $wm/ipalm
        cp $wm/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_intel .
        bash palmbuild -c taurus_intel -V
        ```

## Configuration

The configurations for the target partition `haswell` for both Intel and GNU versions should be
included in the next release of PALM (>22.04). If they are not yet available, copy the configuration
from below and save it as `</palm/installation/folder>/.palm.config.taurus_[gnu|intel]`.
- Replace the values of `%workspace` and `%base_directory` (lines 14 and 15) with the values
determined from the default configuration `.palm.config.default`
- Replace the value of `%local_username` with your username (line 27)
- Replace the value of `%project_account` with your project name (line 35)

??? tip "PALM Configuration files"
    === .palm.config.taurus_gnu
        ```bash linenums="1"
        ################################################################################
        # This is a configuration file for PALM on TUD's HPC cluster Taurus. 
        # It must be named: .palm.config.<suffix>
        # in order to use it, call palmbuild and palmrun with the option: -c <suffix>
        # Documentation: http://palm.muk.uni-hannover.de/trac/wiki/doc/app/palm_config
        ################################################################################
        #
        #-------------------------------------------------------------------------------
        # General compiler and host configuration section.
        # Variable declaration lines must start with a percent character
        # Internal variables can be used as {{VARIABLE_NAME}}. Please see documentation.
        #-------------------------------------------------------------------------------
        # get/copy workspace and base dir from default config file
        %workspace           <e.g. /lustre/scratch2/ws/0/<user>-palm>
        %base_directory      \$workspace/gpalm
        %base_data           \$base_directory/JOBS
        %source_path         \$workspace/palm_model_system/packages/palm/model/src
        %user_source_path    \$base_directory/JOBS/$run_identifier/USER_CODE
        %fast_io_catalog     \$base_directory/tmp
        %restart_data_path   \$base_directory/tmp
        %output_data_path    \$base_directory/JOBS
        %local_jobcatalog    \$base_directory/JOBS/$run_identifier/LOG_FILES
        %remote_jobcatalog   \$base_directory/JOBS/$run_identifier/LOG_FILES
        #
        %local_ip            127.0.0.1
        %local_hostname      taurusi6254.taurus.hrsk.tu-dresden.de
        %local_username      <copy_from_default>
        #
        #%remote_ip           <ip>
        #%remote_hostname     <hostname>
        #%remote_loginnode    <loginnode>
        #%remote_username     <username>
        #%ssh_key             ~/.ssh/id_rsa
        #
        %project_account     <p_projectname>
        %submit_command      sbatch
        %execute_command     srun ./palm
        #
        %memory              10160
        #%module_commands     module load gompi/2021a FFTW/3.3.9-gompi-2021a netCDF-Fortran/4.5.3-gompi-2021a Python/3.9.5-GCCcore-10.3.0 CMake/3.20.1-GCCcore-10.3.0
        #%module_commands     module load gompi/2019a FFTW/3.3.8-gompi-2019a netCDF-Fortran/4.4.5-gompi-2019a Python/3.7.2-GCCcore-8.2.0 CMake/3.13.3-GCCcore-8.2.0
        #%login_init_cmd      .execute_special_profile
        #
        %compiler_name       \$(which mpifort)
        %compiler_name_ser   \$(which gfortran)
        %cpp_options         -cpp -D__gfortran -D__parallel -DMPI_REAL=MPI_DOUBLE_PRECISION -DMPI_2REAL=MPI_2DOUBLE_PRECISION -D__netcdf -D__fftw -D__rrtmg
        %make_options        -j 4
        %compiler_options    -Ofast -ffree-line-length-none -I /sw/installed/\$(module -t list netCDF-Fortran)/include -I /sw/installed/\$(module -t list FFTW)/include -I \$base_directory/rrtmg/include
        %linker_options      -Ofast -ffree-line-length-none /sw/installed/\$(module -t list netCDF-Fortran)/lib/libnetcdff.so /sw/installed/\$(module -t list FFTW)/lib/libfftw3.so \$base_directory/rrtmg/lib/librrtmg.so
        #
        #-------------------------------------------------------------------------------
        # Directives to be used for batch jobs
        # Lines must start with "BD:". If $-characters are required, hide them with \
        # Internal variables can be used as {{variable_name}}. Please see documentation.
        #-------------------------------------------------------------------------------
        BD:#!/bin/bash
        BD:#PBS -A {{project_account}}
        BD:#PBS -N {{run_id}}
        BD:#PBS -l walltime={{cpu_hours}}:{{cpu_minutes}}:{{cpu_seconds}}
        BD:#PBS -l nodes={{nodes}}:ppn={{tasks_per_node}}
        BD:#PBS -o {{job_protocol_file}}
        BD:#PBS -j oe
        BD:#PBS -q {{queue}}
        #
        #-------------------------------------------------------------------------------
        # Directives for batch jobs used to send back the jobfiles from a remote to a local host
        # Lines must start with "BDT:". If $-characters are required, excape them with triple backslash
        # Internal variables can be used as {{variable_name}}. Please see documentation.
        #-------------------------------------------------------------------------------
        BDT:#!/bin/bash
        BDT:#PBS -A {{project_account}}
        BDT:#PBS -N job_protocol_transfer
        BDT:#PBS -l walltime=00:30:00
        BDT:#PBS -l nodes=1:ppn=1
        BDT:#PBS -o {{job_transfer_protocol_file}}
        BDT:#PBS -j oe
        BDT:#PBS -q dataq
        #
        #-------------------------------------------------------------------------------
        # INPUT-commands. These commands are executed before running PALM
        # Lines must start with "IC:"
        #-------------------------------------------------------------------------------
        IC:ulimit  -s unlimited
        #
        #-------------------------------------------------------------------------------
        # ERROR-commands. These commands are executed when PALM terminates abnormally
        # Lines must start with "EC:"
        #-------------------------------------------------------------------------------
        EC:[[ $locat = execution ]]  &&  cat  RUN_CONTROL
        #
        #-------------------------------------------------------------------------------
        # OUTPUT-commands. These commands are executed when PALM terminates normally
        # Lines must start with "OC:"
        #-------------------------------------------------------------------------------
        #
        # Combine 1D- and 3D-profile output (these files are not usable for plotting)
        OC:[[ -f LIST_PROFIL_1D     ]]  &&  cat  LIST_PROFIL_1D  >>  LIST_PROFILE
        OC:[[ -f LIST_PROFIL        ]]  &&  cat  LIST_PROFIL     >>  LIST_PROFILE
        #
        # Combine all particle information files
        OC:[[ -f PARTICLE_INFOS/_0000 ]]  &&  cat  PARTICLE_INFOS/* >> PARTICLE_INFO
        ```

    === .palm.config.taurus_intel
        ```bash linenums="1"
        ################################################################################
        # This is a configuration file for PALM on TUD's HPC cluster Taurus. 
        # It must be named: .palm.config.<suffix>
        # in order to use it, call palmbuild and palmrun with the option: -c <suffix>
        # Documentation: http://palm.muk.uni-hannover.de/trac/wiki/doc/app/palm_config
        ################################################################################
        #
        #-------------------------------------------------------------------------------
        # General compiler and host configuration section.
        # Variable declaration lines must start with a percent character
        # Internal variables can be used as {{VARIABLE_NAME}}. Please see documentation.
        #-------------------------------------------------------------------------------
        # get/copy workspace and base dir from default config file
        %workspace           <e.g. /lustre/scratch2/ws/0/<user>-palm>
        %base_directory      \$workspace/ipalm
        %base_data           \$base_directory/JOBS
        %source_path         \$workspace/palm_model_system/packages/palm/model/src
        %user_source_path    \$base_directory/JOBS/$run_identifier/USER_CODE
        %fast_io_catalog     \$base_directory/tmp
        %restart_data_path   \$base_directory/tmp
        %output_data_path    \$base_directory/JOBS
        %local_jobcatalog    \$base_directory/JOBS/$run_identifier/LOG_FILES
        %remote_jobcatalog   \$base_directory/JOBS/$run_identifier/LOG_FILES
        #
        %local_ip            127.0.0.1
        %local_hostname      taurusi6604.taurus.hrsk.tu-dresden.de
        %local_username      <copy_from_default>
        #
        #%remote_ip           <ip>
        #%remote_hostname     <hostname>
        #%remote_loginnode    <loginnode>
        #%remote_username     <username>
        #%ssh_key             ~/.ssh/id_rsa
        #
        %project_account     <p_projectname>
        %submit_command      sbatch
        %execute_command     srun ./palm
        #
        %memory              10160
        %module_commands     module load iimpi/2021b FFTW/3.3.10-iimpi-2021b netCDF-Fortran/4.5.3-iimpi-2021b Python/3.9.6-GCCcore-11.2.0
        #%login_init_cmd      <./execute_cmd_first>
        #
        %compiler_name       \$(which mpiifort)
        %compiler_name_ser   \$(which ifort)
        %cpp_options         -cpp -D__intel_compiler -D__parallel -D__lc -DMPI_REAL=MPI_DOUBLE_PRECISION -DMPI_2REAL=MPI_2DOUBLE_PRECISION -D__netcdf -D__netcdf4 -D__netcdf_parallel -D__fftw -D__rrtmg
        %make_options        -j 4
        %compiler_options    -O3 -mtune=native -march=native -cpp -I /sw/installed/\$(module -t list netCDF-Fortran)/include -I /sw/installed/\$(module -t list netCDF |head -1)/include -I /sw/installed/\$(module -t list FFTW)/include -I \$base_directory/rrtmg/include
        %linker_options      -O3 -mtune=native -march=native -cpp /sw/installed/\$(module -t list netCDF-Fortran)/lib/libnetcdff.so /sw/installed/\$(module -t list netCDF |head -1)/lib64/libnetcdf.so /sw/installed/\$(module -t list FFTW)/lib/libfftw3.so \$base_directory/rrtmg/lib/librrtmg.so
        #
        #-------------------------------------------------------------------------------
        # Directives to be used for batch jobs
        # Lines must start with "BD:". If $-characters are required, hide them with \
        # Internal variables can be used as {{variable_name}}. Please see documentation.
        #-------------------------------------------------------------------------------
        BD:#!/bin/bash
        BD:#PBS -A {{project_account}}
        BD:#PBS -N {{run_id}}
        BD:#PBS -l walltime={{cpu_hours}}:{{cpu_minutes}}:{{cpu_seconds}}
        BD:#PBS -l nodes={{nodes}}:ppn={{tasks_per_node}}
        BD:#PBS -o {{job_protocol_file}}
        BD:#PBS -j oe
        BD:#PBS -q {{queue}}
        #
        #-------------------------------------------------------------------------------
        # Directives for batch jobs used to send back the jobfiles from a remote to a local host
        # Lines must start with "BDT:". If $-characters are required, excape them with triple backslash
        # Internal variables can be used as {{variable_name}}. Please see documentation.
        #-------------------------------------------------------------------------------
        BDT:#!/bin/bash
        BDT:#PBS -A {{project_account}}
        BDT:#PBS -N job_protocol_transfer
        BDT:#PBS -l walltime=00:30:00
        BDT:#PBS -l nodes=1:ppn=1
        BDT:#PBS -o {{job_transfer_protocol_file}}
        BDT:#PBS -j oe
        BDT:#PBS -q dataq
        #
        #-------------------------------------------------------------------------------
        # INPUT-commands. These commands are executed before running PALM
        # Lines must start with "IC:"
        #-------------------------------------------------------------------------------
        IC:ulimit  -s unlimited
        #
        #-------------------------------------------------------------------------------
        # ERROR-commands. These commands are executed when PALM terminates abnormally
        # Lines must start with "EC:"
        #-------------------------------------------------------------------------------
        EC:[[ $locat = execution ]]  &&  cat  RUN_CONTROL
        #
        #-------------------------------------------------------------------------------
        # OUTPUT-commands. These commands are executed when PALM terminates normally
        # Lines must start with "OC:"
        #-------------------------------------------------------------------------------
        #
        # Combine 1D- and 3D-profile output (these files are not usable for plotting)
        OC:[[ -f LIST_PROFIL_1D     ]]  &&  cat  LIST_PROFIL_1D  >>  LIST_PROFILE
        OC:[[ -f LIST_PROFIL        ]]  &&  cat  LIST_PROFIL     >>  LIST_PROFILE
        #
        # Combine all particle information files
        OC:[[ -f PARTICLE_INFOS/_0000 ]]  &&  cat  PARTICLE_INFOS/* >> PARTICLE_INFO
        ```

## Execution

You can use the following batch scripts to submit a PALM simulation job. You are welcome to modify
these examples according to your needs.
- Replace `<p_projectname>` (line 3) with your project name
- Replace `<firstname.lastname>@tu-dresden.de` (line 12) with your valid email address to receive
a notification on job start
- Replace `wm=/scratch/ws/0/<user>-palm` (line 27) with your PALM installation path

??? tip "Submit PALM with batch script"
    === submit_gpalm.sh (GCC 2021a)
        ```bash linenums="1"
        #!/bin/bash
        #SBATCH --job-name=les_palm
        #SBATCH --account=<p_projectname>     # account CPU time to Project
        #SBATCH --partition=haswell
        #SBATCH --time=00:10:00               # run for 1 hour
        #SBATCH --ntasks=4                    # number of tasks (MPI processes)
        #SBATCH --ntasks-per-node=4           # MPI process per node
        #SBATCH --cpus-per-task=1             # 24 tasks available
        #SBATCH --mem-per-cpu=2540M

        #SBATCH --mail-type=BEGIN
        #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

        #SBATCH --export=ALL

        # modules
        module load gompi/2021a
        module load FFTW/3.3.9-gompi-2021a
        module load netCDF-Fortran/4.5.3-gompi-2021a
        module load Python/3.9.5-GCCcore-10.3.0
        module load CMake/3.20.1-GCCcore-10.3.0

        # workspace
        export wm=/scratch/ws/0/<user>-palm
        export PATH=$wm/gpalm/bin:$PATH

        source $wm/palm/bin/activate

        cd $wm/gpalm

        # execution
        echo 'Node configuration:'
        echo 'Number of Nodes:' $SLURM_JOB_NUM_NODES
        echo 'Number of Tasks:' $SLURM_NTASKS
        echo 'CPUS_PER_TASK:' $SLURM_CPUS_PER_TASK
        echo 'Number of Threads:' $OMP_NUM_THREADS
        echo

        # select test case, see
        #ls $wm/palm_model_system/packages/palm/model/tests/cases
        case=urban_environment
        # and create link if expected folder is not existing
        testdir=$wm/gpalm/JOBS/$case
        [ -d $testdir ] || (mkdir -pv $testdir; cd $testdir; ln -s ../../palm_model_system/packages/palm/model/tests/cases/$case $case)

        # -O    threads per openMP task     $OMP_NUM_THREADS
        # -T    tasks per node              $SLURM_NTASKS_PER_NODE
        # -X    # of processors (on parallel machines)

        palmrun -r $case -c taurus_gnu -a "d3#" -T $SLURM_NTASKS_PER_NODE -X $SLURM_NTASKS -v -z
        ```

    === submit_gpalm.sh (GCC 2019a)
        ```bash linenums="1"
        #!/bin/bash
        #SBATCH --job-name=les_palm
        #SBATCH --account=<p_projectname>     # account CPU time to Project
        #SBATCH --partition=haswell
        #SBATCH --time=00:10:00               # run for 1 hour
        #SBATCH --ntasks=4                    # number of tasks (MPI processes)
        #SBATCH --ntasks-per-node=4           # MPI process per node
        #SBATCH --cpus-per-task=1             # 24 tasks available
        #SBATCH --mem-per-cpu=2540M

        #SBATCH --mail-type=BEGIN
        #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

        #SBATCH --export=ALL

        # modules
        module load gompi/2019a
        module load FFTW/3.3.8-gompi-2019a
        module load netCDF-Fortran/4.4.5-gompi-2019a
        module load Python/3.7.2-GCCcore-8.2.0
        module load CMake/3.13.3-GCCcore-8.2.0

        # workspace
        export wm=/scratch/ws/0/<user>-palm
        export PATH=$wm/gpalm/bin:$PATH

        source $wm/palm/bin/activate

        cd $wm/gpalm

        # execution
        echo 'Node configuration:'
        echo 'Number of Nodes:' $SLURM_JOB_NUM_NODES
        echo 'Number of Tasks:' $SLURM_NTASKS
        echo 'CPUS_PER_TASK:' $SLURM_CPUS_PER_TASK
        echo 'Number of Threads:' $OMP_NUM_THREADS
        echo

        # select test case, see
        #ls $wm/palm_model_system/packages/palm/model/tests/cases
        case=urban_environment
        # and create link if expected folder is not existing
        testdir=$wm/gpalm/JOBS/$case
        [ -d $testdir ] || (mkdir -pv $testdir; cd $testdir; ln -s ../../palm_model_system/packages/palm/model/tests/cases/$case $case)

        # -O    threads per openMP task     $OMP_NUM_THREADS
        # -T    tasks per node              $SLURM_NTASKS_PER_NODE
        # -X    # of processors (on parallel machines)

        palmrun -r $case -c taurus_gnu -a "d3#" -T $SLURM_NTASKS_PER_NODE -X $SLURM_NTASKS -v -z
        ```
    
    === submit_ipalm.sh (Intel 2021b)
        ```bash linenums="1"
        #!/bin/bash
        #SBATCH --job-name=les_palm
        #SBATCH --account=<p_projectname>     # account CPU time to Project
        #SBATCH --partition=haswell
        #SBATCH --time=00:10:00               # run for 1 hour
        #SBATCH --ntasks=4                    # number of tasks (MPI processes)
        #SBATCH --ntasks-per-node=4           # MPI process per node
        #SBATCH --cpus-per-task=1             # 24 tasks available
        #SBATCH --mem-per-cpu=2540M

        #SBATCH --mail-type=BEGIN
        #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

        #SBATCH --export=ALL

        # modules
        module load iimpi/2021b
        module load FFTW/3.3.10-iimpi-2021b
        module load netCDF-Fortran/4.5.3-iimpi-2021b
        module load Python/3.9.6-GCCcore-11.2.0
        #

        # workspace
        export wm=/scratch/ws/0/<user>-palm
        export PATH=$wm/ipalm/bin:$PATH

        source $wm/palm/bin/activate

        cd $wm/ipalm

        # execution
        echo 'Node configuration:'
        echo 'Number of Nodes:' $SLURM_JOB_NUM_NODES
        echo 'Number of Tasks:' $SLURM_NTASKS
        echo 'CPUS_PER_TASK:' $SLURM_CPUS_PER_TASK
        echo 'Number of Threads:' $OMP_NUM_THREADS
        echo

        # select test case, see
        #ls $wm/palm_model_system/packages/palm/model/tests/cases
        case=urban_environment
        # and create link if expected folder is not existing
        testdir=$wm/ipalm/JOBS/$case
        [ -d $testdir ] || (mkdir -pv $testdir; cd $testdir; ln -s ../../palm_model_system/packages/palm/model/tests/cases/$case $case)

        # -O    threads per openMP task     $OMP_NUM_THREADS
        # -T    tasks per node              $SLURM_NTASKS_PER_NODE
        # -X    # of processors (on parallel machines)

        palmrun -r $case -c taurus_intel -a "d3#" -T $SLURM_NTASKS_PER_NODE -X $SLURM_NTASKS -v -z
        ```

    === submit_ipalm.sh (Intel 2020a)
        ```bash linenums="1"
        #!/bin/bash
        #SBATCH --job-name=les_palm
        #SBATCH --account=<p_projectname>     # account CPU time to Project
        #SBATCH --partition=haswell
        #SBATCH --time=00:10:00               # run for 1 hour
        #SBATCH --ntasks=4                    # number of tasks (MPI processes)
        #SBATCH --ntasks-per-node=4           # MPI process per node
        #SBATCH --cpus-per-task=1             # 24 tasks available
        #SBATCH --mem-per-cpu=2540M

        #SBATCH --mail-type=BEGIN
        #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

        #SBATCH --export=ALL

        # modules
        module load iimpi/2020a
        module load FFTW/3.3.8-intel-2020a
        module load netCDF-Fortran/4.5.2-iimpi-2020a
        module load Python/3.8.2-GCCcore-9.3.0
        export I_MPI_HYDRA_TOPOLIB=ipl

        # workspace
        export wm=/scratch/ws/0/<user>-palm
        export PATH=$wm/ipalm/bin:$PATH

        source $wm/palm/bin/activate

        cd $wm/ipalm

        # execution
        echo 'Node configuration:'
        echo 'Number of Nodes:' $SLURM_JOB_NUM_NODES
        echo 'Number of Tasks:' $SLURM_NTASKS
        echo 'CPUS_PER_TASK:' $SLURM_CPUS_PER_TASK
        echo 'Number of Threads:' $OMP_NUM_THREADS
        echo

        # select test case, see
        #ls $wm/palm_model_system/packages/palm/model/tests/cases
        case=urban_environment
        # and create link if expected folder is not existing
        testdir=$wm/ipalm/JOBS/$case
        [ -d $testdir ] || (mkdir -pv $testdir; cd $testdir; ln -s ../../palm_model_system/packages/palm/model/tests/cases/$case $case)

        # -O    threads per openMP task     $OMP_NUM_THREADS
        # -T    tasks per node              $SLURM_NTASKS_PER_NODE
        # -X    # of processors (on parallel machines)

        palmrun -r $case -c taurus_intel -a "d3#" -T $SLURM_NTASKS_PER_NODE -X $SLURM_NTASKS -v -z
        ```

## Resolved Issues

### Floating Point Exception

!!! failure "Error: Floating Point Exception"
    For the Intel 2020a version there is a floating point exception.
!!! note "Explanation"
    This is an internal error produced by Intel's Hydra process manager (see 
[HLRN solution](https://www.hlrn.de/doc/display/PUB/Floating+point+exception+with+Intel+MPI+2019.x+using+one+task+per+node)).
!!! success "Solution"
    Use `export I_MPI_HYDRA_TOPOLIB=ipl` to add this workaround setting to your runtime environment.
    For the workflow with Intel 2021b, this workaround is obsolete.

### Performance Loss with Intel

!!! warning "Intel vs. GCC"
    Comparing the runtime of the Intel version and GCC-compiled version there is a massive
performance loss.
!!! note "Explanation"
    In the workflow with Intel, `mpirun` causes the use of an alternate underlying MPI library.
This means tremendeous slowdowns of MPI communication calls resulting in a performance loss of
at least factor 8 for a test simulation with 4 processes on one node.
!!! success "Solution"
    Use `srun` instead of `mpirun` as the `%execute_command` in your
[configuration file](#configuration).

### Other Problems

For any further issues you can consult PALM's
[help page](http://palm.muk.uni-hannover.de/trac/wiki/help) and search through their
[existing tickets](http://palm.muk.uni-hannover.de/trac/wiki/tickets) to find an answer.
