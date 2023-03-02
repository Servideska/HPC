# Checkpoint/Restart

At some point, every HPC system fails, e.g., a compute node or the network might crash causing
running jobs to crash, too. In order to prevent starting your crashed experiments and simulations
from the very beginning, you should be familiar with the great **concept of checkpoint/restart**.

!!! note "Checkpoint/Restart"

    Checkpointing saves the state of a running process to a checkpointing image file. Using this
    image file, the process can later be continued (restarted) from where it left off.

Other motivations to use checkpoint/restart are:

* enable your jobs to run longer than walltime limit
* improve your jobs’ throughput by exploiting the holes in the Slurm schedule
* extend interactive sessions by saving & restarting where you left off
* debug long-running jobs by pausing just before the error & restarting from that point multiple
times  

Here is an extreme example from literature for the waste of large computing resources due to missing
checkpoints:

!!! cite "Adams, D. The Hitchhikers Guide Through the Galaxy"

    Earth was a supercomputer constructed to find the question to the answer to the Life, the
    Universe, and Everything by a race of hyper-intelligent pan-dimensional beings. Unfortunately 10
    million years later, and five minutes before the program had run to completion, the Earth was
    destroyed by Vogons.

## Tools for Checkpoint/Restart

Even though checkpoint/restart is a much needed capability, using it is unfortunately not that easy. 
If you wish to use checkpoint/restart, your **first step** should always be to check if your
application already has such capabilities built-in, as that is the most stable and safe way of doing
it. Applications that are known to have some sort of **native checkpoint/restart** include:

* Abaqus, Amber, Gaussian, GROMACS, LAMMPS, NAMD, NWChem, Quantum Espresso, STAR-CCM+, VASP

If this isn't the case, if you're able to edit the source code of your program, this would be 
the preferred solution. We advice using the dmtcpaware API. If this is impossible, there are 
attempts at creating **generic checkpoint/restart solutions** that should work 
application-agnostic. One such project which we recommend is 
[Distributed Multi-Threaded Check-Pointing](http://dmtcp.sourceforge.net) (DMTCP). 

Checkpointing distributed memory applications with dmtcp can be tedious. A newer, promising tool for
this use case is [MANA](https://github.com/mpickpt/mana). We have however not tested this as of yet.

## Using DMTCP

DMTCP is available on ZIH systems and in the following we provide detailed information on how to use it.

Have a look at [Checkpointing serial and OpenMP prgrams](#checkpointing-serial-and-openmp-programs)
first. Using dmtcp with MPI programs builds upon this.

<!--While our batch system [Slurm](slurm.md) also provides a checkpointing interface to the user,
unfortunately, it does not yet support DMTCP at this time. However, there are ongoing efforts of
writing a Slurm plugin that hopefully will change this in the near future. We will update this
documentation as soon as it becomes available.-->

### Checkpointing serial and OpenMP programs

* Load the DMTCP module: `module load DMTCP`
* DMTCP usually runs an additional coordinator process that manages the creation of checkpoints and
such. It starts automatically when calling the `dmtcp_launch` wrapper script or
can be started explicitly with `dmtcp_coordinator`. Refer to the DMTCP manual for more information. 
* Via `-i`, `--interval` specify an interval (in seconds) in which checkpoint files are created
automatically. This is the easiest way to use dmtcp.
* You have to prefix your program call with the wrapper script `dmtcp_launch`. 
* Writing out checkpoints takes some time (ca. five minutes for 16 threads), so adjust the time limit.

??? example "Checkpoint OpenMP program in fixed intervals"
  
    ```bash
    #!/bin/bash

    #SBATCH --nodes=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=64
    #SBATCH --time=01:00:00
    #SBATCH --account=<account>

    module purge
    module load <modules> 
    module load DMTCP

    export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
    dmtcp_launch --interval 600 ./path/to/openmp_application
    ```

DMTCP writes images ending on `.dmtcp` to the current directory of your job. If these become 
overwhelming, they can be saved in a different directory by setting the `DMTCP_CHECKPOINT_DIR` 
environment variable. Make sure this directory exists and is writable before launching dmtcp. 
DMTCP will also put a restart script in this directory, unfortunately you'll have to write your own
since it does not work on Taurus. Refer to 
[Restarting from Checkpoint Image](#restarting-from-checkpoint-image) on how to do this.

<!--## Migration of Applications

DMTCP enables the possibility to migrate applications even between different architectures. This
means that checkpoints which were created on one architecture can be restarted on another
architecture in the same manner as explained above.

However, it is possible to encounter an `illegal instruction` error, especially when migrating from
newer architectures to older ones or between different manufacturers. This comes from an
incompatible instruction set and cannot be avoided.-->

### DMTCP for Distributed Applications

DMTCP does support checkpointing of MPI applications, however since DMTCP has no official support
for UCX, checkpointing MPI computations over several nodes is not possible. MPI parallel
applications can only be checkpointed when running on a single node and only when using the Intel
toolchain. The newest version which is proven to work is `intel/2019b`.

??? example "Checkpointing distributed Memory Applications in fixed Interval"

    ```bash
    #!/bin/bash

    #SBATCH --ntasks=64
    #SBATCH --time=01:00:00
    #SBATCH --account=<account>

    module purge
    module load <modules> 
    module load DMTCP

    dmtcp_launch --interval 600 --infiniband --batch-queue mpiexec ./path/to/mpi_application
    ```

### Checkpointing on Demand

Checkpointing on demand can be done in two ways: 

* Either you edit the source code to call the
dmtcpaware API. This will mean calling the C-function `dmtcp_checkpoint()` and including the 
dmtcp.h header. During compilation, pass `-fPIC`. The program still needs to be called with
`dmtcp_launch`. 
* The second option is to start `dmtcp_coordinator` in a separate terminal. To 
request a checkpoint, type `c`. You can also pass a command to a dmtcp_coordinator automatically 
started by dmtcp_launch by issuing `dmtcp_command c` on a terminal running on the same host.

Please refer to DMTCP's manuals for these options.

### Restarting from Checkpoint Image

Restarting works in a similar way as starting a normal execution of your application: The requested
resources should match those of your original job. If you do not wish to create another checkpoint
in your restarted application, the `-i` parameter can be omitted this time. 

Since the restart script does not work due to limited support for `Slurm` under DMTCP, you need to
use `dmtcp_restart <FILENAMES>`. Navigate to the checkpoint directory and call the `dmtcp_restart`
command and give the filenames as argument. If the checkpoint image consists of multiple files and
there is only a single checkpoint in the current directory it is possible to restart by running
`dmtcp_restart ckpt_*`. 

??? example "Restarting from Checkpoint"

    ```bash
    #!/bin/bash
    #SBATCH --time=00:01:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500
    #SBATCH --partition=haswell64

    module load <modules>
    module load DMTCP

    dmtcp_restart --interval 600 ckpt_*
    ```

Make sure to restart on the same partition as you executed the program before. It might not work 
otherwise.

### Performance Optimization while Checkpointing

The performance of restarted multithreaded applications can differ heavily depending on the number
of processes and architecture used. The more processes or threads the application has and the more
NUMA nodes the used architecture has, the higher is the performance loss on restarted applications.
This holds true for all kinds of multithreaded tasks and is not limited to MPI. However, when
restarting an MPI application the speed of the filesystem restarted from has a large influence on
the performance of the application, even after the whole checkpoint image is mapped into memory.  So
it is advised to restart from fast filesystems when using MPI whenever possible.

The checkpoint and restart times depend heavily on the bandwidth of the used filesystem and if gzip
compression is enabled or not.

!!! note "Advise to disable gzip compression"

    Since it has nearly no benefit on any of our filesystems we strongly advise to disable gzip
    compression by passing `--no-gzip` option to the `dmtcp_launch` command. Most times the
    checkpoint data is rather incompressible and gzip is single-thread bound and therefore offers no
    benefit on modern high bandwidth filesystems.

We also provide a script that automatically detects when checkpoint files are written to the
checkpoint directory and starts to copy these immediately afterwards to another directory passed to
it as argument. This enables the possibility to write the checkpoint files to non-persistent but
very fast memory such as a RAM disk and then asynchronously copy it from there to slower, persistent
memory while executing the application. However, it should be noted that copying the checkpoint has
to be finished before the next checkpoint is written to the checkpoint directory. Otherwise this can
result in unexpected behavior.

This script can be found here and can be used as shown below (using
the RAM disk as checkpoint directory).

??? example "Asynchronous copy"

    ```bash
    #!/bin/bash

    # Needs $DMTCP_CHECKPOINT_DIR and as first positional argument the directory to copy to
    cd "$DMTCP_CHECKPOINT_DIR" || return
    FILE=.temp
    export ckpt=0
    export FINAL_DIR=$1
    while :
    do
        #Test if files ending on .temp exist in DMTCP_CHECKPOINT_DIR
        if test -f ./*"$FILE";
        then
            while test -f ./*"$FILE"
            do
                sleep 0.1
                ckpt=1
            done
        fi
        if test ckpt -eq 1;
        then
            #Start copy of files, since checkpoint is done
            ckpt=0
            scp -r $DMTCP_CHECKPOINT_DIR $FINAL_DIR
        fi
    done
    ```

??? example "How to use script"

    ```bash
    #/bin/bash
    #SBATCH --time=01:00:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500

    export DMTCP_CHECKPOINT_DIR=/dev/shm
    source $SCRIPT_ROOT/copy_async.sh <MY/DIRECTORY>

    dmtcp_launch --no-gzip --interval 40 <MY/APPLICATION>
    ```

### Troubleshooting

Executing java programs might only work with exporting DMTCP_SIGCKPT=10. 
<!-- TODO test this -->
With OpemMP applications you might need DMTCP_DL_PLUGIN=0.
<!-- TODO in which circumstances is this really needed? -->
