# Environment Modules

Usage of software on HPC systems is managed by a **modules system**.

!!! note "Module"

    A module is a user interface that provides utilities for the dynamic modification of a user's
    environment, e.g. prepending paths to:

    * `PATH`
    * `LD_LIBRARY_PATH`
    * `MANPATH`
    * and more

    to help you to access compilers, loader, libraries and utilities.

    By using modules, you can smoothly switch between different versions of
    installed software packages and libraries.

## Module Commands

Using modules is quite straightforward and the following table lists the basic commands.

| Command                       | Description                                                      |
|:------------------------------|:-----------------------------------------------------------------|
| `module help`                 | Show all module options                                          |
| `module list`                 | List active modules in the user environment                      |
| `module purge`                | Remove modules from the user environment                         |
| `module avail [modname]`      | List all available modules                                       |
| `module spider [modname]`     | Search for modules across all environments                       |
| `module load <modname>`       | Load module `modname` in the user environment                    |
| `module unload <modname>`     | Remove module `modname` from the user environment                |
| `module switch <mod1> <mod2>` | Replace module `mod1` with module `mod2`                         |

Module files are ordered by their topic on ZIH systems. By default, with `module avail` you will
see all topics and their available module files. If you just wish to see the installed versions of a
certain module, you can use `module avail softwarename` and it will display the available versions of
`softwarename` only.

### Examples

???+ example "Finding available software"

    This examples illustrates the usage of the command `module avail` to search for available Matlab
    installations.

    ```console
    marie@compute$ module avail matlab

    ------------------------------ /sw/modules/scs5/math ------------------------------
       MATLAB/2017a    MATLAB/2018b    MATLAB/2020a
       MATLAB/2018a    MATLAB/2019b    MATLAB/2021a (D)

      Wo:
       D:  Standard Modul.

    Verwenden Sie "module spider" um alle verfügbaren Module anzuzeigen.
    Verwenden Sie "module keyword key1 key2 ...", um alle verfügbaren Module
    anzuzeigen, die mindestens eines der Schlüsselworte enthält.
    ```

???+ example "Loading and removing modules"

    A particular module or several modules are loaded into your environment using the `module load`
    command. The counter part to remove a module or several modules is `module unload`.

    ```console
    marie@compute$ module load Python/3.8.6
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies loaded.
    ```

???+ example "Removing all modules"

    To remove all loaded modules from your environment with one keystroke, invoke

    ```console
    marie@compute$ module purge
    Die folgenden Module wurden nicht entladen:
      (Benutzen Sie "module --force purge" um alle Module zu entladen):

      1) modenv/scs5
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies unloaded.
    ```

### Front-End ml

There is a front end for the module command, which helps you to type less. It is `ml`.
 Any module command can be given after `ml`:

| ml Command        | module Command                            |
|:------------------|:------------------------------------------|
| `ml`              | `module list`                             |
| `ml foo bar`      | `module load foo bar`                     |
| `ml -foo -bar baz`| `module unload foo bar; module load baz`  |
| `ml purge`        | `module purge`                            |
| `ml show foo`     | `module show foo`                         |

???+ example "Usage of front-end ml"

    ```console
    marie@compute$ ml +Python/3.8.6
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies loaded.
    marie@compute$ ml

    Derzeit geladene Module:
      1) modenv/scs5                  (S)   5) bzip2/1.0.8-GCCcore-10.2.0       9) SQLite/3.33.0-GCCcore-10.2.0  13) Python/3.8.6-GCCcore-10.2.0
      2) GCCcore/10.2.0                     6) ncurses/6.2-GCCcore-10.2.0      10) XZ/5.2.5-GCCcore-10.2.0
      3) zlib/1.2.11-GCCcore-10.2.0         7) libreadline/8.0-GCCcore-10.2.0  11) GMP/6.2.0-GCCcore-10.2.0
      4) binutils/2.35-GCCcore-10.2.0       8) Tcl/8.6.10-GCCcore-10.2.0       12) libffi/3.3-GCCcore-10.2.0

      Wo:
       S:  Das Modul ist angeheftet. Verwenden Sie "--force", um das Modul zu entladen.

    marie@compute$ ml -Python/3.8.6 +ANSYS/2020R2
    Module Python/3.8.6-GCCcore-10.2.0 and 11 dependencies unloaded.
    Module ANSYS/2020R2 loaded.
    ```

## Module Environments

On ZIH systems, there exist different **module environments**, each containing a set of software modules.
They are activated via the meta module `modenv` which has different versions, one of which is loaded
by default. You can switch between them by simply loading the desired modenv-version, e.g.

```console
marie@compute$ module load modenv/ml
```

### modenv/scs5 (default)

* SCS5 software
* usually optimized for Intel processors (partitions `haswell`, `broadwell`, `gpu2`, `julia`)

### modenv/ml

* data analytics software (for use on the partition `ml`)
* necessary to run most software on the partition `ml`
(The instruction set [Power ISA](https://en.wikipedia.org/wiki/Power_ISA#Power_ISA_v.3.0)
is different from the usual x86 instruction set.
Thus the 'machine code' of other modenvs breaks).

### modenv/hiera

* uses a hierarchical module load scheme
* optimized software for AMD processors (partitions `romeo` and `alpha`)

### modenv/classic

* deprecated, old software. Is not being curated.
* may break due to library inconsistencies with the operating system.
* please don't use software from that modenv

### Searching for Software

The command `module spider <modname>` allows searching for a specific software across all modenv
environments. It will also display information on how to load a particular module when giving a precise
module (with version) as the parameter.

??? example "Spider command"

    ```console
    marie@login$ module spider p7zip

    ----------------------------------------------------------------------------------------------------------------------------------------------------------
      p7zip:
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
        Beschreibung:
          p7zip is a quick port of 7z.exe and 7za.exe (command line version of 7zip) for Unix. 7-Zip is a file archiver with highest compression ratio.

         Versionen:
            p7zip/9.38.1
            p7zip/17.03-GCCcore-10.2.0
            p7zip/17.03

    ----------------------------------------------------------------------------------------------------------------------------------------------------------
      Um detaillierte Informationen über ein bestimmtes "p7zip"-Modul zu erhalten (auch wie das Modul zu laden ist), verwenden sie den vollständigen Namen des Moduls.
      Zum Beispiel:
        $ module spider p7zip/17.03
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    ```

In some cases a desired software is available as an extension of a module.

??? example "Extension module"
    ```console  hl_lines="9"
    marie@login$ module spider tensorboard

    --------------------------------------------------------------------------------------------------------------------------------
    tensorboard:
    --------------------------------------------------------------------------------------------------------------------------------
    Versions:
        tensorboard/2.4.1 (E)

    Names marked by a trailing (E) are extensions provided by another module.
    [...]
    ```

    You retrieve further information using the `spider` command.

    ```console
    marie@login$  module spider tensorboard/2.4.1

    --------------------------------------------------------------------------------------------------------------------------------
    tensorboard: tensorboard/2.4.1 (E)
    --------------------------------------------------------------------------------------------------------------------------------
    This extension is provided by the following modules. To access the extension you must load one of the following modules. Note that any module names in parentheses show the module location in the software hierarchy.

        TensorFlow/2.4.1 (modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5)
        TensorFlow/2.4.1-fosscuda-2019b-Python-3.7.4 (modenv/ml)
        TensorFlow/2.4.1-foss-2020b (modenv/scs5)

    Names marked by a trailing (E) are extensions provided by another module.
    ```

    Finaly, you can load the dependencies and `tensorboard/2.4.1` and check the version.

    ```console
    marie@login$ module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5

    The following have been reloaded with a version change:
        1) modenv/scs5 => modenv/hiera

    Module GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5 and 15 dependencies loaded.
    marie@login$ module load TensorFlow/2.4.1
    Module TensorFlow/2.4.1 and 34 dependencies loaded.
    marie@login$ tensorboard --version
    2.4.1
    ```

## Toolchains

A program or library may break in various ways
(e.g. not starting, crashing or producing wrong results)
when it is used with a software of a different version than it expects.  
So each module specifies the exact other modules it depends on.
They get loaded automatically when the dependent module is loaded.

Loading a single module is easy as there can't be any conflicts between dependencies.
However when loading multiple modules they can require different versions of the same software.
This conflict is currently handled in that loading the same software with a different version
automatically unloads the earlier loaded module.
As the dependents of that module are **not** automatically unloaded this means they now have a
wrong dependency (version) which can be a problem (see above).

To avoid this there are (versioned) toolchains and for each toolchain there is (usually) at most
one version of each software.
A "toolchain" is a set of modules used to build the software for other modules.
The most common one is the `foss`-toolchain comprising of `GCC`, `OpenMPI`, `OpenBLAS` & `FFTW`.

!!! info

    Modules are named like `<Softwarename>/<Version>-<Toolchain>` so `Python/3.6.6-foss-2019a`
    uses the `foss-2019a` toolchain.

This toolchain can be broken down into a sub-toolchain called `gompi` comprising of only
`GCC` & `OpenMPI`, or further to `GCC` (the compiler and linker)
and even further to `GCCcore` which is only the runtime libraries required to run programs built
with the GCC standard library.

!!! hint

    As toolchains are regular modules you can display their parts via `module show foss/2019a`.

This way the toolchains form a hierarchy and adding more modules makes them "higher" than another.

Examples:

| Toolchain | Components |
| --------- | ---------- |
| `foss`    | `GCC` `OpenMPI` `OpenBLAS` `FFTW` |
| `gompi`   | `GCC` `OpenMPI` |
| `GCC`     | `GCCcore` `binutils` |
| `GCCcore` | none |
| `intel`   | `intel-compilers` `impi` `imkl` |
| `iimpi`   | `intel-compilers` `impi` |
| `intel-compilers` | `GCCcore` `binutils` |

As you can see `GCC` and `intel-compilers` are on the same level, as are `gompi` and `iimpi`
although they are one level higher than the former.

You can load and use modules from a lower toolchain with modules from
one of its parent toolchains.  
For example `Python/3.6.6-foss-2019a` can be used with `Boost/1.70.0-gompi-2019a`.

But you cannot combine toolchains or toolchain versions.
So `QuantumESPRESSO/6.5-intel-2019a` and `OpenFOAM/8-foss-2020a`
are both incompatible with `Python/3.6.6-foss-2019a`.  
However `LLVM/7.0.1-GCCcore-8.2.0` can be used with either
`QuantumESPRESSO/6.5-intel-2019a` or `Python/3.6.6-foss-2019a`
because `GCCcore-8.2.0` is a sub-toolchain of `intel-2019a` and `foss-2019a`.

For [modenv/hiera](#modenvhiera) it is much easier to avoid loading incompatible
modules as modules from other toolchains cannot be directly loaded
and don't show up in `module av`.
So the concept if this hierarchical toolchains is already built into this module environment.
In the other module environments it is up to you to make sure the modules you load are compatible.

So watch the output when you load another module as a message will be shown when loading a module
causes other modules to be loaded in a different version:

??? example "Module reload"

    ```console
    marie@login$ ml OpenFOAM/8-foss-2020a
    Module OpenFOAM/8-foss-2020a and 72 dependencies loaded.

    marie@login$ ml Biopython/1.78-foss-2020b
    The following have been reloaded with a version change:
      1) FFTW/3.3.8-gompi-2020a => FFTW/3.3.8-gompi-2020b                                   15) binutils/2.34-GCCcore-9.3.0 => binutils/2.35-GCCcore-10.2.0
      2) GCC/9.3.0 => GCC/10.2.0                                                            16) bzip2/1.0.8-GCCcore-9.3.0 => bzip2/1.0.8-GCCcore-10.2.0
      3) GCCcore/9.3.0 => GCCcore/10.2.0                                                    17) foss/2020a => foss/2020b
      [...]
    ```

!!! info

    The higher toolchains have a year and letter as their version corresponding to their release.
    So `2019a` and `2020b` refer to the first half of 2019 and the 2nd half of 2020 respectively.

## Per-Architecture Builds

Since we have a heterogeneous cluster, we do individual builds of some of the software for each
architecture present. This ensures that, no matter what partition the software runs on, a build
optimized for the host architecture is used automatically.
For that purpose we have created symbolic links on the compute nodes,
at the system path `/sw/installed`.

However, not every module will be available for each node type or partition. Especially when
introducing new hardware to the cluster, we do not want to rebuild all of the older module versions
and in some cases cannot fall-back to a more generic build either. That's why we provide the script:
`ml_arch_avail` that displays the availability of modules for the different node architectures.

### Example Invocation of ml_arch_avail

```console
marie@compute$ ml_arch_avail TensorFlow/2.4.1
TensorFlow/2.4.1: haswell, rome
TensorFlow/2.4.1: haswell, rome
```

The command shows all modules that match on `TensorFlow/2.4.1`, and their respective availability.
Note that this will not work for meta-modules that do not have an installation directory
(like some tool chain modules).

## Advanced Usage

For writing your own module files please have a look at the
[Guide for writing project and private module files](private_modules.md).

## Troubleshooting

### When I log in, the wrong modules are loaded by default

Reset your currently loaded modules with `module purge`
(or `module purge --force` if you also want to unload your basic `modenv` module).
Then run `module save` to overwrite the
list of modules you load by default when logging in.

### I can't load module TensorFlow

Check the dependencies by e.g. calling `module spider TensorFlow/2.4.1`
it will list a number of modules that need to be loaded
before the TensorFlow module can be loaded.

??? example "Loading the dependencies"

    ```console
    marie@compute$ module load TensorFlow/2.4.1
    Lmod hat den folgenden Fehler erkannt:  Diese Module existieren, aber
    können nicht wie gewünscht geladen werden: "TensorFlow/2.4.1"
       Versuchen Sie: "module spider TensorFlow/2.4.1" um anzuzeigen, wie die Module
    geladen werden.


    marie@compute$ module spider TensorFlow/2.4.1

    ----------------------------------------------------------------------------------
      TensorFlow: TensorFlow/2.4.1
    ----------------------------------------------------------------------------------
        Beschreibung:
          An open-source software library for Machine Intelligence


        Sie müssen alle Module in einer der nachfolgenden Zeilen laden bevor Sie das Modul "TensorFlow/2.4.1" laden können.

          modenv/hiera  GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5
         This extension is provided by the following modules. To access the extension you must load one of the following modules. Note that any module names in parentheses show the module location in the software hierarchy.


           TensorFlow/2.4.1 (modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5)


        This module provides the following extensions:

           absl-py/0.10.0 (E), astunparse/1.6.3 (E), cachetools/4.2.0 (E), dill/0.3.3 (E), gast/0.3.3 (E), google-auth-oauthlib/0.4.2 (E), google-auth/1.24.0 (E), google-pasta/0.2.0 (E), grpcio/1.32.0 (E), gviz-api/1.9.0 (E), h5py/2.10.0 (E), Keras-Preprocessing/1.1.2 (E), Markdown/3.3.3 (E), oauthlib/3.1.0 (E), opt-einsum/3.3.0 (E), portpicker/1.3.1 (E), pyasn1-modules/0.2.8 (E), requests-oauthlib/1.3.0 (E), rsa/4.7 (E), tblib/1.7.0 (E), tensorboard-plugin-profile/2.4.0 (E), tensorboard-plugin-wit/1.8.0 (E), tensorboard/2.4.1 (E), tensorflow-estimator/2.4.0 (E), TensorFlow/2.4.1 (E), termcolor/1.1.0 (E), Werkzeug/1.0.1 (E), wrapt/1.12.1 (E)

        Help:
          Description
          ===========
          An open-source software library for Machine Intelligence


          More information
          ================
           - Homepage: https://www.tensorflow.org/


          Included extensions
          ===================
          absl-py-0.10.0, astunparse-1.6.3, cachetools-4.2.0, dill-0.3.3, gast-0.3.3,
          google-auth-1.24.0, google-auth-oauthlib-0.4.2, google-pasta-0.2.0,
          grpcio-1.32.0, gviz-api-1.9.0, h5py-2.10.0, Keras-Preprocessing-1.1.2,
          Markdown-3.3.3, oauthlib-3.1.0, opt-einsum-3.3.0, portpicker-1.3.1,
          pyasn1-modules-0.2.8, requests-oauthlib-1.3.0, rsa-4.7, tblib-1.7.0,
          tensorboard-2.4.1, tensorboard-plugin-profile-2.4.0, tensorboard-plugin-
          wit-1.8.0, TensorFlow-2.4.1, tensorflow-estimator-2.4.0, termcolor-1.1.0,
          Werkzeug-1.0.1, wrapt-1.12.1


    Names marked by a trailing (E) are extensions provided by another module.



    marie@compute$ ml +modenv/hiera  +GCC/10.2.0  +CUDA/11.1.1 +OpenMPI/4.0.5 +TensorFlow/2.4.1

    Die folgenden Module wurden in einer anderen Version erneut geladen:
      1) GCC/7.3.0-2.30 => GCC/10.2.0        3) binutils/2.30-GCCcore-7.3.0 => binutils/2.35
      2) GCCcore/7.3.0 => GCCcore/10.2.0     4) modenv/scs5 => modenv/hiera

    Module GCCcore/7.3.0, binutils/2.30-GCCcore-7.3.0, GCC/7.3.0-2.30, GCC/7.3.0-2.30 and 3 dependencies unloaded.
    Module GCCcore/7.3.0, GCC/7.3.0-2.30, GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5, TensorFlow/2.4.1 and 50 dependencies loaded.
    marie@compute$ module list

    Derzeit geladene Module:
      1) modenv/hiera               (S)  28) Tcl/8.6.10
      2) GCCcore/10.2.0                  29) SQLite/3.33.0
      3) zlib/1.2.11                     30) GMP/6.2.0
      4) binutils/2.35                   31) libffi/3.3
      5) GCC/10.2.0                      32) Python/3.8.6
      6) CUDAcore/11.1.1                 33) pybind11/2.6.0
      7) CUDA/11.1.1                     34) SciPy-bundle/2020.11
      8) numactl/2.0.13                  35) Szip/2.1.1
      9) XZ/5.2.5                        36) HDF5/1.10.7
     10) libxml2/2.9.10                  37) cURL/7.72.0
     11) libpciaccess/0.16               38) double-conversion/3.1.5
     12) hwloc/2.2.0                     39) flatbuffers/1.12.0
     13) libevent/2.1.12                 40) giflib/5.2.1
     14) Check/0.15.2                    41) ICU/67.1
     15) GDRCopy/2.1-CUDA-11.1.1         42) JsonCpp/1.9.4
     16) UCX/1.9.0-CUDA-11.1.1           43) NASM/2.15.05
     17) libfabric/1.11.0                44) libjpeg-turbo/2.0.5
     18) PMIx/3.1.5                      45) LMDB/0.9.24
     19) OpenMPI/4.0.5                   46) nsync/1.24.0
     20) OpenBLAS/0.3.12                 47) PCRE/8.44
     21) FFTW/3.3.8                      48) protobuf/3.14.0
     22) ScaLAPACK/2.1.0                 49) protobuf-python/3.14.0
     23) cuDNN/8.0.4.30-CUDA-11.1.1      50) flatbuffers-python/1.12
     24) NCCL/2.8.3-CUDA-11.1.1          51) typing-extensions/3.7.4.3
     25) bzip2/1.0.8                     52) libpng/1.6.37
     26) ncurses/6.2                     53) snappy/1.1.8
     27) libreadline/8.0                 54) TensorFlow/2.4.1

      Wo:
       S:  Das Modul ist angeheftet. Verwenden Sie "--force", um das Modul zu entladen.
    ```
