# MPI Error Detection

MPI as the de-facto standard for parallel applications of the message passing paradigm offers
more than one hundred different API calls with complex restrictions. As a result, developing
applications with this interface is error prone and often time consuming. Some usage errors of MPI
may only manifest on some platforms or some application runs, which further complicates the
detection of these errors. Thus, special debugging tools for MPI applications exist that
automatically check whether an application conforms to the MPI standard and whether its MPI calls
are safe. At ZIH, we maintain and support MUST for this task, though different types of these tools
exist (see last section).

## MUST

[MUST](https://www.i12.rwth-aachen.de/go/id/nrbe) checks if your application conforms to the MPI
standard and will issue warnings if there are errors or non-portable constructs. You can apply MUST
without modifying your source code, though we suggest to add the debugging flag "-g" during
compilation.

See also [MUST Introduction Slides](misc/parallel_debugging_must.pdf).

### Setup and Modules

You need to load a module file in order to use MUST. Each MUST installation uses a specific
combination of a compiler and an MPI library, make sure to use a combination that fits your needs.
Right now we provide two combinations, contact us if you need further
combinations. You can query for the available modules with:

```console
marie@login$ module avail must
   MUST/1.6.0-rc3-intel-2018a    MUST/1.7.2-intel-2020a (D)
```

You can load a MUST module as follows:

```console
marie@login$ module load MUST
Module MUST/1.7.2-intel-2020a and 16 dependencies loaded.
```

Besides loading a MUST module, no further changes are needed during compilation and linking.

### Running your Application with MUST

In order to launch your application with MUST you need to replace the `srun` command with
`mustrun --must:mpiexec srun --must:np -n`:

```console
marie@login$ mustrun --must:mpiexec srun --must:np -n -n <number of MPI processes> ./<your binary>
```

Besides replacing the `srun` command you need to be aware that **MUST always allocates an extra
process**, i.e. if you issue a `mustrun --must:mpiexec srun --must:np -n -n 4 ./<your binary>` then
MUST will start **5 processes** instead. This is usually not critical, however in interactive/batch
jobs **make sure
to allocate an extra CPU for this task**.

Suppose your application is called `fancy-program` and is normally run with 4 processes.
The MUST workflow should then be

```console
marie@login$ module load MUST

# Compile your application with the debugging flag "-g" on the correct architecture, e.g.:
marie@login$ srun -n 1 -p <partition> mpicc -g -o fancy-program fancy-program.c

# Allocate interactive session with 1 extra process for MUST
marie@login$ salloc -n 5 -p <partition>

marie@login$ mustrun --must:mpiexec srun --must:np -n --must:stacktrace backward -n 4 ./fancy-program
[MUST] MUST configuration ... centralized checks with fall-back application crash handling (very slow)
[MUST] Weaver ... success
[MUST] Code generation ... success
[MUST] Build file generation ... success
[MUST] Configuring intermediate build ... success
[MUST] Building intermediate sources ... success
[MUST] Installing intermediate modules ... success
[MUST] Generating P^nMPI configuration ... success
[MUST] Search for linked P^nMPI ... not found ... using LD_PRELOAD to load P^nMPI ... success
[MUST] Executing application:
{...}
[MUST] Execution finished, inspect "/home/marie/MUST_Output.html"!
```

With the additional flag `--must:stacktrace backward` you can produce an additional stacktrace
with line number of the error location which allows to pinpoint the error location in your code.
This might slow down code execution slightly.

Finally, MUST assumes that your application may crash at any time. To still gather correctness
results under this assumption is extremely expensive in terms of performance overheads. Thus, if
your application does not crash, you should add `--must:nocrash` to the `mustrun` command to make
MUST aware of this knowledge. Overhead is drastically reduced with this switch.
Further details on alternative launch modes are described in the MUST documentation.

### Result Files

After running your application with MUST you will have its output in the working directory of your
application. The output is named `MUST_Output.html`. Open this files in a browser to analyze the
results. The HTML file is color coded:

-   Entries in green represent notes and useful information
-   Entries in yellow represent warnings
-   Entries in red represent errors

## Further MPI Correctness Tools

Besides MUST, there exist further MPI correctness tools, these are:

-   Marmot (predecessor of MUST)
-   MPI checking library of the Intel Trace Collector
-   ISP (From Utah)
-   Umpire (predecessor of MUST)

ISP provides a more thorough deadlock detection as it investigates alternative execution paths,
however its overhead is drastically higher as a result. Contact our support if you have a specific
use cases that needs one of these tools.
