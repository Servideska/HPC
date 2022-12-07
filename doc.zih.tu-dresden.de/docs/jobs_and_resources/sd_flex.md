# HPE Superdome Flex

The HPE Superdome Flex is a large shared memory node. It is especially well suited for data
intensive application scenarios, for example to process extremely large data sets completely in main
memory or in very fast NVMe memory.

The hardware configuration is documented on
[this site](hardware_overview.md#large-smp-system-hpe-superdome-flex).

## Local Temporary on NVMe Storage

There are 370 TB of NVMe devices installed. For immediate access for all projects, a volume of 87 TB
of fast NVMe storage is available at `/nvme/1/<projectname>`. A quota of
100 GB per project on this NVMe storage is set.

With a more detailed proposal to [hpcsupport@zih.tu-dresden.de](mailto:hpcsupport@zih.tu-dresden.de)
on how this unique system (large shared memory + NVMe storage) can speed up their computations, a
project's quota can be increased or dedicated volumes of up to the full capacity can be set up.

## Hints for Usage

- Granularity should be a socket (28 cores)
- Can be used for OpenMP applications with large memory demands
- To use OpenMPI it is necessary to export the following environment
  variables, so that OpenMPI uses shared-memory instead of Infiniband
  for message transport:

  ```
  export OMPI_MCA_pml=ob1
  export OMPI_MCA_mtl=^mxm
  ```

- Use `I_MPI_FABRICS=shm` so that Intel MPI doesn't even consider
  using Infiniband devices itself, but only shared-memory instead
