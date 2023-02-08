# SPEChpc2021

SPEChpc2021 is a benchmark suite developed by the Standard Performance Evaluation Corporation
(SPEC) for the evaluation of HPC systems. Documentation and released benchmark results can be found
on their [web page](https://www.spec.org/hpc2021/). TU Dresden is a member of the SPEC consortium,
therefore, the HPC benchmarks can be requested by anyone interested. Please contact
[Holger Brunst](https://tu-dresden.de/zih/die-einrichtung/struktur/holger-brunst) for access.
Furthermore, our system 'Taurus' (partition `haswell`) is the reference system denoting a score of 1.
The benchmark comes with different workload sizes - tiny, small, medium, large - and different
parallelization models including MPI only, MPI+OMP, MPI+OpenACC, MPI+target offloading that can be
used to evaluate parallel strategies for applications on a target HPC system.

## Installation

The target partition determines which of the parallelization models can be used, and vice versa.
For example, if you want to run a model including acceleration, you would have to use a partition
with GPUs.

Once the target partition is determined, follow the
[Installation Guide](https://www.spec.org/hpg/hpc2021/Docs/install-guide-linux.html),
it is straight-forward and easy to use.

???+ tip "Building for partition `ml`"

    The partition `ml` is a Power9 architecture. Thus, you need to provide the `-e ppc64le` switch
    when installing.

???+ tip "Building with NVHPC for partition `alpha`"

    To build the benchmark for the architecture of `alpha`, you don't need an interactive session
    on the target architecture. You can stay on the login nodes as long as you set the
    flag `-tp=zen` (as done in the configuration file for the OpenACC model, see below).

If you face errors during the installation process, check the [solved](#solved-issues) and
[unresolved issues](#unresolved-issues) sections. The problem might already be listed there.

## Configuration

In the following there are three configuration files provided for partitions `haswell`, `ml` and
`alpha`. Save them in the subfolder `config` of your SPEC installation folder. Feel free to modify
them according to your needs and make use of the following links for further details and
explanation.

- [Config Files Description](https://www.spec.org/hpc2021/docs/result-fields.html)
- [Flag Description](https://www.spec.org/hpc2021/results/res2021q4/hpc2021-20210917-00050.flags.html)
- [Result File Fields Description](https://www.spec.org/hpc2021/docs/result-fields.html)

To apply your configuration use `runhpc -c <configfile.cfg> [...]` for the benchmark run.

??? tip "SPEC Configuration files for partitions `haswell`, `ml` and `alpha`"

    === "gnu-taurus.cfg"
        Invocation command line:
        ```
        runhpc --config gnu-taurus --iterations=1 -T base --define model=mpi --ranks=24 tiny
        ```

        ```bash
        #######################################################################
        # Example configuration file for the GNU Compilers
        #
        # Defines: "model" => "mpi", "acc", "omp", "tgt", "tgtgpu"  default "mpi"
        #          "label" => ext base label, default "nv"
        #
        # MPI-only Command:
        # runhpc -c Example_gnu --reportable -T base --define model=mpi --ranks=40 small
        #
        # OpenACC Command:
        # runhpc -c Example_gnu --reportable -T base --define model=acc --ranks=4  small
        #
        # OpenMP Command:
        # runhpc -c Example_gnu --reportable -T base --define model=omp --ranks=1 --threads=40 small
        #
        # OpenMP Target Offload to Host Command:
        # runhpc -c Example_gnu --reportable -T base --define model=tgt --ranks=1 --threads=40 small
        #
        # OpenMP Target Offload to NVIDIA GPU Command:
        # runhpc -c Example_gnu --reportable -T base --define model=tgtnv --ranks=4  small
        #
        #######################################################################

        %ifndef %{label}         # IF label is not set use gnu
        %   define label gnu
        %endif

        %ifndef %{model}         # IF model is not set use mpi
        %   define model mpi
        %endif

        teeout = yes
        makeflags=-j 24

        # Tester Information
        license_num = 37A
        tester = Technische Universitaet Dresden
        test_sponsor = Technische Universitaet Dresden
        prepared_by = Holger Brunst

        #######################################################################
        # SUT Section
        #######################################################################
        include: sut-taurus.inc

        #[Software]
        sw_compiler000 = C/C++/Fortran: Version 8.2.0 of
        sw_compiler001 = GNU Compilers
        sw_mpi_library = OpenMPI Version 3.1.3
        sw_mpi_other = None
        sw_other = None

        #[General notes]
        notes_000 = MPI startup command:
        notes_005 =   slurm srun command was used to start MPI jobs.

        #######################################################################
        # End of SUT section
        #######################################################################

        #######################################################################
        # The header section of the config file.  Must appear
        # before any instances of "section markers" (see below)
        #
        # ext = how the binaries you generated will be identified
        # tune = specify "base" or "peak" or "all"
        %ifndef %{tudprof}
        label = %{label}_%{model}
        %else
        label = %{label}_%{model}_%{tudprof}
        %endif

        tune = base
        output_format = text
        use_submit_for_speed = 1

        # Compiler Settings
        default:
        CC = mpicc
        CXX = mpicxx
        FC = mpif90
        %if %{tudprof} eq 'scorep'
        CC = scorep --mpp=mpi --instrument-filter=${SPEC}/scorep.filter mpicc
        CXX = scorep --mpp=mpi --instrument-filter=${SPEC}/scorep.filter mpicxx
        FC = scorep --mpp=mpi --instrument-filter=${SPEC}/scorep.filter mpif90
        %endif


        # Compiler Version Flags
        CC_VERSION_OPTION = --version
        CXX_VERSION_OPTION = --version
        FC_VERSION_OPTION = --version

        # MPI options and binding environment, dependent upon Model being run
        # Adjust to match your system

        # OpenMP (CPU) Settings
        %if %{model} eq 'omp'
        preENV_OMP_PROC_BIND=true
        preENV_OMP_PLACES=cores
        %endif

        #OpenMP Targeting Host Settings
        %if %{model} eq 'tgt'
        preENV_OMP_PROC_BIND=true
        preENV_OMP_PLACES=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39
        %endif

        SRUN_OPTS =
        submit = timeout 2h srun ${SRUN_OPTS} -n $ranks -c $threads $command


        # Score-P performance profiling
        %if %{tudprof} eq 'scorep'

        ## only record calls to main and MPI functions (runtime filtering)
        ## runtime filtering was replaced by compile-time filtering (see above)
        # preENV_SCOREP_FILTERING_FILE=/home/brunst/ws-hpc2020/kit91/scorep.filter

        ## set buffer memory size for profile/trace
        preENV_SCOREP_TOTAL_MEMORY=64MB

        ## enable profile recording
        preENV_SCOREP_ENABLE_PROFILING=true

        ## set to 'true' to enable detailed trace file recording
        preENV_SCOREP_ENABLE_TRACING=false

        ## collect memory consumption per node
        preENV_SCOREP_METRIC_RUSAGE=ru_maxrss

        ## uncomment to record cycle counter for scheduling analysis
        preENV_SCOREP_METRIC_PAPI=PAPI_TOT_CYC

        %endif


        #######################################################################
        # Optimization

        # Note that SPEC baseline rules require that all uses of a given compiler
        # use the same flags in the same order. See the SPEChpc Run Rules
        # for more details
        #      http://www.spec.org/hpc2021/Docs/runrules.html
        #
        # OPTIMIZE = flags applicable to all compilers
        # FOPTIMIZE = flags appliable to the Fortran compiler
        # COPTIMIZE = flags appliable to the C compiler
        # CXXOPTIMIZE = flags appliable to the C++ compiler
        #
        # See your compiler manual for information on the flags available
        # for your compiler

        # Compiler flags applied to all models
        default=base=default:
        COPTIMIZE = -Ofast -march=native -lm        # use -mcpu=native for ARM
        CXXOPTIMIZE = -Ofast -march=native -std=c++14
        FOPTIMIZE = -Ofast -march=native -fno-stack-protector
        FPORTABILITY = -ffree-line-length-none

        %if %{model} eq 'mpi'
        pmodel=MPI
        %endif

        # OpenACC flags
        %if %{model} eq 'acc'
        pmodel=ACC
        OPTIMIZE += -fopenacc -foffload=-lm
        %endif

        # OpenMP (CPU) flags
        %if %{model} eq 'omp'
        pmodel=OMP
        OPTIMIZE += -fopenmp
        %endif

        # OpenMP Targeting host flags
        %if %{model} eq 'tgt'
        pmodel=TGT
        OPTIMIZE += -fopenmp
        %endif

        # OpenMP Targeting Nvidia GPU flags
        %if %{model} eq 'tgtnv'
        pmodel=TGT
        OPTIMIZE += -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda
        %endif

        # No peak flags set, so make peak use the same flags as base
        default=peak=default:
        basepeak=1
        ```

    === "nvhpc_ppc.cfg"
        Invocation command line:
        ```
        runhpc --config nvhpc_ppc --ranks=6 --nobuild --define pmodel=acc \
            --action run --reportable tiny
        ```

        ```bash
        #######################################################################
        # Example configuration file for the GNU Compilers
        #
        # Defines: "pmodel" => "mpi", "acc", "omp", "tgt", "tgtnv"  default "mpi"
        #          "label" => ext base label, default "nv"
        #
        # MPI-only Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=mpi --ranks=40 small
        #
        # OpenACC Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=acc --ranks=4  small
        #
        # OpenMP Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=omp --ranks=1 --threads=40 small
        #
        # OpenMP Target Offload to Host Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=tgt --ranks=1 --threads=40 small
        #
        # OpenMP Target Offload to NVIDIA GPU Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=tgtnv --ranks=4  small
        #
        #######################################################################

        %ifndef %{label}         # IF label is not set use default "nv"
        %   define label nv
        %endif

        %ifndef %{pmodel}         # IF pmodel is not set use default mpi
        %   define pmodel mpi
        %endif

        teeout = yes
        makeflags=-j 40

        # Tester Information
        license_num = 37A
        test_sponsor = TU Dresden
        tester = TU Dresden
        prepared_by = Noah Trumpik (Noah.Trumpik@tu-dresden.de)

        #######################################################################
        # SUT Section
        #######################################################################
        # General SUT info
        system_vendor = IBM
        system_name = Taurus: IBM Power System AC922 (IBM Power9, Tesla V100-SXM2-32GB)
        node_compute_sw_accel_driver = NVIDIA CUDA 440.64.00
        node_compute_hw_adapter_ib_slot_type = None
        node_compute_hw_adapter_ib_ports_used = 2
        node_compute_hw_adapter_ib_model = Mellanox ConnectX-5
        node_compute_hw_adapter_ib_interconnect = EDR InfiniBand
        node_compute_hw_adapter_ib_firmware = 16.27.6008
        node_compute_hw_adapter_ib_driver = mlx5_core
        node_compute_hw_adapter_ib_data_rate = 100 Gb/s (4X EDR)
        node_compute_hw_adapter_ib_count = 2
        interconnect_ib_syslbl = Mellanox InfiniBand
        interconnect_ib_purpose = MPI Traffic and GPFS access
        interconnect_ib_order = 1
        #interconnect_ib_hw_vendor = Mellanox
        #interconnect_ib_hw_topo = Non-blocking Fat-tree
        #interconnect_ib_hw_switch_ib_ports = 36
        #interconnect_ib_hw_switch_ib_data_rate = 100 Gb/s
        #interconnect_ib_hw_switch_ib_count = 1
        #interconnect_ib_hw_model = Mellanox Switch IB-2
        hw_avail = Nov-2018
        sw_avail = Nov-2021

        #[Node_Description: Hardware]
        node_compute_syslbl = IBM Power System AC922
        node_compute_order = 1
        node_compute_count = 30
        node_compute_purpose = compute
        node_compute_hw_vendor = IBM
        node_compute_hw_model = IBM Power System AC922
        node_compute_hw_cpu_name = IBM POWER9 2.2 (pvr 004e 1202)
        node_compute_hw_ncpuorder = 2 chips
        node_compute_hw_nchips = 2
        node_compute_hw_ncores = 44
        node_compute_hw_ncoresperchip = 22
        node_compute_hw_nthreadspercore = 4
        node_compute_hw_cpu_char = Up to 3.8 GHz
        node_compute_hw_cpu_mhz = 2300
        node_compute_hw_pcache = 32 KB I + 32 KB D on chip per core
        node_compute_hw_scache = 512 KB I+D on chip per core
        node_compute_hw_tcache000= 10240 KB I+D on chip per chip
        node_compute_hw_ocache = None
        node_compute_hw_memory = 256 GB (16 x 16 GB RDIMM-DDR4-2666)
        node_compute_hw_disk000= 2 x 1 TB (ATA Rev BE35)
        node_compute_hw_disk001 = NVMe SSD Controller 172Xa/172Xb
        node_compute_hw_other = None

        #[Node_Description: Accelerator]
        node_compute_hw_accel_model = Tesla V100-SXM2-32GB
        node_compute_hw_accel_count = 6
        node_compute_hw_accel_vendor= NVIDIA Corporation
        node_compute_hw_accel_type = GPU
        node_compute_hw_accel_connect = NVLINK
        node_compute_hw_accel_ecc = Yes
        node_compute_hw_accel_desc = See Notes

        #[Node_Description: Software]
        node_compute_sw_os000 = Red Hat Enterprise Linux
        node_compute_sw_os001 = 7.6
        node_compute_sw_localfile = xfs
        node_compute_sw_sharedfile = 4 PB Lustre parallel filesystem
        node_compute_sw_state = Multi-user
        node_compute_sw_other = None

        #[Fileserver]

        #[Interconnect]

        #[Software]
        sw_compiler000 = C/C++/Fortran: Version 21.5 of the
        sw_compiler001 = NVHPC toolkit
        sw_mpi_library = Open MPI Version 4.1.2
        sw_mpi_other = None
        system_class = Homogenous Cluster
        sw_other = None

        #[General notes]
        notes_000 = MPI startup command:
        notes_005 = srun command was used to launch job using 1 GPU/rank.
        notes_010 = Detailed information from nvaccelinfo
        notes_015 =
        notes_020 = CUDA Driver Version:           11000
        notes_025 = NVRM version:                  NVIDIA UNIX ppc64le Kernel Module
        notes_030 =                                440.64.00  Wed Feb 26 16:01:28 UTC 2020
        notes_035 = Device Number:                 0
        notes_040 = Device Name:                   Tesla V100-SXM2-32GB
        notes_045 = Device Revision Number:        7.0
        notes_050 = Global Memory Size:            33822867456
        notes_055 = Number of Multiprocessors:     80
        notes_060 = Concurrent Copy and Execution: Yes
        notes_065 = Total Constant Memory:         65536
        notes_070 = Total Shared Memory per Block: 49152
        notes_075 = Registers per Block:           65536
        notes_080 = Warp Size:                     32
        notes_085 = Maximum Threads per Block:     1024
        notes_090 = Maximum Block Dimensions:      1024, 1024, 64
        notes_095 = Maximum Grid Dimensions:       2147483647 x 65535 x 65535
        notes_100 = Maximum Memory Pitch:          2147483647B
        notes_105 = Texture Alignment:             512B
        notes_110 = Max Clock Rate:                1530 MHz
        notes_115 = Execution Timeout:             No
        notes_120 = Integrated Device:             No
        notes_125 = Can Map Host Memory:           Yes
        notes_130 = Compute Mode:                  default
        notes_135 = Concurrent Kernels:            Yes
        notes_140 = ECC Enabled:                   Yes
        notes_145 = Memory Clock Rate:             877 MHz
        notes_150 = Memory Bus Width:              4096 bits
        notes_155 = L2 Cache Size:                 6291456 bytes
        notes_160 = Max Threads Per SMP:           2048
        notes_165 = Async Engines:                 4
        notes_170 = Unified Addressing:            Yes
        notes_175 = Managed Memory:                Yes
        notes_180 = Concurrent Managed Memory:     Yes
        notes_185 = Preemption Supported:          Yes
        notes_190 = Cooperative Launch:            Yes
        notes_195 = Multi-Device:                  Yes
        notes_200 = Default Target:                cc70
        notes_205 =

        ######################################################################
        # End of SUT section
        ######################################################################

        ######################################################################
        # The header section of the config file.  Must appear
        # before any instances of "section markers" (see below)
        #
        # ext = how the binaries you generated will be identified
        # tune = specify "base" or "peak" or "all"
        label = %{label}_%{pmodel}
        tune = base
        output_format = text
        use_submit_for_speed = 1

        # Compiler Settings
        default:
        CC = mpicc
        CXX = mpic++
        FC = mpif90
        # Compiler Version Flags
        CC_VERSION_OPTION = --version
        CXX_VERSION_OPTION = --version
        FC_VERSION_OPTION = --version

        # MPI options and binding environment, dependent upon Model being run
        # Adjust to match your system

        # OpenMP (CPU) Settings
        %if %{pmodel} eq 'omp'
        preENV_OMP_PLACES=cores
        #preENV_OMP_PROC_BIND=true
        #preENV_OMP_PLACES=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        %endif

        #OpenMP Targeting Host Settings
        %if %{pmodel} eq 'tgt'
        #preENV_OMP_PROC_BIND=true
        preENV_MPIR_CVAR_GPU_EAGER_DEVICE_MEM=0
        preEnv_MPICH_GPU_SUPPORT_ENABLED=1
        preEnv_MPICH_SMP_SINGLE_COPY_MODE=CMA
        preEnv_MPICH_GPU_EAGER_DEVICE_MEM=0
        #preENV_OMP_PLACES=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        %endif

        %ifdef %{ucx}
        # if using OpenMPI with UCX support, these settings are needed with use of CUDA Aware MPI
        # without these flags, LBM is known to hang when using OpenACC and OpenMP Target to GPUs
        preENV_UCX_MEMTYPE_CACHE=n
        preENV_UCX_TLS=self,shm,cuda_copy
        %endif

        # 1 GPU per rs, 7 cores per RS, 1 MPI task per RS, 6 RS per host
        SRUN_OPTS =
        submit = srun ${SRUN_OPTS} $command

        #######################################################################
        # Optimization

        # Note that SPEC baseline rules require that all uses of a given compiler
        # use the same flags in the same order. See the SPEChpc Run Rules
        # for more details
        #      http://www.spec.org/hpc2021/Docs/runrules.html
        #
        # OPTIMIZE = flags applicable to all compilers
        # FOPTIMIZE = flags appliable to the Fortran compiler
        # COPTIMIZE = flags appliable to the C compiler
        # CXXOPTIMIZE = flags appliable to the C++ compiler
        #
        # See your compiler manual for information on the flags available
        # for your compiler

        # Compiler flags applied to all models
        default=base=default:
        OPTIMIZE = -O3
        COPTIMIZE = -lm       # use -mcpu=native for ARM
        CXXOPTIMIZE = -std=c++11
        #FOPTIMIZE = -ffree-line-length-none -fno-stack-protector
        FOPTIMIZE =

        %if %{model} eq 'mpi'
        pmodel=MPI
        %endif

        # OpenACC flags
        %if %{pmodel} eq 'acc'
        # Use with PGI compiler only
        # https://docs.nvidia.com/hpc-sdk/archive/21.5/
        pmodel=ACC
        OPTIMIZE += -acc -ta=tesla #-Minfo=accel
        %endif

        # Note that NVHPC is in the process of adding OpenMP array
        # reduction support so this option may be removed in future
        # reduction not supported on taurusml due to old driver
        513.soma_t:
        PORTABILITY+=-DSPEC_NO_VAR_ARRAY_REDUCE
        513.soma_s:
        PORTABILITY+=-DSPEC_NO_VAR_ARRAY_REDUCE

        # OpenMP (CPU) flags
        %if %{pmodel} eq 'omp'
        pmodel=OMP
        #OPTIMIZE += -qsmp=omp
        OPTIMIZE += -fopenmp
        %endif

        # OpenMP Targeting host flags
        %if %{pmodel} eq 'tgt'
        pmodel=TGT
        # PGI
        OPTIMIZE += -mp -acc=multicore
        # Intel
        # OPTIMIZE += -qsmp=omp -qoffload
        # GCC (doesn't recognize its own flags)
        #OPTIMIZE += -fopenmp -mgomp -msoft-stack -muniform-simt
        #FOPTIMIZE += -homp
        %endif

        # OpenMP Targeting host flags
        %if %{pmodel} eq 'tgtnv'
        pmodel=TGT
        # PGI
        OPTIMIZE += -mp=gpu -acc
        #FOPTIMIZE += -homp
        %endif

        # No peak flags set, so make peak use the same flags as base
        default=peak=default:
        basepeak=1

        #######################################################################
        # Portability
        #######################################################################

        # The following section was added automatically, and contains settings that
        # did not appear in the original configuration file, but were added to the
        # raw file after the run.
        default:
        flagsurl000 = http://www.spec.org/hpc2021/flags/nv2021_flags.xml
        interconnect_ib_hw_switch_ib_model000 = Mellanox IB EDR Switch IB-2
        ```

    === "nvhpc_alpha.cfg"
        Invocation command line:
        ```
        runhpc --config nvhpc_alpha.cfg --ranks=8 --rebuild --define pmodel=acc \
            --tune=base --iterations=1 --noreportable small
        ```

        ```bash
        ######################################################################
        # Example configuration file for the GNU Compilers
        #
        # Defines: "pmodel" => "mpi", "acc", "omp", "tgt", "tgtgpu"  default "mpi"
        #          "label" => ext base label, default "nv"
        #
        # MPI-only Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=mpi --ranks=40 small
        #
        # OpenACC Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=acc --ranks=4  small
        #
        # OpenMP Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=omp --ranks=1 --threads=40 small
        #
        # OpenMP Target Offload to Host Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=tgt --ranks=1 --threads=40 small
        #
        # OpenMP Target Offload to NVIDIA GPU Command:
        # runhpc -c Example_gnu --reportable -T base --define pmodel=tgtnv --ranks=4  small
        #
        ######################################################################

        %ifndef %{label}         # IF label is not set use gnu
        %   define label nv
        %endif

        %ifndef %{pmodel}         # IF pmodel is not set use mpi
        %   define pmodel mpi
        %endif

        teeout = yes
        makeflags=-j 40

        # Tester Information
        license_num = 37A
        test_sponsor = TU Dresden
        tester = TU Dresden
        prepared_by = Noah Trumpik (Noah.Trumpik@tu-dresden.de)


        ######################################################################
        # SUT Section
        ######################################################################

        # General SUT info
        system_vendor = AMD
        system_name = Alpha Centauri: AMD EPYC 7352 (AMD x86_64, NVIDIA A100-SXM4-40GB)
        hw_avail = Jan-2019
        sw_avail = Aug-2022

        #[Node_Description: Hardware]
        node_compute_syslbl = AMD Rome
        node_compute_order = 1
        node_compute_count = 34
        node_compute_purpose = compute
        node_compute_hw_vendor = AMD
        node_compute_hw_model = AMD K17 (Zen2)
        node_compute_hw_cpu_name = AMD EPYC 7352
        node_compute_hw_ncpuorder = 2 chips
        node_compute_hw_nchips = 2
        node_compute_hw_ncores = 96
        node_compute_hw_ncoresperchip = 48
        node_compute_hw_nthreadspercore = 2
        node_compute_hw_cpu_char = Up to 2.3 GHz
        node_compute_hw_cpu_mhz = 2100
        node_compute_hw_pcache = 32 KB I + 32 KB D on chip per core
        node_compute_hw_scache = 512 KB I+D on chip per core
        node_compute_hw_tcache000= 16384 KB I+D on chip per chip
        node_compute_hw_ocache = None
        node_compute_hw_memory = 1 TB
        node_compute_hw_disk000= 3.5 TB
        node_compute_hw_disk001 = NVMe SSD Controller SM981/PM981/PM983
        node_compute_hw_adapter_ib_model = Mellanox ConnectX-6
        node_compute_hw_adapter_ib_interconnect = EDR InfiniBand
        node_compute_hw_adapter_ib_firmware = 20.28.2006
        node_compute_hw_adapter_ib_driver = mlx5_core
        node_compute_hw_adapter_ib_data_rate = 200 Gb/s
        node_compute_hw_adapter_ib_count = 2
        node_compute_hw_adapter_ib_slot_type = PCIe
        node_compute_hw_adapter_ib_ports_used = 2
        node_compute_hw_other = None

        #[Node_Description: Accelerator]
        node_compute_hw_accel_model = Tesla A100-SXM4-40GB
        node_compute_hw_accel_count = 8
        node_compute_hw_accel_vendor = NVIDIA Corporation
        node_compute_sw_accel_driver = NVIDIA CUDA 470.57.02
        node_compute_hw_accel_type = GPU
        node_compute_hw_accel_connect = ASPEED Technology, Inc. (rev 04)
        node_compute_hw_accel_ecc = Yes
        node_compute_hw_accel_desc = none

        #[Node_Description: Software]
        node_compute_sw_os000 = CentOS Linux
        node_compute_sw_os001 = 7
        node_compute_sw_localfile = xfs
        node_compute_sw_sharedfile000 = 4 PB Lustre parallel filesystem
        node_compute_sw_sharedfile001 = over 4X EDR InfiniBand
        node_compute_sw_state = Multi-user
        node_compute_sw_other = None

        #[Fileserver]

        #[Interconnect]
        interconnect_ib_syslbl = Mellanox InfiniBand
        interconnect_ib_purpose = MPI Traffic and GPFS access
        interconnect_ib_order = 1
        interconnect_ib_hw_vendor = Mellanox
        interconnect_ib_hw_topo = Non-blocking Fat-tree
        #interconnect_ib_hw_switch_ib_count = 2
        #interconnect_ib_hw_switch_ib_ports = 2
        #interconnect_ib_hw_switch_ib_data_rate = 100 Gb/s
        #interconnect_ib_hw_switch_ib_model = Mellanox Switch IB-2

        #[Software]
        sw_compiler000 = C/C++/Fortran: Version 21.7 of the
        sw_compiler001 = NVHPC toolkit
        sw_mpi_library = Open MPI Version 4.1.1
        sw_mpi_other = None
        system_class = Homogenous Cluster
        sw_other = CUDA Driver Version: 11.4.2

        ######################################################################
        # End of SUT section
        ######################################################################


        ######################################################################
        # The header section of the config file.  Must appear
        # before any instances of "section markers" (see below)
        #
        # ext = how the binaries you generated will be identified
        # tune = specify "base" or "peak" or "all"
        label = %{label}_%{pmodel}
        tune = base
        output_format = text
        use_submit_for_speed = 1

        # Compiler Settings
        default:
        CC = mpicc
        CXX = mpicxx
        FC = mpif90
        # Compiler Version Flags
        CC_VERSION_OPTION = --version
        CXX_VERSION_OPTION = --version
        FC_VERSION_OPTION = --version

        # MPI options and binding environment, dependent upon Model being run
        # Adjust to match your system

        # OpenMP (CPU) Settings
        %if %{pmodel} eq 'omp'
        preENV_OMP_PLACES=cores
        #preENV_OMP_PROC_BIND=true
        #preENV_OMP_PLACES=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        %endif

        #OpenMP Targeting Host Settings
        %if %{pmodel} eq 'tgt'
        #preENV_OMP_PROC_BIND=true
        preENV_MPIR_CVAR_GPU_EAGER_DEVICE_MEM=0
        preEnv_MPICH_GPU_SUPPORT_ENABLED=1
        preEnv_MPICH_SMP_SINGLE_COPY_MODE=CMA
        preEnv_MPICH_GPU_EAGER_DEVICE_MEM=0
        #preENV_OMP_PLACES=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        %endif

        %ifdef %{ucx}
        # if using OpenMPI with UCX support, these settings are needed with use of CUDA Aware MPI
        # without these flags, LBM is known to hang when using OpenACC and OpenMP Target to GPUs
        preENV_UCX_MEMTYPE_CACHE=n
        preENV_UCX_TLS=self,shm,cuda_copy
        %endif

        # submission command and resource options
        submit = srun $command

        ######################################################################
        # Optimization

        # Note that SPEC baseline rules require that all uses of a given compiler
        # use the same flags in the same order. See the SPEChpc Run Rules
        # for more details
        #      http://www.spec.org/hpc2021/Docs/runrules.html
        #
        # OPTIMIZE = flags applicable to all compilers
        # FOPTIMIZE = flags appliable to the Fortran compiler
        # COPTIMIZE = flags appliable to the C compiler
        # CXXOPTIMIZE = flags appliable to the C++ compiler
        #
        # See your compiler manual for information on the flags available
        # for your compiler

        # Compiler flags applied to all models
        default=base=default:
        #OPTIMIZE = -w -Mfprelaxed -Mnouniform -Mstack_arrays -fast
        OPTIMIZE = -w -O3 -Mfprelaxed -Mnouniform -Mstack_arrays
        COPTIMIZE = -lm       # use -mcpu=native for ARM
        CXXOPTIMIZE = -std=c++11
        CXXPORTABILITY = --c++17

        #ARM
        %if %{armOn} eq 'arm'
            COPTIMIZE += -mcpu=native
            #OPTIMIZE += -mcpu=a64fx
        %endif

        # SVE
        %if %{sveOn} eq 'sve'
        COPTIMIZE += -march=armv8-a+sve
        %endif

        %if %{model} eq 'mpi'
        pmodel=MPI
        %endif

        # OpenACC flags
        %if %{pmodel} eq 'acc'
        pmodel=ACC
        # Use with PGI compiler only
        # https://docs.nvidia.com/hpc-sdk/archive/21.7/
        #OPTIMIZE += -acc=gpu
        OPTIMIZE += -acc -ta=tesla -tp=zen #-Minfo=accel #-DSPEC_ACCEL_AWARE_MPI->hangs it forever
        %endif

        # OpenMP (CPU) flags
        %if %{pmodel} eq 'omp'
        pmodel=OMP
        OPTIMIZE += -fopenmp
        #FOPTIMIZE +=
        %endif

        # OpenMP Targeting host flags
        %if %{pmodel} eq 'tgt'
        pmodel=TGT
        OPTIMIZE += -mp -acc=multicore
        #FOPTIMIZE += -homp
        %endif

        # OpenMP Targeting host flags
        %if %{pmodel} eq 'tgtnv'
        pmodel=TGT
        OPTIMIZE += -mp=gpu -acc
        #FOPTIMIZE += -homp

        # Note that NVHPC is in the process of adding OpenMP array
        # reduction support so this option may be removed in future
        513.soma_t:
        PORTABILITY+=-DSPEC_NO_VAR_ARRAY_REDUCE
        %endif

        # No peak flags set, so make peak use the same flags as base
        default=peak=default:
        basepeak=1

        ######################################################################
        # Portability
        ######################################################################

        # The following section was added automatically, and contains settings that
        # did not appear in the original configuration file, but were added to the
        # raw file after the run.
        default:
        flagsurl000 = http://www.spec.org/hpc2021/flags/nv2021_flags.xml
        interconnect_ib_hw_switch_ib_model000 = Mellanox IB EDR Switch IB-2
        ```

## Execution

The SPEChpc 2021 benchmark suite is executed with the command `runhpc`. To make it available in the
search path, execute `source shrc` in your installation folder, first.
You can now use the following batch scripts to submit a job, carrying out the complete benchmark
suite or parts of it as specified. The workload is also set here (tiny, small, medium or large).

- Replace `<p_number_crunch>` (line 2) with your project name
- Replace `<firstname.lastname>@tu-dresden.de` (line 15) with your valid email address to receive
a notification on job start
- Replace `ws=</scratch/ws/spec/installation>` (line 27) with your SPEC installation path

### Submit SPEChpc 2021 with a Job File

=== "run-taurus-mpi-tiny-p24.sh"
    ```bash linenums="1"
    #!/bin/bash
    #SBATCH --account=<p_number_crunch>
    #SBATCH --time=16:00:00
    #SBATCH --exclusive
    #SBATCH --nodes=1
    #SBATCH --ntasks=24
    #SBATCH --ntasks-per-node=24
    #SBATCH --cpus-per-task=1
    #SBATCH --mem-per-cpu=2541
    #SBATCH --output=batch-out/spec-%j.out
    #SBATCH --error=batch-out/spec-%j.err
    #SBATCH --partition=haswell64
    #SBATCH --constraint=DA
    #SBATCH --mail-type=BEGIN
    #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

    module purge
    module load Score-P/6.0-gompi-2019a

    ulimit -s unlimited
    ulimit -n 4096

    source shrc

    BENCH_SMALL_LIST="505.lbm_t 510.picongpu_t 511.palm_t 513.soma_t 518.tealeaf_t 519.clvleaf_t 521.miniswp_t 528.pot3d_t 532.sph_exa_t 534.hpgmgfv_t 535.weather_t"

    # Use tealeaf scorep run to check the benchmark performance
    BENCH="518.tealeaf_t"

    # Score-P parameters are set in config/gnu-taurus.cfg

    #ACTION="--action=build --rebuild"
    #ACTION="--rebuild"
    #runhpc $ACTION -I -c gnu-taurus --iterations=1 --size=ref --ranks=24 --define model=mpi --define tudprof=scorep
    runhpc $ACTION -I -c gnu-taurus --iterations=1 -T base --define model=mpi --ranks=24 --define tudprof=scorep $BENCH

    # To the actual reportable runs with all benchmarks
    BENCH="tiny"

    #ACTION="--action=build --rebuild"
    #ACTION="--rebuild"
    #ACTION="--action=report"
    runhpc $ACTION -c gnu-taurus --reportable -T base --flagsurl=$SPEC/config/flags/gcc_flags.xml --define model=mpi --ranks=24 $BENCH

    specperl bin/tools/port_progress result/*.log
    ```

=== "submit_spec_ml_openacc.sh"
    ```bash linenums="1"
    #!/bin/bash
    #SBATCH --account=<p_number_crunch>   # account CPU time to Project
    #SBATCH --ntasks=6                    # number of tasks (MPI processes)
    #SBATCH --cpus-per-task=7             # use 7 threads per task
    #SBATCH --gpus-per-task=1             # use 1 gpu thread per task
    #SBATCH --gres=gpu:6                  # generic consumable resources allocation per node: 6 GPUs
    #SBATCH --partition=ml
    #SBATCH --exclusive
    #SBATCH --mem-per-cpu=5772M
    #SBATCH --time=01:00:00               # run for 1 hour
    #SBATCH --job-name=spec_oacc
    #SBATCH --export=ALL
    #SBATCH --hint=nomultithread
    #SBATCH --mail-type=BEGIN
    #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

    # ml: 44 cores + 6 GPUs per node

    module switch modenv/ml
    module load NVHPC
    module load OpenMPI/4.0.5-NVHPC-21.2-CUDA-11.2.1

    export OMPI_CC=nvc
    export OMPI_CXX=nvc++
    export OMPI_FC=nvfortran

    ws=</scratch/ws/spec/installation>
    cd $ws
    . shrc

    suite='tiny'
    cfg=nvhpc_ppc.cfg

    # test run
    #runhpc -c $cfg -ranks $SLURM_NTASKS --define pmodel=acc --size=test --noreportable --tune=base --iterations=1 $suite

    # reference workload
    runhpc -c $cfg -ranks $SLURM_NTASKS --define pmodel=acc --rebuild --noreportable --tune=base --iterations=1 $suite
    ```

=== "submit_spec_alpha_openacc.sh"
    ```bash linenums="1"
    #!/bin/bash
    #SBATCH --account=<p_number_crunch>   # account CPU time to Project
    #SBATCH --partition=alpha
    #SBATCH --nodes=1                     # number of compute nodes
    #SBATCH --ntasks-per-node=8           # number of tasks (MPI processes)
    #SBATCH --cpus-per-task=6             # use 6 threads per task
    #SBATCH --gpus-per-task=1             # use 1 gpu thread per task
    #SBATCH --gres=gpu:8                  # generic consumable resources allocation per node: 8 GPUs
    #SBATCH --mem-per-cpu=20624M          # RAM per CPU
    #SBATCH --time=00:45:00               # run for hh:mm:ss hrs
    #SBATCH --job-name=spec_acc
    #SBATCH --export=ALL
    #SBATCH --hint=nomultithread
    #SBATCH --mail-type=BEGIN
    #SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

    # alpha: 48(96) cores(ht) + 8 GPUs per node

    module switch modenv/hiera
    module load NVHPC
    module load OpenMPI

    # all LBM produce "error" initializing openFabrics device:
    # - can be ignored


    ws=</scratch/ws/spec/installation>
    cd $ws
    source shrc

    suite='tiny'
    #suite='small ^lbm_s ^soma_s ^tealeaf_s ^clvleaf_s'
    cfg=nvhpc_alpha.cfg

    # test size
    #runhpc -c $cfg -ranks $SLURM_NTASKS --define pmodel=acc --size=test --noreportable --tune=base --iterations=1 lbm_s

    # reference workload
    # --rebuiuld
    runhpc -c $cfg -ranks $SLURM_NTASKS --define pmodel=acc --noreportable --tune=base --iterations=1 $suite
    ```

## Solved Issues

### Fortran Compilation Error

!!! failure "PGF90-F-0004-Corrupt or Old Module file"

!!! note "Explanation"

    If this error arises during runtime, it means that the benchmark binaries and the MPI module
    do not fit together. This happens when you have built the benchmarks written in Fortran with a
    different compiler than which was used to build the MPI module that whas loaded during the run.

!!! success "Solution"

    - Use the correct MPI module
        - The MPI module in use must be compiled with the same compiler that was used to build the
        benchmark binaries. Check with `module avail` and choose a different module
    - Rebuild the binaries
        - Rebuild the binaries using the same compiler as for the compilation of the MPI module of
        choice
    - Build your own MPI module
        - Download and build a private MPI module using the same compiler as for building the
        benchmark binaries

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

    ORTE_ERROR_LOG: The system limit on number of children a process can have was reached. This can
    be resolved by either asking the system administrator for that node to increase the system
    limit, or by rearranging your processes to place fewer of them on that node.

!!! note "Explanation"

    There are too many processes spawned, probably due to a wrong job allocation and/or invocation.

!!! success "Solution"

    In your batch script, check the invocation command line. It must not say `srun runhpc [...]`
    there, but only `runhpc [...]`. The submit command in the [configuration](#configuration) file
    already contains `srun`. When `srun` is in both places, too many parallel processes are spawned.

### Error with openFabrics Device

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

    - Expand your job from single node to multiple nodes
    - Reduce the workload (e.g. form small to tiny)
    - Make sure to use `srun` instead of `mpirun` as the submit command in your
    [configuration](#configuration) file.

## Unresolved Issues

### CUDA Reduction Operation Error

!!! failure "There was a problem while initializing support for the CUDA reduction operations."

!!! note "Explanation"

    For OpenACC, NVHPC was in the process of adding OpenMP array reduction support which is needed
    for the `pot3d` benchmark. An Nvidia driver version of 450.80.00 or higher is required. Since
    the driver version on partiton `ml` is 440.64.00, it is not supported and not possible to run
    the `pot3d` benchmark here.

!!! note "Workaround"

    As for the partition `ml`, you can only wait until the OS update to centOS 8 is carried out,
    as no driver update will be done beforehand. As a workaround, you can do one of the following:

    - Exclude the `pot3d` benchmark
    - Switch the partition (e.g. to `alpha`)

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

    - Use `srun` instead
    - Use `mpirun` along with a rank-binding perl script (like
    `mpirun -np <ranks> perl <bind.pl> <command>`) as seen on the bottom of the configurations
    [here](https://www.spec.org/hpc2021/results/res2021q4/hpc2021-20210908-00012.cfg) and
    [here](https://www.spec.org/hpc2021/results/res2021q4/hpc2021-20210917-00056.cfg)

### Benchmark Hangs Forever

!!! warning "The benchmark runs forever and produces a timeout."

!!! note "Explanation"

    The reason for this is not known, however, it is caused by the flag `-DSPEC_ACCEL_AWARE_MPI`

!!! note "Workaround"

    Remove the flag `-DSPEC_ACCEL_AWARE_MPI` from the compiler options in your configuration file

### Other Issues

For any further issues you can consult SPEC's
[FAQ page](https://www.spec.org/hpc2021/Docs/faq.html), search through their
[known issues](https://www.spec.org/hpc2021/Docs/known-problems.html) or contact their
[support](https://www.spec.org/hpc2021/Docs/techsupport.html).
