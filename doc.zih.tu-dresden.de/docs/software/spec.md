# SPEChpc2021

SPEChpc2021 is a benchmark suite developed by the Standard Performance Evaluation Corporation
(SPEC) for the evaluation of various, heterogeneous HPC systems. Documentation and released
benchmark results can be found on their [web page](https://www.spec.org/hpc2021/). In fact, our
system 'Taurus' (partition `haswell`) is the benchmark's reference system denoting a score of 1.

The tool includes nine real-world scientific applications (see
[benchmark table](https://www.spec.org/hpc2021/docs/result-fields.html#benchmarks))
with different workload sizes ranging from tiny, small, medium to large, and different parallelization
models including MPI only, MPI+OpenACC, MPI+OpenMP and MPI+OpenMP with target offloading. With this
benchmark suite you can compare the performance of different HPC systems and furthermore, evaluate
parallel strategies for applications on a target HPC system. When you e.g. want to implement an
algorithm, port an application to another platform or integrate acceleration into your code,
you can determine from which target system and parallelization model your application
performance could benefit most. Or this way you can check whether an acceleration scheme can be
deployed and run on a given system, since there could be software issues restricting a capable
hardware (see this [CUDA issue](#cuda-reduction-operation-error)).

Since TU Dresden is a member of the SPEC consortium, the HPC benchmarks can be requested by anyone
interested. Please contact
[Holger Brunst](https://tu-dresden.de/zih/die-einrichtung/struktur/holger-brunst) for access.

## Installation

The target partition determines which of the parallelization models can be used, and vice versa.
For example, if you want to run a model including acceleration, you would have to use a partition
with GPUs.

Once the target partition is determined, follow SPEC's
[Installation Guide](https://www.spec.org/hpg/hpc2021/Docs/install-guide-linux.html).
It is straight-forward and easy to use.

???+ tip "Building for partition `ml`"

    The partition `ml` is a Power9 architecture. Thus, you need to provide the `-e ppc64le` switch
    when installing.

???+ tip "Building with NVHPC for partition `alpha`"

    To build the benchmark for partition `alpha`, you don't need an interactive session
    on the target architecture. You can stay on the login nodes as long as you set the
    flag `-tp=zen`. You can add this compiler flag to the configuration file.

If you are facing errors during the installation process, check the [solved](#solved-issues) and
[unresolved issues](#unresolved-issues) sections. The problem might already be listed there.

## Configuration

The behavior in terms of how to build, run and report the benchmark in a particular environment is
controlled by a configuration file. There are a few examples included in the source code.
Here you can apply compiler tuning and porting, specify the runtime environment and describe the
system under test. SPEChpc2021 has been deployed on the partitions `haswell`, `ml` and
`alpha`, configurations are available. No matter which one you choose as a starting point,
double-check the line that defines the submit command and make sure it says `srun [...]`, e.g.

``` bash
submit = srun $command
```

Otherwise this can cause trouble (see [Slurm bug](#slurm-bug)).
You can also put Slurm options in the configuration but it is recommended to do this in a job
script (see chapter [Execution](#execution)). Use the following to apply your configuration to the
benchmark run:

```
runhpc --config <configfile.cfg> [...]
```

For more details about configuration settings check out the following links:

- [Config Files Description](https://www.spec.org/hpc2021/Docs/config.html)
- [Flag Description](https://www.spec.org/hpc2021/results/res2021q4/hpc2021-20210917-00050.flags.html)
- [Result File Fields Description](https://www.spec.org/hpc2021/docs/result-fields.html)

## Execution

The SPEChpc2021 benchmark suite is executed with the `runhpc` command, which also sets it's
configuration and controls it's runtime behavior. For all options, see SPEC's documentation about
[`runhpc` options](https://www.spec.org/hpc2021/Docs/runhpc.html).
To make it available in the search path, execute `source shrc` in your SPEC installation directory,
first. To submit a job to the Slurm scheduler carrying out the complete benchmark
suite or parts of it as specified, you can use the following job scripts as a template for the
partitions `haswell`, `ml` and `alpha`, respectively. 

- Replace `<p_number_crunch>` (line 2) with your project name
- Replace `ws=</scratch/ws/spec/installation>` (line 16/18) with your SPEC installation path

### Submit SPEChpc Benchmarks with a Job File

=== "submit_spec_haswell_mpi.sh"
    ```bash linenums="1"
    #!/bin/bash
    #SBATCH --account=<p_number_crunch>
    #SBATCH --partition=haswell64
    #SBATCH --exclusive
    #SBATCH --nodes=1
    #SBATCH --ntasks=24
    #SBATCH --cpus-per-task=1
    #SBATCH --mem-per-cpu=2541
    #SBATCH --time=16:00:00
    #SBATCH --constraint=DA

    module purge
    module load Score-P/6.0-gompi-2019a
    # Score-P parameters are set in config/gnu-taurus.cfg

    ws=</scratch/ws/spec/installation>
    cd $ws
    source shrc

    # Use tealeaf scorep run to check the benchmark performance
    BENCH="518.tealeaf_t"

    runhpc -I --config gnu-taurus --define model=mpi --ranks=24 --iterations=1 --tune=base --define tudprof=scorep $BENCH

    # To the actual reportable runs with all benchmarks
    BENCH="tiny"

    runhpc --config gnu-taurus --define model=mpi --ranks=24 --reportable --tune=base --flagsurl=$SPEC/config/flags/gcc_flags.xml $BENCH

    specperl bin/tools/port_progress result/*.log
    ```

=== "submit_spec_ml_openacc.sh"
    ```bash linenums="1"
    #!/bin/bash
    #SBATCH --account=<p_number_crunch>   # account CPU time to Project
    #SBATCH --partition=ml                # ml: 44(176) cores(ht) + 6 GPUs per node
    #SBATCH --exclusive
    #SBATCH --nodes=1
    #SBATCH --ntasks=6                    # number of tasks (MPI processes)
    #SBATCH --cpus-per-task=7             # use 7 threads per task
    #SBATCH --gpus-per-task=1             # use 1 gpu thread per task
    #SBATCH --gres=gpu:6                  # generic consumable resources allocation per node: 6 GPUs
    #SBATCH --mem-per-cpu=5772M
    #SBATCH --time=00:45:00               # run for hh:mm:ss hrs
    #SBATCH --export=ALL
    #SBATCH --hint=nomultithread

    module --force purge
    module load modenv/ml NVHPC OpenMPI/4.0.5-NVHPC-21.2-CUDA-11.2.1

    ws=</scratch/ws/spec/installation>
    cd $ws
    source shrc

    export OMPI_CC=nvc
    export OMPI_CXX=nvc++
    export OMPI_FC=nvfortran

    suite='tiny ^pot3d_t'
    cfg=nvhpc_ppc.cfg

    # test run
    runhpc -I --config $cfg --ranks $SLURM_NTASKS --define pmodel=acc --size=test --noreportable --tune=base --iterations=1 $suite

    # reference run
    runhpc --config $cfg --ranks $SLURM_NTASKS --define pmodel=acc --rebuild --tune=base --iterations=3 $suite
    ```

=== "submit_spec_alpha_openacc.sh"
    ```bash linenums="1"
    #!/bin/bash
    #SBATCH --account=<p_number_crunch>   # account CPU time to Project
    #SBATCH --partition=alpha             # alpha: 48(96) cores(ht) + 8 GPUs per node
    #SBATCH --exclusive
    #SBATCH --nodes=1                     # number of compute nodes
    #SBATCH --ntasks-per-node=8           # number of tasks (MPI processes)
    #SBATCH --cpus-per-task=6             # use 6 threads per task
    #SBATCH --gpus-per-task=1             # use 1 gpu thread per task
    #SBATCH --gres=gpu:8                  # generic consumable resources allocation per node: 8 GPUs
    #SBATCH --mem-per-cpu=20624M          # RAM per CPU
    #SBATCH --time=00:45:00               # run for hh:mm:ss hrs
    #SBATCH --export=ALL
    #SBATCH --hint=nomultithread

    module --force purge
    module load modenv/hiera NVHPC OpenMPI

    ws=</scratch/ws/spec/installation>
    cd $ws
    source shrc

    suite='tiny'
    cfg=nvhpc_alpha.cfg

    # test run
    runhpc -I --config $cfg --ranks $SLURM_NTASKS --define pmodel=acc --size=test --noreportable --tune=base --iterations=1 $suite

    # reference workload
    runhpc --config $cfg --ranks $SLURM_NTASKS --define pmodel=acc --tune=base --iterations=3 $suite
    ```

## Solved Issues

### Fortran Compilation Error

!!! failure "PGF90-F-0004-Corrupt or Old Module file"

!!! note "Explanation"

    If this error arises during runtime, it means that the benchmark binaries and the MPI module
    do not fit together. This happens when you have built the benchmarks written in Fortran with a
    different compiler than which was used to build the MPI module that was loaded for the run.

!!! success "Solution"

    1. Use the correct MPI module
        - The MPI module in use must be compiled with the same compiler that was used to build the
        benchmark binaries. Check the results of `module avail` and choose a corresponding module.
    1. Rebuild the binaries
        - Rebuild the binaries using the same compiler as for the compilation of the MPI module of
        choice.
    1. Request a new module
        - Ask the HPC support to install a compatible MPI module.
    1. Build your own MPI module (as a last step)
        - Download and build a private MPI module using the same compiler as for building the
        benchmark binaries.

### pmix Error

!!! failure "PMIX ERROR"

    ```bash
    It looks like the function `pmix_init` failed for some reason; your parallel process is
    likely to abort. There are many reasons that a parallel process can
    fail during pmix_init; some of which are due to configuration or
    environment problems. This failure appears to be an internal failure;

    mix_progress_thread_start failed
    --> Returned value -1 instead of PMIX_SUCCESS

    *** An error occurred in MPI_Init_thread
    *** on a NULL communicator
    *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
    ***    and potentially your MPI job)
    ```

!!! note "Explanation"

    This is most probably a MPI related issue. If you built your own MPI module, PMIX support might
    be configured wrong.

!!! success "Solution"

    Use `configure --with-pmix=internal` during the `cmake` configuration routine.

### ORTE Error (too many processes)

!!! failure "Error: system limit exceeded on number of processes that can be started"

    ORTE_ERROR_LOG: The system limit on number of children a process can have was reached.

!!! note "Explanation"

    There are too many processes spawned, probably due to a wrong job allocation and/or invocation.

!!! success "Solution"

    Check the invocation command line in your job script. It must not say `srun runhpc [...]`
    there, but only `runhpc [...]`. The submit command in the [configuration](#configuration) file
    already contains `srun`. When `srun` is called in both places, too many parallel processes are
    spawned.

### Error with OpenFabrics Device

!!! warning "There was an error initializing an OpenFabrics device"

!!! note "Explanation"

    "I think it’s just trying to find the InfiniBand libraries, which aren’t used, but can’t.
    It’s probably safe to ignore."
    <p style='text-align: right;'> Matthew Colgrove, Nvidia </p>

!!! success "Solution"

    This is just a warning which cannot be suppressed, but can be ignored.

### Out of Memory

!!! failure "Out of memory"

    ```
    Out of memory allocating [...] bytes of device memory
    call to cuMemAlloc returned error 2: Out of memory
    ```

!!! note "Explanation"

    - When running on a single node with all of its memory allocated, there is not enough memory
    for the benchmark.
    - When running on multiple nodes, this might be a wrong resource distribution caused by Slurm.
    Check the `$SLURM_NTASKS_PER_NODE` environment variable. If it says something like `15,1` when
    you requested 8 processes per node, Slurm was not able to hand over the resource distribution
    to `mpirun`.

!!! success "Solution"

    - Expand your job from single node to multiple nodes.
    - Reduce the workload (e.g. form small to tiny).
    - Make sure to use `srun` instead of `mpirun` as the submit command in your
    [configuration](#configuration) file.

## Unresolved Issues

### CUDA Reduction Operation Error

!!! failure "There was a problem while initializing support for the CUDA reduction operations."

!!! note "Explanation"

    For OpenACC, NVHPC was in the process of adding OpenMP array reduction support which is needed
    for the `pot3d` benchmark. An Nvidia driver version of 450.80.00 or higher is required. Since
    the driver version on partiton `ml` is 440.64.00, it is not supported and not possible to run
    the `pot3d` benchmark in OpenACC mode here.

!!! note "Workaround"

    As for the partition `ml`, you can only wait until the OS update to CentOS 8 is carried out,
    as no driver update will be done beforehand. As a workaround, you can do one of the following:

    - Exclude the `pot3d` benchmark.
    - Switch the partition (e.g. to partition `alpha`).

### Slurm Bug

!!! warning "Wrong resource distribution"

    When working with multiple nodes on partition `ml` or `alpha`, the Slurm parameter
    `$SLURM_NTASKS_PER_NODE` does not work as intended when used in conjunction with `mpirun`.

!!! note "Explanation"

    In the described case, when setting e.g. `SLURM_NTASKS_PER_NODE=8` and calling `mpirun`, Slurm
    is not able to pass on the allocation settings correctly. With two nodes, this leads to a
    distribution of 15 processes on the first node and 1 process on the second node instead. In
    fact, none of the proposed methods of Slurm's man page (like `--distribution=plane=8`) will
    give the result as intended in this case.

!!! note "Workaround"

    - Use `srun` instead of `mpirun`.
    - Use `mpirun` along with a rank-binding perl script (like
    `mpirun -np <ranks> perl <bind.pl> <command>`) as seen on the bottom of the configurations
    [here](https://www.spec.org/hpc2021/results/res2021q4/hpc2021-20210908-00012.cfg) and
    [here](https://www.spec.org/hpc2021/results/res2021q4/hpc2021-20210917-00056.cfg)
    in order to enforce the correct distribution of ranks as it was intended.

### Benchmark Hangs Forever

!!! warning "The benchmark runs forever and produces a timeout."

!!! note "Explanation"

    The reason for this is not known, however, it is caused by the flag `-DSPEC_ACCEL_AWARE_MPI`.

!!! note "Workaround"

    Remove the flag `-DSPEC_ACCEL_AWARE_MPI` from the compiler options in your configuration file.

### Other Issues

For any further issues you can consult SPEC's
[FAQ page](https://www.spec.org/hpc2021/Docs/faq.html), search through their
[known issues](https://www.spec.org/hpc2021/Docs/known-problems.html) or contact their
[support](https://www.spec.org/hpc2021/Docs/techsupport.html).
