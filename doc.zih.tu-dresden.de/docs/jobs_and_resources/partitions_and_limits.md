# Partitions and Limits

There is no such thing as free lunch at ZIH systems. Since compute nodes are operated in multi-user
node by default, jobs of several users can run at the same time at the very same node sharing
resources, like memory (but not CPU). On the other hand, a higher throughput can be achieved by
smaller jobs. Thus, restrictions w.r.t. [memory](#memory-limits) and
[runtime limits](#runtime-limits) have to be respected when submitting jobs.

## Runtime Limits

!!! warning "Runtime limits on login nodes"

    There is a time limit of 600 seconds set for processes on login nodes. Each process running
    longer than this time limit is automatically killed. The login nodes are shared ressources
    between all users of ZIH system and thus, need to be available and cannot be used for productive
    runs.

    ```
    CPU time limit exceeded
    ```

    Please submit extensive application runs to the compute nodes using the [batch system](slurm.md).

!!! note "Runtime limits are enforced."

    A job is canceled as soon as it exceeds its requested limit. Currently, the maximum run time
    limit is 7 days.

Shorter jobs come with multiple advantages:

- lower risk of loss of computing time,
- shorter waiting time for scheduling,
- higher job fluctuation; thus, jobs with high priorities may start faster.

To bring down the percentage of long running jobs we restrict the number of cores with jobs longer
than 2 days to approximately 50% and with jobs longer than 24 to 75% of the total number of cores.
(These numbers are subject to change.) As best practice we advise a run time of about 8h.

!!! hint "Please always try to make a good estimation of your needed time limit."

    For this, you can use a command line like this to compare the requested timelimit with the
    elapsed time for your completed jobs that started after a given date:

    ```console
    marie@login$ sacct -X -S 2021-01-01 -E now --format=start,JobID,jobname,elapsed,timelimit -s COMPLETED
    ```

Instead of running one long job, you should split it up into a chain job. Even applications that are
not capable of checkpoint/restart can be adapted. Please refer to the section
[Checkpoint/Restart](../jobs_and_resources/checkpoint_restart.md) for further documentation.

## Memory Limits

!!! note "Memory limits are enforced."

    Jobs which exceed their per-node memory limit are killed automatically by the batch system.

Memory requirements for your job can be specified via the `sbatch/srun` parameters:

`--mem-per-cpu=<MB>` or `--mem=<MB>` (which is "memory per node"). The **default limit** regardless
of the partition it runs on is quite low at **300 MB** per CPU. If you need more memory, you need
to request it.

ZIH systems comprise different sets of nodes with different amount of installed memory which affect
where your job may be run. To achieve the shortest possible waiting time for your jobs, you should
be aware of the limits shown in the
[Partitions and limits table](../jobs_and_resources/partitions_and_limits.md#slurm-partitions).

## Slurm Partitions

The available compute nodes are grouped into logical (possibly overlapping) sets, the so-called
**partitions**. You can submit your job to a certain partition using the Slurm option
`--partition=<partition-name>`.

Some partitions/nodes have Simultaneous Multithreading (SMT) enabled. You request for this
additional threads using the Slurm option `--hint=multithread` or by setting the environment
varibale `SLURM_HINT=multithread`. Besides the usage of the threads to speed up the computations,
the memory of the other threads is allocated implicitly, too, and you will allways get
`Memory per Core`*`number of threads` as memory pledge.

Some partitions have a *interactive* counterpart for interactive jobs. The corresponding partitions
are suffixed with `-interactive` (e.g. `ml-interactive`) and have the same configuration.

There is also a meta partition `haswell`, which contains the partitions `haswell64`,
`haswell256` and `smp2`. `haswell` is also the default partition. If you specify no partition or
partition `haswell` a Slurm plugin will choose the partition which fits to your memory requirements.
There are some other partitions, which are not specified in the table above, but those partitions
should not be used directly.

<!-- partitions_and_limits_table -->
| Partition | Nodes | # Nodes | Cores per Node | Threads per Core | Memory per Node [in MB] | Memory per Core [in MB] | GPUs per Node
|:--------|:------|--------:|---------------:|------------:|------------:|--------------:|--------------:|
| gpu2 | taurusi[2045-2103] | 59 | 24 | 1 | 62,000 | 2,583 | 4 |
| gpu2-interactive | taurusi[2045-2103] | 59 | 24 | 1 | 62,000 | 2,583 | 4 |
| haswell | taurusi[6001-6604],taurussmp[3-7] | 609 |   |   |   |   |   |
| haswell64 | taurusi[6001-6540,6559-6604] | 586 | 24 | 1 | 61,000 | 2,541 |    |
| haswell256 | taurusi[6541-6558] | 18 | 24 | 1 | 254,000 | 10,583 |    |
| interactive | taurusi[6605-6612] | 8 | 24 | 1 | 61,000 | 2,541 |    |
| smp2 | taurussmp[3-7] | 5 | 56 | 1 | 2,044,000 | 36,500 |    |
| hpdlf | taurusa[3-16] | 14 | 12 | 1 | 95,000 | 7,916 | 3 |
| ml | taurusml[3-32] | 30 | 44 | 4 | 254,000 | 1,443 | 6 |
| ml-interactive | taurusml[1-2] | 2 | 44 | 4 | 254,000 | 1,443 | 6 |
| romeo | taurusi[7003-7192] | 190 | 128 | 2 | 505,000 | 1,972 |    |
| romeo-interactive | taurusi[7001-7002] | 2 | 128 | 2 | 505,000 | 1,972 |    |
| julia | taurussmp8 | 1 | 896 | 1 | 48,390,000 | 54,006 |    |
| alpha | taurusi[8003-8034] | 32 | 48 | 2 | 990,000 | 10,312 | 8 |
| alpha-interactive | taurusi[8001-8002] | 2 | 48 | 2 | 990,000 | 10,312 | 8 |
{: summary="Partitions and limits table" align="bottom"}
