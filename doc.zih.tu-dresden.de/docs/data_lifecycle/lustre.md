# Lustre

## Large Files in /scratch

The data containers in [Lustre](https://www.lustre.org) are called **object storage targets (OST)**.
The capacity of one OST is about 21 TB. All files are striped over a certain number of these OSTs.
For small and medium files, the default number is 2. As soon as a file grows above ~1 TB it makes
sense to spread it over a higher number of OSTs, e.g. 16. Once the filesystem is used >75%, the
average space per OST is only 5 GB. So, it is essential to split your larger files so that the
chunks can be saved!

Lets assume you have a directory where you tar your results, e.g. `/scratch/marie/tar`. Now, simply
set the stripe count to a higher number in this directory with:

```console
marie@login$ lfs setstripe -c 20  /scratch/ws/marie-stripe20/tar
```

!!! note

    This does not affect existing files. But all files that **will be created** in this
    directory will be distributed over 20 OSTs.

## Good Practices

!!! hint "Avoid accessing metadata information"

    Querying metadata information such as file and directory attributes is a resource intensive task
    in Lustre filesystems. When these tasks are performed frequently or over large directories, it
    can degrade the filesystem's performance and thus affect all users.

In this sense, you should minimize the usage of system calls querying or modifying file
and directory attributes, e.g. `stat()`, `statx()`, `open()`, `openat()` etc.

Please, also avoid commands basing on the above mentioned system calls such as `ls -l` and
`ls --color`. Instead, you should invoke `ls` or `ls -l <filename` to reduce metadata operations.
This also holds for commands walking the filesystems recursively performing massive metadata
operations such as `ls -R`, `find`, `locate`, `du` and `df`.

Lustre offers a number of commands that are suited to its architecture.

| Good | Bad |
|:-----|:----|
| `lfs df` | `df` |
| `lfs find` | `find` |
| `ls -l <filename>` | `ls -l` |
| `ls` | `ls --color` |

In case commands such as `du` are needed, for example to identify large
directories, these commands should be applied to as little data as
possible. You should not just query the main directory in general, you
should try to work in the sub directories first. The deeper in the
structure, the better.

### Searching the Directory Tree

The command `lfs find` searches the directory tree for files matching the specified parameters.

```console
marie@login$ lfs find <root directory> [options]
```

If no option is provided, `lfs find` will efficiently list all files in a given directory and its
subdirectories, without fetching any file attributes.

Useful options:

* `--atime n` file was last accessed n*24 hours ago
* `--ctime n` file was last changed n*24 hours ago
* `--mtime n` file was last modified n*24 hours ago
* `--maxdepth n` limits find to descend at most n levels of directory tree
* `--print0|-0` print full file name to standard output if it matches the specified parameters,
  followed by a NUL character.
* `--name arg` filename matches the given filename (supporting regular expression and wildcards)
* `--type [b|c|d|f|p|l|s]` file has type: **b**lock, **c**haracter, **d**irectory, **f**ile,
  **p**ipe, sym**l**ink, or **s**ocket.

??? example "Example: List files older than 30 days"

    The follwing command will find and list all files older than 30 days in the workspace
    `/scratch/ws/0/marie-number_crunch`:

    ```console
    marie@login lfs find /scratch/ws/0/marie-number_crunch --mtime +30 --type f
    /scratch/ws/0/marie-number_crunch/jobfile.sh
    /scratch/ws/0/marie-number_crunch/0001.dat
    /scratch/ws/0/marie-number_crunch/load_profile.sh
    /scratch/ws/0/marie-number_crunch/mes0001
    /scratch/ws/0/marie-number_crunch/d3dump01.0002
    /scratch/ws/0/marie-number_crunch/mes0032
    /scratch/ws/0/marie-number_crunch/dump01.0003
    /scratch/ws/0/marie-number_crunch/slurm-1234567.log
    ```

## Useful Commands for Lustre

These commands work for Lustre filesystems `/scratch` and `/ssd`. In order to hold this
documentation as general as possible we will use `<filesystem>` as a placeholder for the Lustre
filesystems. Just replace it when invoking the commands with the Lustre filesystem of interest.

Lustre's `lfs` client utility provides several options for monitoring and configuring your Lustre
environment.

`lfs` can be used in interactive and in command line mode. To enter the interactive mode, you just
call `lfs` and enter your commands. Since, both modes provide identical options, we use the command
line mode within this documentation.

!!! hint "Filesystem vs. Path"

    If you provide a path to the lfs commands instead of a filesystem, the lfs option is applied to
    the filesystem this path is in. Thus, the passed information refers to the whole filesystem,
    not the path.

You can retrieve a complete list of available options:

```console
marie@login lfs --list-commands
setstripe           getstripe           setdirstripe        getdirstripe
mkdir               rm_entry            pool_list           find
check               osts                mdts                df
[...]
marie@login lfs help setstripe

```

To get more information on a specific option, enter `help` followed by the option of interest:

```console
marie@login lfs help setstripe
setstripe: To create a file with specified striping/composite layout, or
create/replace the default layout on an existing directory:
usage: setstripe [--component-end|-E <comp_end>]
[...]
```

More comprehensive documentation can be found in the man pages of lfs (`man lfs`).

### Listing Disk Space Usage

The command `lfs df` lists the filesystems disk space usage:

```console
marie@login$ lfs df -h <filesystem>
```

Useful options:

* `-h` outputs the units in human readable format.
* `-i` reports inode usage for each target and in summary.

!!! example "Example disk space usage at `/scratch`"

    At one moment in time, the disk space usage of the Lustre filesystem `/scratch` was:

    ```console
    lfs df -h /scratch
    UUID                       bytes        Used   Available Use% Mounted on
    scratch2-MDT0000_UUID        4.0T      502.8G        3.6T  13% /lustre/scratch2[MDT:0]
    scratch2-MDT0001_UUID      408.0G      117.7G      290.3G  29% /lustre/scratch2[MDT:1]
    scratch2-OST0000_UUID       28.9T       25.1T        3.7T  88% /lustre/scratch2[OST:0]
    scratch2-OST0001_UUID       28.9T       24.7T        4.1T  86% /lustre/scratch2[OST:1]
    scratch2-OST0002_UUID       28.9T       25.0T        3.9T  87% /lustre/scratch2[OST:2]
    scratch2-OST0003_UUID       28.9T       25.1T        3.8T  87% /lustre/scratch2[OST:3]
    [...]
    scratch2-OST008d_UUID       28.9T       25.0T        3.8T  87% /lustre/scratch2[OST:141]
    scratch2-OST008e_UUID       28.9T       24.9T        4.0T  87% /lustre/scratch2[OST:142]
    scratch2-OST008f_UUID       28.9T       25.3T        3.6T  88% /lustre/scratch2[OST:143]

    filesystem_summary:         4.1P        3.5P      571.8T  87% /lustre/scratch2
    ```

    The disk space usage is displayed separately for each MDS and OST as well in total. You can see
    that the usage is quite balanced between all MDSs and OSTs.

    If very large files are not properly stripped across several OSTs, the filesystem might become
    unbalanced with one server near 100% full.

### Listing Personal Disk Usages and Limits

To list your personal filesystem usage and limits (quota), invoke

```console
marie@login$ lfs quota -h -u $LOGIN <filesystem>
```

Useful options:

* `-h` outputs the units in human readable format.
* `-u|-g|-p <arg>` displays quota for specific user, group or project.
* `-v` displays the usage on each OST.

### Listing OSTs

You can list all OSTs available in a particular Lustre filesystem using `lfs osts`:

```console
marie@login$ lfs osts <filesystem>
```

If a path is specified, only OSTs belonging to the specified path are displayed.

### View Striping Information

```console
marie@login$ lfs getstripe myfile
marie@login$ lfs getstripe -d mydirectory
```

The argument `-d` will also display striping for all files in the directory.
