# GPU Programming

## Available GPUs

The full hardware specifications of the compute nodes may be found in the 
[HPC Resources](../jobs_and_resources/hardware_overview.md/#hpc-resources) page.
Each node uses a different [module environment](modules.md/#module-environments): 
* [NVIDIA Tesla K80 GPUs nodes](../jobs_and_resources/hardware_overview.md/#island-2-phase-2-intel-haswell-cpus-nvidia-k80-gpus) 
(partition `gpu2`) use the default `scs5` module environment (`module switch modenv/scs5`). 
* [NVIDIA Tesla V100 nodes](../jobs_and_resources/hardware_overview.md/#ibm-power9-nodes-for-machine-learning) 
(partition `ml`) use the `ml` module environment (`modenv switch modenv/ml`)
* [NVIDIA A100 nodes](../jobs_and_resources/hardware_overview.md/#amd-rome-cpus-nvidia-a100) 
(partition `alpha`) use the `hiera` module environment (`module switch modenv/hiera`)

## Using GPUs with Slurm

For general information on how to use Slurm, read the respective [page in this compendium](../jobs_and_resources/slurm.md).
When allocating resources on a GPU-node, you must specify the number of requested GPUs, like
this:

```bash
#!/bin/bash                           # Batch script starts with shebang line

#SBATCH --ntasks=1                    # All #SBATCH lines have to follow uninterrupted
#SBATCH --time=01:00:00               # after the shebang line
#SBATCH --account=<KTR>               # Comments start with # and do not count as interruptions
#SBATCH --job-name=fancyExp
#SBATCH --output=simulation-%j.out
#SBATCH --error=simulation-%j.err
#SBATCH --partition=<gpu-partition>   # specify the GPU-partition (gpu2, ml, alpha)
#SBATCH --gres=gpu:1                  # request GPU(s) from Slurm

module purge                          # Set up environment, e.g., clean modules environment
module switch modenv/<env>            # switch to module environment for GPU-partition
module load <modules>                 # and load necessary modules

srun ./application [options]          # Execute parallel application with srun

```

Alternatively, you can work on the GPU partitions interactively:

```bash
marie@login$ srun --partition=<partition>-interactive --gres=gpu:<N> --pty bash
marie@<compute>$ module purge; modenv switch modenv/<env> 
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

OpenACC can be used with the PGI and NVIDIA HPC compilers. The NVIDIA HPC compiler, as part 
of the [NVIDIA HPC SDK](https://docs.nvidia.com/hpc-sdk/index.html), supercedes the PGI compiler. 

Various versions of the PGI compiler are available on the [NVIDIA Tesla K80 GPUs nodes](../jobs_and_resources/hardware_overview.md/#island-2-phase-2-intel-haswell-cpus-nvidia-k80-gpus) (partition `gpu2`). 

The `nvc` compiler (NOT the `nvcc` compiler, which is used for CUDA) is available for the 
NVIDIA Tesla V100 and Nvidia A100 nodes.

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
which includes descriptions of available [command line options](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-ref-guide/index.htm#cmdln-options-ref)

#### Using OpenACC with NVIDIA HPC compilers

* Switch into the correct module environment for your selected compute nodes 
(see [list of available GPUs](#available-gpus))
* Load the `NVHPC` module for the correct module environment. DE

Either load the default (`module load NVHPC`) or search for a specific version.
* Use the correct compiler for your code: `nvc` for C, `nvc++` for C++ and `nvfortran` for Fortran
* Use the `-acc` and `-Minfo` flag as with the PGI compiler
* To create optimized code for either the V100 or A100, use `-gpu=cc70` or `-gpu=cc80`, respectively
* Further information on this compiler is provided in the 
[user guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/index.html) and the 
[reference guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/index.html), 
which includes descriptions of available [command line options](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/index.html#cmdln-options-ref) 
* Information specific the use of OpenACC with the NVIDIA HPC compiler is compiled in a 
[guide](https://docs.nvidia.com/hpc-sdk/compilers/openacc-gs/index.html)

### OpenMP target offloading

[OpenMP](https://www.openmp.org/) supports target offloading as of version 4.0. 
A dedicated set of compiler directives can be used to annotate code-sections that are intended
 for execution on the GPU (i.e., target offloading).
Not all compilers with OpenMP support target offloading, refer to the [official list](https://www.openmp.org/resources/openmp-compilers-tools/) 
for details. 
Furthermore, some compilers, such as GCC, have basic support for target offloading, 
but do not enable these features by default and/or achieve poor performance.

On the ZIH system, two compilers with good performance can be used: the NVIDIA HPC compiler 
and the IBM XL compiler.

#### Using OpenMP target offloading with NVIDIA HPC compilers

* Load the module environments and the NVIDIA HPC SDK as described in the [OpenACC](#using-openacc-with-nvidia-hpc-compilers) section
* Use the `-mp=gpu` flag to enable OpenMP with offloading
* `-Minfo` tells you what the compiler is actually doing to your code
* The same compiler options as linked above are available for OpenMP, 
including the `-gpu=ccXY` flag as mentioned above.
* OpenMP-secific advice may be found in the [respective section in the user guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/#openmp-use)

#### Using OpenMP target offloading with the IBM XL compilers

The IBM XL compilers (`xlc` for C, `xlc++` for C++ and `xlf` for Fortran (with sub-version for 
different versions of Fortran)) are only available on the partition `ml` with NVIDIA Tesla V100 GPUs.
They are available by default when switching to `modenv/ml`.

* The `-qsmp -qoffload` combination of flags enables OpenMP target offloading support
* Optimizations specific to the V100 GPUs can be enabled by using the [`-qtgtarch=sm_70`](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1?topic=descriptions-qtgtarch) flag. 
* IBM provides [documentation](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1) 
for the compiler with a [list of supported OpenMP directives](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1?topic=reference-pragma-directives-openmp-parallelization) 
and information on [target-offloading specifics](https://www.ibm.com/docs/en/xl-c-and-cpp-linux/16.1.1?topic=gpus-programming-openmp-device-constructs)


## Native GPU Programming

### CUDA

Native [CUDA](http://www.nvidia.com/cuda) programs can sometimes offer a better performance.
NVIDIA provides some [introductory material and links](https://developer.nvidia.com/how-to-cuda-c-cpp). 
An introduction is [provided as well](https://developer.nvidia.com/blog/even-easier-introduction-cuda/).
The [toolkit documentation page](https://docs.nvidia.com/cuda/index.html) links to the 
[programming guide](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html) and the 
[best practice guide](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html).
Optimization guides for supported NVIDIA architectures are available, including for 
[Kepler (k80)](https://docs.nvidia.com/cuda/kepler-tuning-guide/index.html), 
[Volta (V100)](https://docs.nvidia.com/cuda/volta-tuning-guide/index.html) and 
[Ampere (A100)](https://docs.nvidia.com/cuda/ampere-tuning-guide/index.html).

In order to compile an application with CUDA use the `nvcc` compiler command, which is described in 
detail in its [documentation](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html). 
This compiler is available via several `CUDA` packages, a default version can be loaded via `module load CUDA`.
Additionally, the `NVHPC` modules provide CUDA tools as well.

#### Usage of the CUDA compiler

The simple invocation `nvcc <code.cu>` will compile a valid CUDA program. 
`nvcc` differentiates between the device and the host code, which will be compiled in seperate phases.
Therefore, compiler options can be defined specifically for the device as well as for the host code.
The following flags may be useful:

* `--generate-code` (`-gencode`): generate optimized code for a target GPU (caution: these binaries
cannot be used with GPUs of other generations). 
    * For Kepler (K80): `--generate-code arch=compute_37,code=sm_37`, 
    * For Volta (V100): `--generate-code arch=compute_70,code=sm_70`, 
    * For Ampere (A100): `--generate-code arch=compute_80,code=sm_80`
* `-Xcompiler`: pass flags to the host compiler. E.g., generate OpenMP-parallel host code: `-Xcompiler -fopenmp`. The `-Xcompiler` flag has to be invoked for each host-flag

TODO:

* profiler (nsight systems & compute, nvprof für k80)
