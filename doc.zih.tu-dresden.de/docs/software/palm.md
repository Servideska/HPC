# PALM Simulation Tool

PALM is an advanced and state-of-the-art meteorological modeling system for atmospheric and oceanic
boundary layer flows. It was developed as a turbulence-resolving large-eddy simulation (LES) model
specifically designed to run on massively parallel computer architectures. Meanwhile, turbulence
closure based on the Reynolds-averaged Navier-Stokes (RANS) equations has been added so that PALM
can run not only in turbulence-resolving mode (i.e., LES) but also in RANS mode, in which the
entire turbulence spectrum is parameterized. A further project description can be found on
[PALM's homepage](http://palm.muk.uni-hannover.de/trac/wiki/palm).

## Installation

There are two versions of PALM tested on ZIH system's partition `haswell`: One is compiled with
Intel and another with the GNU compiler suite. You can use one of the following build workflows
and run each of the commands separately on the console to install PALM in your workspace.

- Replace `<user>` with your ZIH login name (lines 1 and 3)

=== "gpalm (GCC 2021a)"
    ```bash linenums="1"
    ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

    export wm=/scratch/ws/0/<user>-palm
    cd ${wm}

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

    bash palm_model_system/install -p ${wm}/gpalm
    export PATH=${wm}/gpalm/bin:${PATH}

    cd ${wm}/gpalm
    cp ${wm}/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_gnu .
    palmbuild -c taurus_gnu -V
    ```

=== "gpalm (GCC 2019a)"
    ```bash linenums="1"
    ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

    export wm=/scratch/ws/0/<user>-palm
    cd ${wm}

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

    bash palm_model_system/install -p ${wm}/gpalm
    export PATH=${wm}/gpalm/bin:${PATH}

    cd ${wm}/gpalm
    cp ${wm}/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_gnu .
    palmbuild -c taurus_gnu -V
    ```

=== "ipalm (Intel 2021b)"
    ```bash linenums="1"
    ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

    export wm=/scratch/ws/0/<user>-palm
    cd ${wm}

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

    bash palm_model_system/install -p ${wm}/ipalm -c mpiifort
    export PATH=${wm}/ipalm/bin:${PATH}

    cd ${wm}/ipalm
    cp ${wm}/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_intel .
    bash palmbuild -c taurus_intel -V
    ```

=== "ipalm (Intel 2020a)"
    ```bash linenums="1"
    ws_allocate -F scratch -r 7 -m <user>@tu-dresden.de palm 100

    export wm=/scratch/ws/0/<user>-palm
    cd ${wm}

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

    bash palm_model_system/install -p ${wm}/ipalm -c mpiifort
    export PATH=${wm}/ipalm/bin:${PATH}

    cd ${wm}/ipalm
    cp ${wm}/palm_model_system/packages/palm/model/share/config/.palm.config.taurus_intel .
    bash palmbuild -c taurus_intel -V
    ```

More information about the installation process can be found on the
[PALM Installation wiki page](http://palm.muk.uni-hannover.de/trac/wiki/doc/install/advanced).

## Configuration

The configurations for the target partition `haswell` for both Intel and GNU versions are included
in the source code since PALM release 22.10. Copy the configuration, e.g. with

```bash
marie@lonin$ cd </palm_installation/>
marie@lonin$ cp palm_model_system/packages/palm/model/share/config/.palm.config.taurus_[gnu|intel] .
```

Or download the configuration files from here:

!!! tip "Configuration Templates for partition `haswell`"
    - [taurus_gnu](misc/palm.config.taurus_gnu)
    - [taurus_intel](misc/palm.config.taurus_intel)

Rename and modify them as follows:

!!! warning "Attention"
    The configuration file names must start with a `.` and follow the pattern `.palm.config.<name>`
    in order to work.

- Replace the values of `%workspace` and `%base_directory` (lines 15 and 16) with the values
determined from the default configuration `.palm.config.default`
- Replace the value of `%local_username` with your username (line 27)
- Replace the value of `%project_account` with your project name (line 35)

However, the most important part is to check the execute command in the configuration. For ZIH
systems you have to replace `mpirun` with `srun` so that it should say like this:

```
%execute_command     srun ./palm
```

With `mpirun` instead, this can lead to a tremendeous slowdown (see the
[issue about performance loss](#performance-loss-with-intel)).

The configuration is applied to a simulation run by setting the `-c` flag, e.g.

```
palmrun -c <configuration> [...]
```

## Execution

To run the model you can use the following jobs scripts as a template to submit a PALM simulation
job. You are welcome to modify these examples according to your needs:

!!! tip "PALM job script templates"
    - [submit_gpalm-2021a.sh](misc/palm_submit_gcc-2021a.sh)
    - [submit_gpalm-2019a.sh](misc/palm_submit_gcc-2019a.sh)
    - [submit_ipalm-2021b.sh](misc/palm_submit_intel-2021b.sh)
    - [submit_ipalm-2020a.sh](misc/palm_submit_intel-2020a.sh)

Change the following lines:

- Replace `<project>` (line 3) with your project name
- Replace `<firstname.lastname>@tu-dresden.de` (line 12) with your valid email address to receive
a notification on job start
- Replace `wm=/scratch/ws/0/<user>-palm` (line 24) with your PALM installation path

Use e.g.

```bash
marie@lonin$ sbatch submit_gpalm-2021a.sh
```

to submit your PALM job script to the Slurm scheduler and run the simulation.

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

    Comparing the runtimes of the Intel version and GCC-compiled version there is a massive
    performance loss.

!!! note "Explanation"

    In the workflow with Intel, `mpirun` causes the use of an alternate underlying MPI library.
    This means tremendous slowdowns of MPI communication calls resulting in a performance loss of
    at least factor 8 for a test simulation with 4 processes on one node.

!!! success "Solution"

    Use `srun` instead of `mpirun` as the `%execute_command` in your
    [configuration file](#configuration).

### Other Issues

For any further issues you can consult PALM's
[help page](http://palm.muk.uni-hannover.de/trac/wiki/help) and search through their
[existing tickets](http://palm.muk.uni-hannover.de/trac/wiki/tickets) to find an answer.
