# Known MPI-Usage Issues

This pages holds known issues observed with MPI and concrete MPI implementations.

## R Parallel Library on Multiple Nodes

Using the R parallel library on MPI clusters has shown problems when using more than a few compute
nodes. The error messages indicate that there are buggy interactions of R/Rmpi/OpenMPI and UCX.
Disabling UCX has solved these problems in our experiments.

We invoked the R script successfully with the following command:

```
console mpirun -mca btl_openib_allow_ib true --mca pml ^ucx --mca osc ^ucx -np 1 Rscript
--vanilla the-script.R
```

where the arguments `-mca btl_openib_allow_ib true --mca pml ^ucx --mca osc ^ucx` disable usage of
UCX.

## MPI Function `MPI_Win_allocate`

The function `MPI_Win_allocate` is a one-sided MPI call that allocates memory and returns a window
object for RDMA operations (ref. [man page](https://www.open-mpi.org/doc/v3.0/man3/MPI_Win_allocate.3.php)).

> Using MPI_Win_allocate rather than separate MPI_Alloc_mem + MPI_Win_create may allow the MPI implementation to optimize the memory allocation.
> (Using advanced MPI)

It was observed for at least for the `OpenMPI/4.0.5` module that using `MPI_Alloc_mem` in
conjunction with `MPI_Win_create` instead of `MPI_Win_Allocate` leads to segmentation faults in the
calling application. To be precise, the segfaults occurred at partition `romeo` when about 200 GB
per node where allocated. In contrast, the segmentation faults vanished when the implementation was
refactored to call the `MPI_Win_allocate` function.
