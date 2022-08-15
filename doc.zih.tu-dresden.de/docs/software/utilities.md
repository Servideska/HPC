# Utilities

This page provides tools and utilities that make your life on ZIH systems more comfortable.

## Tmux

### Best Practices

Terminal multiplexers are particularly well-suited for aiding you as a computer scientist in your
daily trade. We generally favor *tmux* as it's newer than certain others and allows for better
customization.

As there is already plenty of documentation on how to use tmux, we won't repeat that here. But
instead, we would like to point you to those documents:

* [Tmux man page](https://manpages.org/tmux)
* [Tmux customization](https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html#tmux-conf)
* [Tao of Tmux](https://tao-of-tmux.readthedocs.io/en/latest/)
* [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

### Basic Usage

Tmux is a terminal multiplexer. It lets you switch easily between several programs in one
terminal, detach them (they keep running in the background), and reattach them to a different
terminal.

The huge advantage is, that as long as your tmux session is running, you can connect to it and your
settings (e.g., loaded modules, current working directory, ...) are in place. This is
beneficial when working within an unstable network with connection losses (e.g., traveling by the
train in Germany), but also speed-ups your workflow in the daily routine.

```console
marie@compute$ tmux new-session -s marie_is_testing -d
marie@compute$ tmux attach -t marie_is_testing
  echo "hello world"
  ls -l
Ctrl+b & d
```

!!! note

    If you want to jump out of your tmux session, hold the Control key and press 'b'. After that,
    release both keys and press 'd'. With the first key combination, you address tmux itself, whereas
    'd' is the tmux command to "detach" yourself from it. The tmux session will stay alive and
    running. You can jump into it any time later by just using the aforementioned "tmux attach"
    command again.

### Using a More Recent Version

More recent versions of tmux are available via the module system. Using the well know
[module commands](modules.md#module-commands), you can query all available versions, load and unload
certain versions from your environment, e.g.,

```console
marie@login$ module load tmux/3.2a
```

### Error: Protocol Version Mismatch

When trying to connect to tmux, you might encounter the following error message:

```console
marie@compute$ tmux a -t juhu
protocol version mismatch (client 7, server 8)
```

To solve this issue, make sure that the tmux version you invoke
is the same as the tmux server that is running.
In particular, you can determine your client's version with the command `tmux -V`.
Try to [load the appropriate tmux version](#using-a-more-recent-version) to match with your
client's tmux server like this:

```console
marie@compute$ tmux -V
tmux 1.8
marie@compute$ module load tmux/3.2a
Module tmux/3.2a-GCCcore-11.2.0 and 5 dependencies loaded.
marie@compute$ tmux -V
tmux 3.2a
```

!!! hint

    When your client's version is newer than the server version, the aforementioned approach
    won't help you. In that case, you need to unload the loaded tmux module to downgrade
    the client to the client version that is supplied with the operating system (which
    should have a lower version number).

### Using Tmux on Compute Nodes

At times it might be quite handy to have tmux sessions running inside your computation jobs,
such that you perform your computations within an interactive tmux session.
For this purpose, the following shorthand is to be placed inside the
[job file](../jobs_and_resources/slurm.md#job-files):

```bash
#!/bin/bash
#SBATCH [...]

module load tmux/3.2a
tmux new-session -s marie_is_computing -d
sleep 1;
tmux wait-for CHANNEL_NAME_MARIE

srun [...]
```

You can then connect to the tmux session like this:

```console
marie@login$ ssh -t "$(squeue --me --noheader --format="%N" 2>/dev/null | tail -n 1)" \
             "source /etc/profile.d/10_modules.sh; module load tmux/3.2a; tmux attach"
```

### Where Is My Tmux Session?

Please note that, as there are thousands of compute nodes available, there are also multiple login
nodes. Thus, try checking the other login nodes as well:

```console
marie@login3$ tmux ls
failed to connect to server
marie@login3$ ssh login4 tmux ls
marie_is_testing: 1 windows (created Tue Mar 29 19:06:26 2022) [105x32]
```


## Working with Large Archives and Compressed Files

### Parallel Gzip Decompression

There is a plethora of gzip tools but none of them can fully utilize multiple cores.
The fastest single-core decoder is igzip from the
[Intelligent Storage Acceleration Library](https://github.com/intel/isa-l.git).
In tests, it can reach ~500 MB/s compared to ~200 MB/s for the system-default gzip.
If you have very large files and need to decompress them even faster, you can use
[pragzip](https://github.com/mxmlnkn/pragzip).
Currently, it can reach ~1.5 GB/s using a 12-core processor in the above-mentioned tests.

[Pragzip](https://github.com/mxmlnkn/pragzip) is available on PyPI and can be installed via pip.
It is recommended to install it inside a
[Python virtual environment](python_virtual_environments.md).

```bash
pip install pragzip
```

It can also be installed from its C++ source code.
If you prefer that over the version on PyPI, then you can build it like this:

```bash
git clone https://github.com/mxmlnkn/pragzip.git
cd pragzip
mkdir build
cd build
cmake ..
cmake --build . pragzip
src/tools/pragzip --help
```

The built binary can then be used directly or copied inside a folder that is available in your
`PATH` environment variable.

Pragzip is still in development, so if it crashes or if it is slower than the system gzip,
please [open an issue](https://github.com/mxmlnkn/pragzip/issues) on Github.

### Direct Archive Access Without Extraction

In some cases of archives with millions of small files, it might not be feasible to extract the
whole archive to a filesystem.
The known `archivemount` tool has performance problems with such archives even if they are simply
uncompressed TAR files.
Furthermore, with `archivemount` the archive would have to be reanalyzed whenever a new job is started.

`Ratarmount` is an alternative that solves these performance issues.
The archive will be analyzed and then can be accessed via a FUSE mountpoint showing the internal
folder hierarchy.
Access to files is consistently fast no matter the archive size while `archivemount` might take
minutes per file access.
Furthermore, the analysis results of the archive will be stored in a sidecar file alongside the
archive or in your home directory if the archive is in a non-writable location.
Subsequent mounts instantly load that sidecar file instead of reanalyzing the archive.

[Ratarmount](https://github.com/mxmlnkn/ratarmount) is available on PyPI and can be installed via pip.
It is recommended to install it inside a [Python virtual environment](python_virtual_environments.md).

```bash
pip install ratarmount
```

Ratarmount is still in development, so if there are problems or if it is unexpectedly slow,
please [open an issue](https://github.com/mxmlnkn/ratarmount/issues) on Github.

There also is a library interface called
[ratarmountcore](https://github.com/mxmlnkn/ratarmount/tree/master/core#example) that works
fully without FUSE, which might make access to files from Python even faster.
