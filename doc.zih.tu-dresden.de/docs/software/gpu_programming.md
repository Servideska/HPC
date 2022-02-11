# GPU Programming

## Available GPUs

The full hardware specifications of the compute nodes may be found in the [HPC Resources](https://doc.zih.tu-dresden.de/jobs_and_resources/hardware_overview/#hpc-resources) page.
Each node uses a different [module environment](https://doc.zih.tu-dresden.de/software/modules/#module-environments): 
* [NVIDIA Tesla K80 GPUs nodes](https://doc.zih.tu-dresden.de/jobs_and_resources/hardware_overview/#island-2-phase-2-intel-haswell-cpus-nvidia-k80-gpus) (`gpu2` partition) use the default `scs5` module environment (`module switch modenv/scs5`). 
* [NVIDIA Tesla V100 nodes](https://doc.zih.tu-dresden.de/jobs_and_resources/hardware_overview/#ibm-power9-nodes-for-machine-learning) (`ml` partition) use the `ml` module environment (`modenv switch modenv/ml`)
* [NVIDIA A100 nodes](https://doc.zih.tu-dresden.de/jobs_and_resources/hardware_overview/#amd-rome-cpus-nvidia-a100) (`alpha` partition) use the `hiera` module environment (`module switch modenv/hiera`)

## Directive Based GPU Programming

Directives are special compiler commands in your C/C++ or Fortran source code. They tell the
compiler how to parallelize and offload work to a GPU. This section explains how to use this
technique.

### OpenACC

[OpenACC](https://www.openacc.org) is a directive based GPU programming model. It currently
only supports NVIDIA GPUs as a target.

Please use the following information as a start on OpenACC:

#### Introduction

OpenACC can be used with the PGI and NVIDIA HPC compilers. The NVIDIA HPC compiler, as part of the [NVIDIA HPC SDK](https://docs.nvidia.com/hpc-sdk/index.html), supercedes the PGI compiler. 

Various versions of the PGI compiler are available on the [NVIDIA Tesla K80 GPUs nodes](https://doc.zih.tu-dresden.de/jobs_and_resources/hardware_overview/#island-2-phase-2-intel-haswell-cpus-nvidia-k80-gpus) (`gpu2` partition). 

The `nvc` compiler (NOT the `nvcc` compiler, which is used for CUDA) is available for the NVIDIA Tesla V100 and Nvidia A100 nodes.

#### Using OpenACC with PGI compilers

* Load the latest version via `module load PGI` or search for available versions with `module search PGI`;
* For compilation, please add the compiler flag `-acc` to enable OpenACC interpreting by the
  compiler;
* `-Minfo` tells you what the compiler is actually doing to your code;
* If you only want to use the created binary at ZIH resources, please also add `-ta=nvidia:keple`;
* You may find further information on the PGI compiler in the [user guide](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-user-guide/index.htm) and in the [reference guide](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-ref-guide/index.htm), which includes descriptions of available [command line options](https://docs.nvidia.com/hpc-sdk/pgi-compilers/20.4/x86/pgi-ref-guide/index.htm#cmdln-options-ref)

#### Using OpenACC with NVIDIA HPC compilers

* Switch into the correct module environment for your selected compute nodes (see above)
* Load the `NVHPC` module for the correct module environment. Either load the default (`module load NVHPC`) or search for a specific version.
* Use the correct compiler for your code: `nvc` for C, `nvc++` for C++ and `nvfortran` for Fortran
* Use the `-acc` and `-Minfo` flag as with the PGI compiler
* To create optimized code for either the V100 or A100, use `-gpu=cc70` or `-gpu=cc80`, respectively
* Further information on this compiler is provided in the [user guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/index.html) and the [reference guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/index.html), which includes descriptions of available [command line options](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/index.html#cmdln-options-ref) 
* Information specific the use of OpenACC with the NVIDIA HPC compiler is compiled in a [guide](https://docs.nvidia.com/hpc-sdk/compilers/openacc-gs/index.html)

### HMPP

HMPP is available from the CAPS compilers.

## Native GPU Programming

### CUDA

Native [CUDA](http://www.nvidia.com/cuda) programs can sometimes offer a better performance. Please
use the following slides as an introduction:

* Introduction to CUDA;
* Advanced Tuning for NVIDIA Kepler GPUs.

In order to compile an application with CUDA use the `nvcc` compiler command.
