# GPU Programming

## Available GPUs

The full hardware specifications of the GPU-compute nodes may be found in the
[HPC Resources](../jobs_and_resources/hardware_overview.md#hpc-resources) page.
Each node uses a different [module environment](modules.md#module-environments):

* [NVIDIA Tesla K80 GPUs nodes](../jobs_and_resources/hardware_overview.md#island-2-phase-2-intel-haswell-cpus-nvidia-k80-gpus)
(partition `gpu2`): use the default `scs5` module environment (`module switch modenv/scs5`).
* [NVIDIA Tesla V100 nodes](../jobs_and_resources/hardware_overview.md#ibm-power9-nodes-for-machine-learning)
(partition `ml`): use the `ml` module environment (`module switch modenv/ml`)
* [NVIDIA A100 nodes](../jobs_and_resources/hardware_overview.md#amd-rome-cpus-nvidia-a100)
(partition `alpha`): use the `hiera` module environment (`module switch modenv/hiera`)

## Using GPUs with Slurm

For general information on how to use Slurm, read the respective [page in this compendium](../jobs_and_resources/slurm.md).
When allocating resources on a GPU-node, you must specify the number of requested GPUs by using the
`--gres=gpu:<N>` option, like this:

=== "partition `gpu2`"
    ```bash
    #!/bin/bash                           # Batch script starts with shebang line

    #SBATCH --ntasks=1                    # All #SBATCH lines have to follow uninterrupted
    #SBATCH --time=01:00:00               # after the shebang line
    #SBATCH --account=<KTR>               # Comments start with # and do not count as interruptions
    #SBATCH --job-name=fancyExp
    #SBATCH --output=simulation-%j.out
    #SBATCH --error=simulation-%j.err
    #SBATCH --partition=gpu2
    #SBATCH --gres=gpu:1                  # request GPU(s) from Slurm

    module purge                          # Set up environment, e.g., clean modules environment
    module switch modenv/scs5             # switch module environment
    module load <modules>                 # and load necessary modules

    srun ./application [options]          # Execute parallel application with srun
    ```
=== "partition `ml`"
    ```bash
    #!/bin/bash                           # Batch script starts with shebang line

    #SBATCH --ntasks=1                    # All #SBATCH lines have to follow uninterrupted
    #SBATCH --time=01:00:00               # after the shebang line
    #SBATCH --account=<KTR>               # Comments start with # and do not count as interruptions
    #SBATCH --job-name=fancyExp
    #SBATCH --output=simulation-%j.out
    #SBATCH --error=simulation-%j.err
    #SBATCH --partition=ml
    #SBATCH --gres=gpu:1                  # request GPU(s) from Slurm

    module purge                          # Set up environment, e.g., clean modules environment
    module switch modenv/ml               # switch module environment
    module load <modules>                 # and load necessary modules

    srun ./application [options]          # Execute parallel application with srun
    ```
=== "partition `alpha`"
    ```bash
    #!/bin/bash                           # Batch script starts with shebang line

    #SBATCH --ntasks=1                    # All #SBATCH lines have to follow uninterrupted
    #SBATCH --time=01:00:00               # after the shebang line
    #SBATCH --account=<KTR>               # Comments start with # and do not count as interruptions
    #SBATCH --job-name=fancyExp
    #SBATCH --output=simulation-%j.out
    #SBATCH --error=simulation-%j.err
    #SBATCH --partition=alpha
    #SBATCH --gres=gpu:1                  # request GPU(s) from Slurm

    module purge                          # Set up environment, e.g., clean modules environment
    module switch modenv/hiera            # switch module environment
    module load <modules>                 # and load necessary modules

    srun ./application [options]          # Execute parallel application with srun
    ```

Alternatively, you can work on the partitions interactively:

```bash
marie@login$ srun --partition=<partition>-interactive --gres=gpu:<N> --pty bash
marie@compute$ module purge; module switch modenv/<env>
```

## Directive Based GPU Programming

Directives are special compiler commands in your C/C++ or Fortran source code. They tell the
compiler how to parallelize and offload work to a GPU. This section explains how to use this
technique.

### OpenACC

[OpenACC](https://www.openacc.org) is a directive based GPU programming model. It currently
only supports NVIDIA GPUs as a target.

Please use the following information as a start on OpenACC:

#### Introduction

OpenACC can be used with the PGI and NVIDIA HPC compilers. The NVIDIA HPC compiler, as part of the
[NVIDIA HPC SDK](https://docs.nvidia.com/hpc-sdk/index.html), supersedes the PGI compiler.

Various versions of the PGI compiler are available on the
[NVIDIA Tesla K80 GPUs nodes](../jobs_and_resources/hardware_overview.md#island-2-phase-2-intel-haswell-cpus-nvidia-k80-gpus)
(partition `gpu2`).

The `nvc` compiler (NOT the `nvcc` compiler, which is used for CUDA) is available for the NVIDIA
Tesla V100 and Nvidia A100 nodes.

#### Using OpenACC with PGI compilers

* Load the latest version via `module load PGI` or search for available versions with
`module search PGI`
* For compilation, please add the compiler flag `-acc` to enable OpenACC interpreting by the
  compiler
* `-Minfo` tells you what the compiler is actually doing to your code
* Add `-ta=nvidia:keple` to enable optimizations for the K80 GPUs
* You may find further information on the PGI compiler in the
[user guide](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-user-guide/index.htm)
and in the [reference guide](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-ref-guide/index.htm),
which includes descriptions of available
[command line options](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-ref-guide/index.htm#cmdln-options-ref)

#### Using OpenACC with NVIDIA HPC compilers

* Switch into the correct module environment for your selected compute nodes
(see [list of available GPUs](#available-gpus))
* Load the `NVHPC` module for the correct module environment.
Either load the default (`module load NVHPC`) or search for a specific version.
* Use the correct compiler for your code: `nvc` for C, `nvc++` for C++ and `nvfortran` for Fortran
* Use the `-acc` and `-Minfo` flag as with the PGI compiler
* To create optimized code for either the V100 or A100, use `-gpu=cc70` or `-gpu=cc80`, respectively
* Further information on this compiler is provided in the
[user guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/index.html) and the
[reference guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/index.html),
which includes descriptions of available
[command line options](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/index.html#cmdln-options-ref)
* Information specific the use of OpenACC with the NVIDIA HPC compiler is compiled in a
[guide](https://docs.nvidia.com/hpc-sdk/compilers/openacc-gs/index.html)

### OpenMP target offloading

[OpenMP](https://www.openmp.org/) supports target offloading as of version 4.0. A dedicated set of
compiler directives can be used to annotate code-sections that are intended for execution on the
GPU (i.e., target offloading). Not all compilers with OpenMP support target offloading, refer to
the [official list](https://www.openmp.org/resources/openmp-compilers-tools/) for details.
Furthermore, some compilers, such as GCC, have basic support for target offloading, but do not
enable these features by default and/or achieve poor performance.

On the ZIH system, compilers with OpenMP target offloading support are provided on the partitions
`ml` and `alpha`. Two compilers with good performance can be used: the NVIDIA HPC compiler and the
IBM XL compiler.

#### Using OpenMP target offloading with NVIDIA HPC compilers

* Load the module environments and the NVIDIA HPC SDK as described in the
[OpenACC](#using-openacc-with-nvidia-hpc-compilers) section
* Use the `-mp=gpu` flag to enable OpenMP with offloading
* `-Minfo` tells you what the compiler is actually doing to your code
* The same compiler options as mentioned [above](#using-openacc-with-nvidia-hpc-compilers) are
available for OpenMP, including the `-gpu=ccXY` flag as mentioned above.
* OpenMP-specific advice may be found in the
[respective section in the user guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/#openmp-use)

#### Using OpenMP target offloading with the IBM XL compilers

The IBM XL compilers (`xlc` for C, `xlc++` for C++ and `xlf` for Fortran (with sub-version for
different versions of Fortran)) are only available on the partition `ml` with NVIDIA Tesla V100 GPUs.
They are available by default when switching to `modenv/ml`.

* The `-qsmp -qoffload` combination of flags enables OpenMP target offloading support
* Optimizations specific to the V100 GPUs can be enabled by using the
[`-qtgtarch=sm_70`](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1?topic=descriptions-qtgtarch)
flag.
* IBM provides a [XL compiler documentation](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1)
with a
[list of supported OpenMP directives](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1?topic=reference-pragma-directives-openmp-parallelization)
and information on
[target-offloading specifics](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1?topic=gpus-programming-openmp-device-constructs)

## Native GPU Programming

### CUDA

Native [CUDA](http://www.nvidia.com/cuda) programs can sometimes offer a better performance.
NVIDIA provides some [introductory material and links](https://developer.nvidia.com/how-to-cuda-c-cpp).
An [introduction to CUDA](https://developer.nvidia.com/blog/even-easier-introduction-cuda/) is
provided as well. The [toolkit documentation page](https://docs.nvidia.com/cuda/index.html) links to
the [programming guide](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html) and the
[best practice guide](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html).
Optimization guides for supported NVIDIA architectures are available, including for
[Kepler (K80)](https://docs.nvidia.com/cuda/kepler-tuning-guide/index.html),
[Volta (V100)](https://docs.nvidia.com/cuda/volta-tuning-guide/index.html) and
[Ampere (A100)](https://docs.nvidia.com/cuda/ampere-tuning-guide/index.html).

In order to compile an application with CUDA use the `nvcc` compiler command, which is described in
detail in [nvcc documentation](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html).
This compiler is available via several `CUDA` packages, a default version can be loaded via
`module load CUDA`. Additionally, the `NVHPC` modules provide CUDA tools as well.

For using CUDA with OpenMPI at multiple nodes, the OpenMPI module loaded shall have be compiled with CUDA 
support. If you aren't sure if the module you are using has support for it you can check it as following:

```console
ompi_info --parsable --all | grep mpi_built_with_cuda_support:value | awk -F":" '{print "OpenMPI supports CUDA:",$7}'
```

#### Usage of the CUDA compiler

The simple invocation `nvcc <code.cu>` will compile a valid CUDA program. `nvcc` differentiates
between the device and the host code, which will be compiled in separate phases. Therefore, compiler
options can be defined specifically for the device as well as for the host code. By default, the GCC
is used as the host compiler. The following flags may be useful:

* `--generate-code` (`-gencode`): generate optimized code for a target GPU (caution: these binaries
cannot be used with GPUs of other generations).
    * For Kepler (K80): `--generate-code arch=compute_37,code=sm_37`,
    * For Volta (V100): `--generate-code arch=compute_70,code=sm_70`,
    * For Ampere (A100): `--generate-code arch=compute_80,code=sm_80`
* `-Xcompiler`: pass flags to the host compiler. E.g., generate OpenMP-parallel host code:
`-Xcompiler -fopenmp`.
The `-Xcompiler` flag has to be invoked for each host-flag

## Performance Analysis

Consult NVIDIA's [Best Practices Guide](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html)
and the [performance guidelines](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#performance-guidelines)
for possible steps to take for the performance analysis and optimization.

Multiple tools can be used for the performance analysis.
For the analysis of applications on the older K80 GPUs, we recommend two
[profiler tools](https://docs.nvidia.com/cuda/profiler-users-guide/index.html):
the NVIDIA [nvprof](https://docs.nvidia.com/cuda/profiler-users-guide/index.html#nvprof-overview)
command line profiler and the
[NVIDIA Visual Profiler](https://docs.nvidia.com/cuda/profiler-users-guide/index.html#visual)
as the accompanying graphical profiler. These tools will be deprecated in future CUDA releases but
are still available in CUDA <= 11. On the newer GPUs (V100 and A100), we recommend the use of of the
newer NVIDIA Nsight tools, [Nsight Systems](https://developer.nvidia.com/nsight-systems) for a
system wide sampling and tracing and [Nsight Compute](https://developer.nvidia.com/nsight-compute)
for a detailed analysis of individual kernels.

### NVIDIA nvprof & Visual Profiler

The nvprof command line and the Visual Profiler are available once a CUDA module has been loaded.
For a simple analysis, you can call `nvprof` without any options, like such:

```bash
marie@compute$ nvprof ./application [options]
```

For a more in-depth analysis, we recommend you use the command line tool first to generate a report
file, which you can later analyze in the Visual Profiler. In order to collect a set of general
metrics for the analysis in the Visual Profiler, use the `--analysis-metrics` flag to collect
metrics and `--export-profile` to generate a report file, like this:

```bash
marie@compute$ nvprof --analysis-metrics --export-profile  <output>.nvvp ./application [options]
```

[Transfer the report file to your local system](../data_transfer/export_nodes.md) and analyze it in
the Visual Profiler (`nvvp`) locally. This will give the smoothest user experience. Alternatively,
you can use [X11-forwarding](../access/ssh_login.md). Refer to the documentation for details about
the individual
[features and views of the Visual Profiler](https://docs.nvidia.com/cuda/profiler-users-guide/index.html#visual-views).

Besides these generic analysis methods, you can profile specific aspects of your GPU kernels.
`nvprof` can profile specific events. For this, use

```bash
marie@compute$ nvprof --query-events
```

to get a list of available events.
Analyze one or more events by using specifying one or more events, separated by comma:

```bash
marie@compute$ nvprof --events <event_1>[,<event_2>[,...]] ./application [options]
```

Additionally, you can analyze specific metrics.
Similar to the profiling of events, you can get a list of available metrics:

```bash
marie@compute$ nvprof --query-metrics
```

One or more metrics can be profiled at the same time:

```bash
marie@compute$ nvprof --metrics <metric_1>[,<metric_2>[,...]] ./application [options]
```

If you want to limit the profiler's scope to one or more kernels, you can use the
`--kernels <kernel_1>[,<kernel_2>]` flag. For further command line options, refer to the
[documentation on command line options](https://docs.nvidia.com/cuda/profiler-users-guide/index.html#nvprof-command-line-options).

### NVIDIA Nsight Systems

Use [NVIDIA Nsight Systems](https://developer.nvidia.com/nsight-systems) for a system-wide sampling
of your code. Refer to the
[NVIDIA Nsight Systems User Guide](https://docs.nvidia.com/nsight-systems/UserGuide/index.html) for
details. With this, you can identify parts of your code that take a long time to run and are
suitable optimization candidates.

Use the command-line version to sample your code and create a report file for later analysis:

```bash
marie@compute$ nsys profile [--stats=true] ./application [options]
```

The `--stats=true` flag is optional and will create a summary on the command line. Depending on your
needs, this analysis may be sufficient to identify optimizations targets.

The graphical user interface version can be used for a thorough analysis of your previously
generated report file. For an optimal user experience, we recommend a local installation of NVIDIA
Nsight Systems. In this case, you can
[transfer the report file to your local system](../data_transfer/export_nodes.md).
Alternatively, you can use [X11-forwarding](../access/ssh_login.md). The graphical user interface is
usually available as `nsys-ui`.

Furthermore, you can use the command line interface for further analyses. Refer to the
documentation for a
[list of available command line options](https://docs.nvidia.com/nsight-systems/UserGuide/index.html#cli-options).

### NVIDIA Nsight Compute

Nsight Compute is used for the analysis of individual GPU-kernels. It supports GPUs from the Volta
architecture onward (on the ZIH system: V100 and A100). Therefore, you cannot use Nsight Compute on
the partition `gpu2`. If you are familiar with nvprof, you may want to consult the
[Nvprof Transition Guide](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html#nvprof-guide),
as Nsight Compute uses a new scheme for metrics.
We recommend those kernels as optimization targets that require a large portion of you run time,
according to Nsight Systems. Nsight Compute is particularly useful for CUDA code, as you have much
greater control over your code compared to the directive based approaches.

Nsight Compute comes in a
[command line](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)
and a [graphical version](https://docs.nvidia.com/nsight-compute/NsightCompute/index.html).
Refer to the
[Kernel Profiling Guide](https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html)
to get an overview of the functionality of these tools.

You can call the command line version (`ncu`) without further options to get a broad overview of
your kernel's performance:

```bash
marie@compute$ ncu ./application [options]
```

As with the other profiling tools, the Nsight Compute profiler can generate report files like this:

```bash
marie@compute$ ncu --export <report> ./application [options]
```

The report file will automatically get the file ending `.ncu-rep`, you do not need to specify this
manually.

This report file can be analyzed in the graphical user interface profiler. Again, we recommend you
generate a report file on a compute node and
[transfer the report file to your local system](../data_transfer/export_nodes.md).
Alternatively, you can use [X11-forwarding](../access/ssh_login.md). The graphical user interface is
usually available as `ncu-ui` or `nv-nsight-cu`.

Similar to the `nvprof` profiler, you can analyze specific metrics. NVIDIA provides a
[Metrics Guide](https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html#metrics-guide). Use
`--query-metrics` to get a list of available metrics, listing them by base name. Individual metrics
can be collected by using

```bash
marie@compute$ ncu --metrics <metric_1>[,<metric_2>,...] ./application [options]
```

Collection of events is no longer possible with Nsight Compute. Instead, many nvprof events can be
[measured with metrics](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html#nvprof-event-comparison).

You can collect metrics for individual kernels by specifying the `--kernel-name` flag.
