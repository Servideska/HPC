# Overview

According to [What software do I need](todo), first of all, check the [Software module list](todo).
Keep in mind that there are two different environments: **scs5** (for the x86 architecture) and
**ml** (environment for the Machine Learning partition based on the Power9 architecture).

Work with the software on Taurus could be started only after allocating the resources by [batch
systems](todo). By default, you are in the login nodes. They are not specified for the work, only
for the login. Allocating resources will be done by batch system [SLURM](todo).

There are a lot of different possibilities to work with software on Taurus:

## Modules

Usage of software on HPC systems is managed by a **modules system**. Thus, it is crucial to
be familiar with the [modules concept and commands](../modules/modules).  Modules are a way to use
frameworks, compilers, loader, libraries, and utilities. A module is a user interface that provides
utilities for the dynamic modification of a user's environment without manual modifications. You
could use them for `srun`, batch jobs (`sbatch`) and the Jupyterhub.

## JupyterNotebook

The Jupyter Notebook is an open-source web application that allows creating documents containing
live code, equations, visualizations, and narrative text. There is [jupyterhub](todo) on Taurus,
where you can simply run your Jupyter notebook on HPC nodes using modules, preloaded or custom
virtual environments. Moreover, you can run a [manually created remote jupyter server](todo) for
more specific cases.

## Containers

Some tasks require using containers. It can be done on Taurus by [Singularity](todo). Details could
be found in the [following chapter](todo).

Useful links: [Libraries](todo), [Deep Learning](todo), [Jupyter Hub](todo), [Big Data
Frameworks](todo), [R](todo), [Applications for various fields of science](todo)