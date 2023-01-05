# Checkpoint/Restart

At some point, every HPC system fails, e.g., a compute node or the network might crash causing
running jobs to crash, too. In order to prevent starting your crashed experiments and simulations
from the very beginning, you should be familiar with the concept of checkpointing.

>Checkpointing saves the state of a running process to a checkpointing image file. Using this
file, the process can later be continued (restarted) from where it left off.

Another motivation is to use checkpoint/restart to split long running jobs into several shorter
ones. This might improve the overall job throughput, since shorter jobs can "fill holes" in the job
queue.
Here is an extreme example from literature for the waste of large computing resources due to missing
checkpoints:

>Earth was a supercomputer constructed to find the question to the answer to the Life, the Universe,
and Everything by a race of hyper-intelligent pan-dimensional beings. Unfortunately 10 million years
later, and five minutes before the program had run to completion, the Earth was destroyed by
Vogons.
>"Adams, D. The Hitchhikers Guide Through the Galaxy"

If you wish to do checkpointing, your first step should always be to check if your application
already has such capabilities built-in, as that is the most stable and safe way of doing it.
Applications that are known to have some sort of **native checkpointing** include:

Abaqus, Amber, Gaussian, GROMACS, LAMMPS, NAMD, NWChem, Quantum Espresso, STAR-CCM+, VASP

In case your program does not natively support checkpointing, there are attempts at creating generic
checkpoint/restart solutions that should work application-agnostic. One such project which we
recommend is [Distributed Multi-Threaded Check-Pointing](http://dmtcp.sourceforge.net) (DMTCP).

DMTCP is available on ZIH systems after having loaded the `dmtcp` module

<details open>
    <summary> Example: How to load DMTCP </summary>

    marie@login$ module load DMTCP
</details>

While our batch system [Slurm](slurm.md) also provides a checkpointing interface to the user,
unfortunately, it does not yet support DMTCP at this time. However, there are ongoing efforts of
writing a Slurm plugin that hopefully will change this in the near future. We will update this
documentation as soon as it becomes available.

## Using DMTCP

In the following we will give you step-by-step instructions on how to
checkpoint your job manually for three different use cases:

### Checkpointing in fixed intervals

This is the easiest way to use DMTCP.
* Load the DMTCP module: `module load dmtcp`
* DMTCP usually runs an additional process that
manages the creation of checkpoints and such, the so-called `coordinator`. It starts automatically when calling the `dmtcp_launch` wrapper script or can be started explicitly with `dmtcp_coordinator`. For each application that should be checkpointed one coordinator is needed. DMTCP assumes that every process running under the same coordinator belongs to a single, distributed computation. The coordinator and `dmtcp_launch` can take a handful of parameters, see `man
dmtcp_coordinator` or `man dmtcp_launch`. Via `-i` you can specify an interval (in seconds) in which checkpoint files are
to be created automatically and with `-p` a port for the coordinator can be specified, which is useful when running multiple different coordinators for multiple computations, which should be checkpointed independently on the same host.
* In front of your program call, you have to add the wrapper
script `dmtcp_launch`.  This will create a checkpoint automatically after 40 seconds and then
terminate your application and with it the job. If the job runs into its time limit (here: 60
seconds), the time to write out the checkpoint was probably not long enough. If all went well, you
should find checkpoint files ending on `.dmtcp` in your checkpoint directory (working directory if not specified differently) together with a script called
`./dmtcp_restart_script.sh`. However due to limited support of `Slurm` in DMTCP the restart script does not work. For an explanation on how to restart from an checkpoint image please refer to chapter `Restarting from checkpoint image`. For further information on checkpointing MPI programs with DMTCP please refer to chapter `Multithreading and MPI under DMTCP`.

<details open>
    <summary> Example: How to checkpoint in fixed intervals </summary>

    #/bin/bash
    #SBATCH --time=00:01:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500

    dmtcp_launch -i 40 ./my-application #for sequential/multithreaded applications
    #or: dmtcp_launch -i 40 --ib --rm mpiexec ./my-mpi-application #for MPI
    applications
</details>

### Checkpointing on demand

Checkpointing on demand can be done in two ways. Either the user is requesting checkpoints at any given point or the program itself was modified to request checkpoints by calling the C-function `dmtcp_checkpoint()`.

#### User requested checkpoints

There are two main ways to request checkpoints.
The first one assumes that the `coordinator` is started in a separate terminal by a call to `dmtcp_coordinator`. To request a checkpoint simply type `c` into the terminal of the coordinator.
The second possibility is by issuing `dmtcp_command c` in any terminal running on the same host, for that the `dmtcp_coordinator` does not need to be explicitly started, but can also be implicitly started with a call to `dmtcp_launch`.

#### Application requested checkpoints

Sometimes it might be useful to create a checkpoint at a certain point during the execution of an application.

This is possible by calling the `dmtcp_checkpoint()` function which is provided by DMTCP. This function is made accessible over the header file `dmtcp.h` which needs to be included in the program's source code before calling the function. The program needs to be recompiled and during compile time the `-fPIC` flag needs to be passed to the compiler.
Further the program still needs to run under DMTCP, so it has to be started with `dmtcp_launch <APPLICATION>`.

### Restarting from checkpoint image

Restarting works in a similar way than starting a normal execution. The requested resources should match those of your original job. If you do not wish to create another checkpoint in your restarted run, the `-i` parameter can be omitted this time and the `-p` parameter can again be used to specify a port if multiple computations are running on the same host.

Since the restart script does not work due to limited support for `Slurm` under DMTCP, you need to use `dmtcp_restart <FILENAMES>`. Navigate to the checkpoint directory and call the `dmtcp_restart` command and give the filenames as arguments, if the checkpoint image consists of multiple files and there is only a single checkpoint in the current directory it is possible to restart by running `dmtcp_restart ckpt_*`.

<details open>
    <summary> Example: How to restart from checkpoint </summary>

    #/bin/bash
    #SBATCH --time=00:01:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500

    dmtcp_restart -i 40 ckpt_*
</details>

## Migration of applications

DMTCP enables the possibility to migrate applications even between different architectures. This means that checkpoints which were created on one architecture can be restarted on another architecture in the same manner than explained above.

However it is possible to encounter an `illegal instruction` error, especially when migrating from newer architectures to older ones or between different manufacturers. This comes from an incompatible instruction set and can not be avoided.
    
## Multithreading and MPI under DMTCP

DMTCP does support checkpointing of MPI applications, however since DMTCP has no official support for UCX, checkpointing MPI computations over several nodes is not possible. MPI computations can only be checkpointed when running on a single node and only when using the intel toolchain. The newest version which is proven to run on one node is `intel/2019b`.
It is also possible to run it under the OpenSource FOSS toolchain and create checkpoints, however restarting from those checkpoints is currently not possible, since OpenMPI is not officially supported by DMTCP.

The performance of restarted multithreaded applications can differ heavily depending on the number of processes and architecture used. The more processes or threads the application has and the more NUMA nodes the used architecture has, the higher the performance loss on restarted applications. This holds true for all kinds of multithreaded tasks and is not limited to MPI.
However when restarting an MPI application the speed of the filesystem restarted from has a large influence on the performance of the application, even after the whole checkpoint image is mapped into memory. So it is advised to restart from fast filesystems when using MPI whenever possible.

## Speeding up checkpoints

The checkpoint and restart times depend heavily on the bandwidth of the used filesystem and if gzip compression is enabled or not.

Since it has nearly no benefit on any of our filesystems we strongly advise to disable gzip compression by passing `--no-gzip` option to the `dmtcp_launch` command. Most times the checkpoint data is rather incompressible and gzip is single-thread bound and therefore offers no benefit on modern high bandwidth filesystems.

We also provide a script that automatically detects when checkpoint files are written to the checkpoint directory and starts to copy these immediately afterwards to another directory passed to it as argument. This enables the possibility to write the checkpoint files to non-persistent but very fast memory such as a RAM disk and then asynchronously copy it from there to slower, persistent memory while executing the application. However it should be noted that copying the checkpoint has to be finished before the next checkpoint is written to the checkpoint directory, otherwise this can result in unexpected behavior.
This script can be found here and can be used as shown below (using the RAM disk as checkpoint directory).

<details open>
 <summary> Script: Asynchronous copy </summary>

    #!/bin/sh

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
</details>

<details open>
    <summary> Example: How to use Script </summary>

    #/bin/bash
    #SBATCH --time=00:01:00
    #SBATCH --cpus-per-task=8
    #SBATCH --mem-per-cpu=1500
        
    export DMTCP_CHECKPOINT_DIR=/dev/shm
    source $SCRIPT_ROOT/copy_async.sh <MY/DIRECTORY>

    dmtcp_launch --no-gzip -i 40 <MY/APPLICATION>
</details>
