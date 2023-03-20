---
search:
  boost: 2.0
---

# Batch System Slurm

ZIH uses the batch system Slurm for resource management and job scheduling. Compute nodes are not
accessed directly, but addressed through Slurm. You specify the needed resources
(cores, memory, GPU, time, ...) and Slurm will schedule your job for execution.

When logging in to ZIH systems, you are placed on a login node. There, you can manage your
[data life cycle](../data_lifecycle/overview.md),
setup experiments, and
edit and prepare jobs. The login nodes are not suited for computational work! From the login nodes,
you can interact with the batch system, e.g., submit and monitor your jobs.

??? note "Batch System"

    The batch system is the central organ of every HPC system users interact with its compute
    resources. The batch system finds an adequate compute system (partition) for your compute jobs.
    It organizes the queueing and messaging, if all resources are in use. If resources are available
    for your job, the batch system allocates and connects to these resources, transfers runtime
    environment, and starts the job.

    A workflow could look like this:

    ```mermaid
    sequenceDiagram
        user ->>+ login node: run programm
        login node ->> login node: kill after 5 min
        login node ->>- user: Killed!
        user ->> login node: salloc [...]
        login node ->> Slurm: Request resources
        Slurm ->> user: resources
        user ->>+ allocated resources: srun [options] [command]
        allocated resources ->> allocated resources: run command (on allocated nodes)
        allocated resources ->>- user: program finished
        user ->>+ allocated resources: srun [options] [further_command]
        allocated resources ->> allocated resources: run further command
        allocated resources ->>- user: program finished
        user ->>+ allocated resources: srun [options] [further_command]
        allocated resources ->> allocated resources: run further command
        Slurm ->> allocated resources: Job limit reached/exceeded
        allocated resources ->>- user: Job limit reached
    ```

??? note "Batch Job"

    At HPC systems, computational work and resource requirements are encapsulated into so-called
    jobs. In order to allow the batch system an efficient job placement it needs these
    specifications:

    * requirements: number of nodes and cores, memory per core, additional resources (GPU)
    * maximum run-time
    * HPC project for accounting
    * who gets an email on which occasion

    Moreover, the [runtime environment](../software/overview.md) as well as the executable and
    certain command-line arguments have to be specified to run the computational work.

This page provides a brief overview on

* [Slurm options](#options) to specify resource requirements,
* how to submit [interactive](#interactive-jobs) and [batch jobs](#batch-jobs),
* how to [write job files](#job-files),
* how to [manage and control your jobs](#manage-and-control-jobs).

If you are are already familiar with Slurm, you might be more interested in our collection of
[job examples](slurm_examples.md).
There is also a ton of external resources regarding Slurm. We recommend these links for detailed
information:

- [slurm.schedmd.com](https://slurm.schedmd.com/) provides the official documentation comprising
   manual pages, tutorials, examples, etc.
- [Comparison with other batch systems](https://www.schedmd.com/slurmdocs/rosetta.html)

## Job Submission

There are three basic Slurm commands for job submission and execution:

1. `srun`: Run a parallel application (and, if necessary, allocate resources first).
1. `sbatch`: Submit a batch script to Slurm for later execution.
1. `salloc`: Obtain a Slurm job allocation (i.e., resources like CPUs, nodes and GPUs) for
interactive use. Release the allocation when finished.

Executing a program with `srun` directly on the shell will be blocking and launch an
[interactive job](#interactive-jobs). Apart from short test runs, it is recommended to submit your
jobs to Slurm for later execution by using [batch jobs](#batch-jobs). For that, you can conveniently
put the parameters in a [job file](#job-files), which you can submit using `sbatch
[options] <job file>`.

After submission, your job gets a unique job ID, which is stored in the environment variable
`SLURM_JOB_ID` at job runtime. The command `sbatch` outputs the job ID to stderr. Furthermore, you
can find it via `squeue --me`. The job ID allows you to
[manage and control](#manage-and-control-jobs) your jobs.

!!! warning "srun vs. mpirun"

    On ZIH systems, `srun` is used to run your parallel application. The use of `mpirun` is provenly
    broken on partitions `ml` and `alpha` for jobs requiring more than one node. Especially when
    using code from github projects, double-check its configuration by looking for a line like
    'submit command  mpirun -n $ranks ./app' and replace it with 'srun ./app'.

    Otherwise, this may lead to wrong resource distribution and thus job failure, or tremendous
    slowdowns of your application.

## Options

The following table contains the most important options for `srun`, `sbatch`, `salloc` to specify
resource requirements and control communication.

??? tip "Options Table (see `man sbatch`)"

    | Slurm Option               | Description |
    |:---------------------------|:------------|
    | `-n, --ntasks=<N>`         | Total number of (MPI) tasks (default: 1) |
    | `-N, --nodes=<N>`          | Number of compute nodes |
    | `--ntasks-per-node=<N>`    | Number of tasks per allocated node to start (default: 1) |
    | `-c, --cpus-per-task=<N>`  | Number of CPUs per task; needed for multithreaded (e.g. OpenMP) jobs; typically `N` should be equal to `OMP_NUM_THREADS` |
    | `-p, --partition=<name>`   | Type of nodes where you want to execute your job (refer to [partitions](partitions_and_limits.md)) |
    | `--mem-per-cpu=<size>`     | Memory need per allocated CPU in MB |
    | `-t, --time=<HH:MM:SS>`    | Maximum runtime of the job |
    | `--mail-user=<your email>` | Get updates about the status of the jobs |
    | `--mail-type=ALL`          | For what type of events you want to get a mail; valid options: `ALL`, `BEGIN`, `END`, `FAIL`, `REQUEUE` |
    | `-J, --job-name=<name>`    | Name of the job shown in the queue and in mails (cut after 24 chars) |
    | `--no-requeue`             | Disable requeueing of the job in case of node failure (default: enabled) |
    | `--exclusive`              | Exclusive usage of compute nodes; you will be charged for all CPUs/cores on the node |
    | `-A, --account=<project>`  | Charge resources used by this job to the specified project |
    | `-o, --output=<filename>`  | File to save all normal output (stdout) (default: `slurm-%j.out`) |
    | `-e, --error=<filename>`   | File to save all error output (stderr)  (default: `slurm-%j.out`) |
    | `-a, --array=<arg>`        | Submit an array job ([examples](slurm_examples.md#array-jobs)) |
    | `-w <node1>,<node2>,...`   | Restrict job to run on specific nodes only |
    | `-x <node1>,<node2>,...`   | Exclude specific nodes from job |
    | `--test-only`              | Retrieve estimated start time of a job considering the job queue; does not actually submit the job nor run the application |

!!! note "Output and Error Files"

    When redirecting stderr and stderr into a file using `--output=<filename>` and
    `--stderr=<filename>`, make sure the target path is writeable on the
    compute nodes, i.e., it may not point to a read-only mounted
    [filesystem](../data_lifecycle/overview.md) like `/projects.`

!!! note "No free lunch"

    Runtime and memory limits are enforced. Please refer to the section on [partitions and
    limits](partitions_and_limits.md) for a detailed overview.

### Host List

If you want to place your job onto specific nodes, there are two options for doing this. Either use
`-p, --partition=<name>` to specify a host group aka. [partition](partitions_and_limits.md) that fits
your needs. Or, use `-w, --nodelist=<host1,host2,..>` with a list of hosts that will work for you.

## Interactive Jobs

Interactive activities like editing, compiling, preparing experiments etc. are normally limited to
the login nodes. For longer interactive sessions, you can allocate cores on the compute node with
the command `salloc`. It takes the same options as `sbatch` to specify the required resources.

`salloc` returns a new shell on the node where you submitted the job. You need to use the command
`srun` in front of the following commands to have these commands executed on the allocated
resources. If you allocate more than one task, please be aware that `srun` will run the command on
each allocated task by default! To release the allocated resources, invoke the command `exit` or
`scancel <jobid>`.

```console
marie@login$ salloc --nodes=2
salloc: Pending job allocation 27410653
salloc: job 27410653 queued and waiting for resources
salloc: job 27410653 has been allocated resources
salloc: Granted job allocation 27410653
salloc: Waiting for resource configuration
salloc: Nodes taurusi[6603-6604] are ready for job
marie@login$ hostname
tauruslogin5.taurus.hrsk.tu-dresden.de
marie@login$ srun hostname
taurusi6604.taurus.hrsk.tu-dresden.de
taurusi6603.taurus.hrsk.tu-dresden.de
marie@login$ exit # ending the resource allocation
```

The command `srun` also creates an allocation, if it is running outside any `sbatch` or `salloc`
allocation.

```console
marie@login$ srun --pty --ntasks=1 --cpus-per-task=4 --time=1:00:00 --mem-per-cpu=1700 bash -l
srun: job 13598400 queued and waiting for resources
srun: job 13598400 has been allocated resources
marie@compute$ # Now, you can start interactive work with e.g. 4 cores
```

Since Slurm 20.11 `--exclusive` is the default for `srun` as a step, that means you have to
use `--overlap`, if you want to run `srun` within a `srun` allocation.

```console
marie@login$ srun --pty bash -l
srun: job 27410688 queued and waiting for resources
srun: job 27410688 has been allocated resources
marie@compute$ srun --overlap hostname
taurusi6604.taurus.hrsk.tu-dresden.de
```

!!! note "Using `module` commands in interactive mode"

    The [module commands](../software/modules.md) are made available by sourcing the files
    `/etc/profile` and `~/.bashrc`. This is done automatically by passing the parameter `-l` to your
    shell, as shown in the example above. If you missed adding `-l` at submitting the interactive
    session, no worry, you can source this files also later on manually (`source /etc/profile`).

!!! note "Partition `interactive`"

    A dedicated partition `interactive` is reserved for short jobs (< 8h) with no more than one job
    per user. An interactive partition is available for every regular partition, e.g.
    `alpha-interactive` for `alpha`. Please check the availability of nodes there with
    `sinfo |grep 'interactive\|AVAIL' |less`

### Interactive X11/GUI Jobs

Slurm will forward your X11 credentials to the first (or even all) node for a job with the
(undocumented) `--x11` option.

```console
marie@login$ srun --ntasks=1 --pty --x11=first xeyes
```

!!! hint "X11 error"

    If you are getting the error:

    ```Bash
    srun: error: x11: unable to connect node taurusiXXXX
    ```

    that probably means you still have an old host key for the target node in your
    `~.ssh/known_hosts` file (e.g. from pre-SCS5). This can be solved either by removing the entry
    from your `known_hosts` or by simply deleting the `known_hosts` file altogether if you don't have
    important other entries in it.

## Batch Jobs

Working interactively using `srun` and `salloc` is a good starting point for testing and compiling.
But, as soon as you leave the testing stage, we highly recommend to use batch jobs.
Batch jobs are encapsulated within [job files](#job-files) and submitted to the batch system using
`sbatch` for later execution. A job file is basically a script holding the resource requirements,
environment settings and the commands for executing the application. Using batch jobs and job files
has multiple advantages*:

* You can reproduce your experiments and work, because all steps are saved in a file.
* You can easily share your settings and experimental setup with colleagues.

*) If job files are version controlled or environment `env` is saved along with Slurm output.

!!! hint "Syntax: Submitting a batch job"

    ```console
    marie@login$ sbatch [options] <job_file>
    ```

### Job Files

Job files have to be written with the following structure.

```bash
#!/bin/bash
# ^Batch script starts with shebang line

#SBATCH --ntasks=24                   # #SBATCH lines request resources and
#SBATCH --time=01:00:00               # specify Slurm options
#SBATCH --account=<KTR>               #
#SBATCH --job-name=fancyExp           # All #SBATCH lines have to follow uninterrupted
#SBATCH --output=simulation-%j.out    # after the shebang line
#SBATCH --error=simulation-%j.err     # Comments start with # and do not count as interruptions

module purge                          # Set up environment, e.g., clean/switch modules environment
module load <module1 module2>         # and load necessary modules

srun ./application [options]          # Execute parallel application with srun
```

The following two examples show the basic resource specifications for a pure OpenMP application and
a pure MPI application, respectively. Within the section [Job Examples](slurm_examples.md), we
provide a comprehensive collection of job examples.

??? example "Job file OpenMP"

    ```bash
    #!/bin/bash

    #SBATCH --nodes=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=64
    #SBATCH --time=01:00:00
    #SBATCH --account=<account>

    module purge
    module load <modules>

    export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
    srun ./path/to/openmp_application
    ```

    * Submisson: `marie@login$ sbatch batch_script.sh`
    * Run with fewer CPUs: `marie@login$ sbatch --cpus-per-task=14 batch_script.sh`

??? example "Job file MPI"

    ```bash
    #!/bin/bash

    #SBATCH --ntasks=64
    #SBATCH --time=01:00:00
    #SBATCH --account=<account>

    module purge
    module load <modules>

    srun ./path/to/mpi_application
    ```

    * Submisson: `marie@login$ sbatch batch_script.sh`
    * Run with fewer MPI tasks: `marie@login$ sbatch --ntasks=14 batch_script.sh`

## Heterogeneous Jobs

A heterogeneous job consists of several job components, all of which can have individual job
options. In particular, different components can use resources from different Slurm partitions.
One example for this setting is an MPI application consisting of a master process with a huge memory
footprint and worker processes requiring GPU support.

The `salloc`, `sbatch` and `srun` commands can all be used to submit heterogeneous jobs. Resource
specifications for each component of the heterogeneous job should be separated with ":" character.
Running a job step on a specific component is supported by the option `--het-group`.

```console
marie@login$ salloc --ntasks=1 --cpus-per-task=4 --partition <partition> --mem=200G : \
                    --ntasks=8 --cpus-per-task=1 --gres=gpu:8 --mem=80G --partition <partition>
[...]
marie@login$ srun ./my_application <args for master tasks> : ./my_application <args for worker tasks>
```

Heterogeneous jobs can also be defined in job files. There, it is required to separate multiple
components by a line containing the directive `#SBATCH hetjob`.

```bash
#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=<partition>
#SBATCH --mem=200G
#SBATCH hetjob # required to separate groups
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:8
#SBATCH --mem=80G
#SBATCH --partition=<partition>

srun ./my_application <args for master tasks> : ./my_application <args for worker tasks>

# or as an alternative
srun ./my_application <args for master tasks> &
srun --het-group=1 ./my_application <args for worker tasks> &
wait
```

### Limitations

Due to the way scheduling algorithm works it is required that each component has to be allocated on
a different node. Furthermore, job arrays of heterogeneous jobs are not supported.

## Manage and Control Jobs

### Job and Slurm Monitoring

On the command line, use `squeue` to watch the scheduling queue.

!!! tip "Show your jobs"

    Invoke `squeue --me` to list only your jobs.

In its last column, the `squeue` command will also tell why a job is not running.
Possible reasons and their detailed descriptions are listed in the following table.
More information about job parameters can be obtained with `scontrol -d show
job <jobid>`.

??? tip "Reason Table"

    | Reason             | Long Description  |
    |:-------------------|:------------------|
    | `Dependency`         | This job is waiting for a dependent job to complete. |
    | `None`               | No reason is set for this job. |
    | `PartitionDown`      | The partition required by this job is in a down state. |
    | `PartitionNodeLimit` | The number of nodes required by this job is outside of its partitions current limits. Can also indicate that required nodes are down or drained. |
    | `PartitionTimeLimit` | The jobs time limit exceeds its partitions current time limit. |
    | `Priority`           | One or higher priority jobs exist for this partition. |
    | `Resources`          | The job is waiting for resources to become available. |
    | `NodeDown`           | A node required by the job is down. |
    | `BadConstraints`     | The jobs constraints can not be satisfied. |
    | `SystemFailure`      | Failure of the Slurm system, a filesystem, the network, etc. |
    | `JobLaunchFailure`   | The job could not be launched. This may be due to a filesystem problem, invalid program name, etc. |
    | `NonZeroExitCode`    | The job terminated with a non-zero exit code. |
    | `TimeLimit`          | The job exhausted its time limit. |
    | `InactiveLimit`      | The job reached the system inactive limit. |

For detailed information on why your submitted job has not started yet, you can use the command

```console
marie@login$ whypending <jobid>
```

### Editing Jobs

Jobs that have not yet started can be altered. By using `scontrol update timelimit=4:00:00
jobid=<jobid>`, it is for example possible to modify the maximum runtime. `scontrol` understands
many different options, please take a look at the
[scontrol documentation](https://slurm.schedmd.com/scontrol.html) for more details.

### Canceling Jobs

The command `scancel <jobid>` kills a single job and removes it from the queue. By using `scancel -u
<username>`, you can send a canceling signal to all of your jobs at once.

### Evaluating Jobs

The Slurm command `sacct` provides job statistics like memory usage, CPU time, energy usage etc.
as table-formatted output on the command line.

The job monitor [PIKA](../software/pika.md) provides web-based graphical performance statistics
at no extra cost.

!!! hint "Learn from old jobs"

    We highly encourage you to inspect your previous jobs in order to better
    estimate the requirements, e.g., runtime, for future jobs.
    With PIKA, it is e.g. easy to check whether a job is hanging, idling,
    or making good use of the resources.

??? tip "Using sacct (see also `man sacct`)"
    `sacct` outputs the following fields by default.

    ```console
    # show all own jobs contained in the accounting database
    marie@login$ sacct
        JobID    JobName  Partition    Account  AllocCPUS      State ExitCode
    ------------ ---------- ---------- ---------- ---------- ---------- --------
    [...]
    ```

    We'd like to point your attention to the following options to gain insight in your jobs.

    ??? example "Show specific job"

        ```console
        marie@login$ sacct --jobs=<JOBID>
        ```

    ??? example "Show all fields for a specific job"

        ```console
        marie@login$ sacct --jobs=<JOBID> --format=All
        ```

    ??? example "Show specific fields"

        ```console
        marie@login$ sacct --jobs=<JOBID> --format=JobName,MaxRSS,MaxVMSize,CPUTime,ConsumedEnergy
        ```

    The manual page (`man sacct`) and the [sacct online reference](https://slurm.schedmd.com/sacct.html)
    provide a comprehensive documentation regarding available fields and formats.

    !!! hint "Time span"

        By default, `sacct` only shows data of the last day. If you want to look further into the past
        without specifying an explicit job id, you need to provide a start date via the option
        `--starttime` (or short: `-S`). A certain end date is also possible via `--endtime` (or `-E`).

    ??? example "Show all jobs since the beginning of year 2021"

        ```console
        marie@login$ sacct --starttime 2021-01-01 [--endtime now]
        ```

## Jobs at Reservations

Within a reservation, you have privileged access to HPC resources.
How to ask for a reservation is described in the section
[reservations](overview.md#exclusive-reservation-of-hardware).
After we agreed with your requirements, we will send you an e-mail with your reservation name. Then,
you could see more information about your reservation with the following command:

```console
marie@login$ scontrol show res=<reservation name>
# e.g. scontrol show res=hpcsupport_123
```

If you want to use your reservation, you have to add the parameter
`--reservation=<reservation name>` either in your job script or to your `srun` or `salloc` command.

## Node Features for Selective Job Submission

The nodes in our HPC system are becoming more diverse in multiple aspects, e.g, hardware, mounted
storage, software. The system administrators can describe the set of properties and it is up to you
as user to specify the requirements. These features should be thought of as changing over time
(e.g., a filesystem get stuck on a certain node).

A feature can be used with the Slurm option `-C, --constraint=<ARG>` like
`srun --constraint="fs_lustre_scratch2" [...]` with `srun` or `sbatch`.

Multiple features can also be combined using AND, OR, matching OR, resource count etc.
E.g., `--constraint="fs_beegfs|fs_lustre_ssd"` requests for nodes with at least one of the
features `fs_beegfs` and `fs_lustre_ssd`. For a detailed description of the possible
constraints, please refer to the [Slurm documentation](https://slurm.schedmd.com/srun.html#OPT_constraint).

!!! hint

      A feature is checked only for scheduling. Running jobs are not affected by changing features.

### Filesystem Features

A feature `fs_*` is active if a certain filesystem is mounted and available on a node. Access to
these filesystems are tested every few minutes on each node and the Slurm features are set accordingly.

| Feature              | Description                                                        | [Workspace Name](../data_lifecycle/workspaces.md#extension-of-a-workspace) |
|:---------------------|:-------------------------------------------------------------------|:---------------------------------------------------------------------------|
| `fs_lustre_scratch2` | `/scratch` mounted read-write (mount point is `/lustre/scratch2`)  | `scratch`                                                                  |
| `fs_lustre_ssd`      | `/ssd` mounted read-write (mount point is `/lustre/ssd`)           | `ssd`                                                                      |
| `fs_warm_archive_ws` | `/warm_archive/ws` mounted read-only                               | `warm_archive`                                                             |
| `fs_beegfs_global0`  | `/beegfs/global0` mounted read-write                               | `beegfs_global0`                                                           |
| `fs_beegfs`          | `/beegfs` mounted read-write                                       | `beegfs`                                                                   |

For certain projects, specific filesystems are provided. For those,
additional features are available, like `fs_beegfs_<projectname>`.
