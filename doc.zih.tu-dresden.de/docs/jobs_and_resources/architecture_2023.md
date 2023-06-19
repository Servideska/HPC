# Architectural Re-Design 2023

With the replacement of the Taurus system by the cluster `Barnard` in 2023,
the rest of the installed hardware had to be re-connected, both with
Infiniband and with Ethernet.

![Architecture overview 2023](../jobs_and_resources/misc/architecture_2023.png)
{: align=center}

## Compute Systems

For the users, all compute clusters now act as seperate entities. They have their own
login nodes of the same hardware and their own Slurm batch systems. It is now no longer up
to the batch system to decide if a job runs on AMD or Intel hardware. The users now chose
the hardware by the choice of the correct login node.

The login nodes can be used for smaller interactive jobs on the clusters. There are
restrictions in place, though, wrt. usable resources and time per user. For larger
computations, please use interactive jobs.

## Storage Systems

### Permananent Filesystems

We now have `/home`, `/projects` and `/software` in a Lustre filesystem. Snapshots
and tape backup are configured. For convenience, we will make the old home available
read-only as `/home_old` on the datamover nodes for the data migration period.

`/warm_archive` is mounted on the data movers, only.

### Work Filesystems

With new players with new software in the file system market it getting more and more
complicated to identify the best suited file system for temporary data. In many cases,
only tests can provide the right answer, for a short time.

For an easier grasp on the major categories (size, speed), the work filesystems now come
with the names of animals:

* `/data/horse` - 20 PB - high bandwidth (Lustre)
* `/data/octopus` - 0.5 PB - for interactive usage (Lustre)
* `/data/weasel` - 1 PB - für high IOPS (WEKA)  - coming soon

### Difference Between "Work" And "Permananent"

A large number of changing files is a challange for any backup system. To protect
our snapshots and backup from work data,
`/projects` cannot be used for temporary data on the compute nodes - it is mounted read-only.

Please use our data movers to transfer worthy data to permanent
storages.
