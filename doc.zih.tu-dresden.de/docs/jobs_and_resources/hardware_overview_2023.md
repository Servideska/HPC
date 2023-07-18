# HPC Resources

The architecture specifically tailored to data-intensive computing, Big Data
analytics, and artificial intelligence methods with extensive capabilities
for performance monitoring provides ideal conditions to achieve the ambitious
research goals of the users and the ZIH.

## Overview

From the users' pespective, there are seperate clusters, all of them with their subdomains:

| Name | Description | Year| DNS |
| --- | --- | --- | --- |
| **Barnard** | CPU cluster |2023| n[1001-1630].barnard.hpc.tu-dresden.de |
| **Romeo** | CPU cluster |2020|i[8001-8190].romeo.hpc.tu-dresden.de |
| **Alpha Centauri** | GPU cluster |2021|i[8001-8037].alpha.hpc.tu-dresden.de |
| **Julia** | single SMP system |2021|smp8.julia.hpc.tu-dresden.de |
| **Power** | IBM Power/GPU system |2018|ml[1-29].power9.hpc.tu-dresden.de |

They run with their own Slurm batch system. Job submission is possible only from
their respective login nodes.

All clusters have access to these shared parallel filesystems:

| Filesystem | Usable directory | Type | Capacity | Purpose |
| --- | --- | --- | --- | --- |
| Home | `/home` | Lustre | quota per user: 20 GB | permanant user data |
| Project | `/projects` | Lustre | quota per project | permanant project data |
| Scratch for large data / streaming | `/data/horse` | Lustre | 20 PB | h
| Scratch for random access | `/data/rabbit` | Lustre | 2 PB |

These mount points are planned (September 2023):

| Scratch for random access | `/data/weasel` | WEKA | 232 TB |
| Scratch for random access | `/data/squirrel` | BeeGFS | xxx TB |

## Barnard - Intel Sapphire Rapids CPUs

- 630 diskless nodes, each with
    - 2 x Intel(R) Xeon(R) CPU E5-2680 v3 (52 cores) @ 2.50 GHz, Multithreading enabled
    - 512 GB RAM
- Hostnames: `n1[001-630].barnard.hpc.tu-dresden.de`
- Login nodes: `login[1-4].barnard.hpc.tu-dresden.de`

## AMD Rome CPUs + NVIDIA A100

- 34 nodes, each with
    - 8 x NVIDIA A100-SXM4 Tensor Core-GPUs
    - 2 x AMD EPYC CPU 7352 (24 cores) @ 2.3 GHz, Multithreading available
    - 1 TB RAM
    - 3.5 TB local memory on NVMe device at `/tmp`
- Hostnames: `taurusi[8001-8034]`  -> `i[8001-8037].alpha.hpc.tu-dresden.de`
- Login nodes: `login[1-2].alpha.hpc.tu-dresden.de`
- Further information on the usage is documented on the site [Alpha Centauri Nodes](alpha_centauri.md)

## Island 7 - AMD Rome CPUs

- 192 nodes, each with
    - 2 x AMD EPYC CPU 7702 (64 cores) @ 2.0 GHz, Multithreading available
    - 512 GB RAM
    - 200 GB local memory on SSD at `/tmp`
- Hostnames: `taurusi[7001-7192]` -> `i[7001-7190].romeo.hpc.tu-dresden.de`
- Login nodes: `login[1-2].romeo.hpc.tu-dresden.de`
- Further information on the usage is documented on the site [AMD Rome Nodes](rome_nodes.md)

## Large SMP System HPE Superdome Flex

- 1 node, with
    - 32 x Intel(R) Xeon(R) Platinum 8276M CPU @ 2.20 GHz (28 cores)
    - 47 TB RAM
- Configured as one single node
- 48 TB RAM (usable: 47 TB - one TB is used for cache coherence protocols)
- 370 TB of fast NVME storage available at `/nvme/<projectname>`
- Hostname: `taurussmp8` -> `smp8.julia.hpc.tu-dresden.de`
- Further information on the usage is documented on the site [HPE Superdome Flex](sd_flex.md)

## IBM Power9 Nodes for Machine Learning

For machine learning, we have IBM AC922 nodes installed with this configuration:

- 32 nodes, each with
    - 2 x IBM Power9 CPU (2.80 GHz, 3.10 GHz boost, 22 cores)
    - 256 GB RAM DDR4 2666 MHz
    - 6 x NVIDIA VOLTA V100 with 32 GB HBM2
    - NVLINK bandwidth 150 GB/s between GPUs and host
- Hostnames: `taurusml[1-32]` -> `ml[1-29].power9.hpc.tu-dresden.de`
- Login nodes: `login[1-2].power9.hpc.tu-dresden.de``
