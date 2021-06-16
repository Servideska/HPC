# Venus



## Information about the hardware

Detailed information on the currect HPC hardware can be found
[here.](HardwareVenus)

## Applying for Access to the System

Project and login application forms for taurus are available
[here](Access).

## Login to the System

Login to the system is available via ssh at `venus.hrsk.tu-dresden.de`.

The RSA fingerprints of the Phase 2 Login nodes are:

    MD5:63:65:c6:d6:4e:5e:03:9e:07:9e:70:d1:bc:b4:94:64

and

    SHA256:Qq1OrgSCTzgziKoop3a/pyVcypxRfPcZT7oUQ3V7E0E

You can find an list of fingerprints [here](Login#SSH_access).

## MPI

The installation of the Message Passing Interface on Venus (SGI MPT)
supports the MPI 2.2 standard (see `man mpi` ). There is no command like
`mpicc`, instead you just have to use the "serial" compiler (e.g. `icc`,
`icpc`, or `ifort`) and append `-lmpi` to the linker command line.

Example:

    <span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>% icc -o myprog -g -O2 -xHost myprog.c -lmpi<span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>

Notes:

-   C++ programmers: You need to link with both libraries:
    `-lmpi++ -lmpi`.
-   Fortran programmers: The MPI module is only provided for the Intel
    compiler and does not work with gfortran.

Please follow the following guidelines to run your parallel program
using the batch system on Venus.

## Batch system

Applications on an HPC system can not be run on the login node. They
have to be submitted to compute nodes with dedicated resources for the
user's job. Normally a job can be submitted with these data:

-   number of CPU cores,
-   requested CPU cores have to belong on one node (OpenMP programs) or
    can distributed (MPI),
-   memory per process,
-   maximum wall clock time (after reaching this limit the process is
    killed automatically),
-   files for redirection of output and error messages,
-   executable and command line parameters.

The batch sytem on Venus is Slurm. For general information on Slurm,
please follow [this link](Slurm).

### Submission of Parallel Jobs

The MPI library running on the UV is provided by SGI and highly
optimized for the ccNUMA architecture of this machine.

On Venus, you can only submit jobs with a core number which is a
multiple of 8 (a whole CPU chip and 128 GB RAM). Parallel jobs can be
started like this:

    <span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>srun -n 16 a.out<span class='WYSIWYG_HIDDENWHITESPACE'>&nbsp;</span>

**Please note:** There are different MPI libraries on Taurus and Venus,
so you have to compile the binaries specifically for their target.

### File Systems

-   The large main memory on the system allows users to create ramdisks
    within their own jobs. The documentation on how to use these
    ramdisks can be found [here](RamDiskDocumentation).