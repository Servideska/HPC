# Known MPI-Usage Issues

This pages holds known issues observed with MPI and concrete MPI implementations.

## Mpirun on partition `alpha`and `ml`

Using `mpirun` on partitions `alpha` and `ml` leads to wrong resource distribution when more than
one node is involved. This yields a strange distribution like e.g. `SLURM_NTASKS_PER_NODE=15,1`
even though `--tasks-per-node=8` was specified. Unless you really know what you're doing (e.g.
use rank pinning via perl script), avoid using mpirun.

Another issue arises when using the Intel toolchain: mpirun calls a different MPI and caused a
8-9x slowdown in the PALM app in comparison to using srun or the GCC-compiled version of the app
(which uses the correct MPI).

## R Parallel Library on Multiple Nodes

Using the R parallel library on MPI clusters has shown problems when using more than a few compute
nodes. The error messages indicate that there are buggy interactions of R/Rmpi/OpenMPI and UCX.
Disabling UCX has solved these problems in our experiments.

We invoked the R script successfully with the following command:

```console
mpirun -mca btl_openib_allow_ib true --mca pml ^ucx --mca osc ^ucx -np 1 Rscript
--vanilla the-script.R
```

where the arguments `-mca btl_openib_allow_ib true --mca pml ^ucx --mca osc ^ucx` disable usage of
UCX.

## MPI Function `MPI_Win_allocate`

The function `MPI_Win_allocate` is a one-sided MPI call that allocates memory and returns a window
object for RDMA operations (ref. [man page](https://www.open-mpi.org/doc/v3.0/man3/MPI_Win_allocate.3.php)).

> Using MPI_Win_allocate rather than separate MPI_Alloc_mem + MPI_Win_create may allow the MPI
> implementation to optimize the memory allocation. (Using advanced MPI)

It was observed for at least for the `OpenMPI/4.0.5` module that using `MPI_Win_Allocate` instead of
`MPI_Alloc_mem` in conjunction with `MPI_Win_create` leads to segmentation faults in the calling
application . To be precise, the segfaults occurred at partition `romeo` when about 200 GB per node
where allocated. In contrast, the segmentation faults vanished when the implementation was
refactored to call the `MPI_Alloc_mem + MPI_Win_create` functions.
