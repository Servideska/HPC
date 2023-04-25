# HPC Resources

The architecture specifically tailored to data-intensive computing, Big Data
analytics, and artificial intelligence methods with extensive capabilities for performance monitoring provides ideal conditions to achieve the ambitious research goals of the users and the ZIH.

## Overview

From the users' pespective, there are seperate clusters, all of them with their subdomains:

| Name | Description | Year| DNS | 
| --- | --- | --- | --- |
| **Barnard** | CPU cluster |2023| *.barnard.hpc.tu-dresden.de |
| **Romeo** | CPU cluster |2020|*.romeo.hpc.tu-dresden.de |
| **Alpha Centauri** | GPU cluster |2021|*.alpha.hpc.tu-dresden.de |
| **Julia** | single SMP system |2021|julia.hpc.tu-dresden.de |
| **Power** | IBM Power/GPU system |2018|*.power.hpc.tu-dresden.de |


They run with their own Slurm batch system. Job submission is possible only from their login nodes.

All clusters have access to these shared parallel file systems:

| File system | Usable directory | Capacity | Purpose |
| --- | --- | --- | --- |
| `Lustre` | `/lustre/bulk` | 20 PB |
| `Lustre` | `/lustre/fast` | 2 PB | 
| `Weka` | `/weka` | 232 TB | 
| `Home` | `/home` | 40 TB |

