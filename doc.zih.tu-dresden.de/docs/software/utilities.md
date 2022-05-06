# Utilities

This pages provides tools and utilities that make your life on ZIH systems more comfortable.

## Tmux

### Best Practices

Terminal multiplexers are particularly well-suited for aiding you as a computer scientist in your
daily trade. We generally favor *tmux* as it's newer than certain others and allows for better
customization.

As there is already plenty of documentation on how to use tmux, we won't repeat that here. But
instead we would like to point you to those documentations:

* [tmux manpage](https://manpages.org/tmux)
* [tmux.conf customization](https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html#tmux-conf)
* [Tao of tmux](https://tao-of-tmux.readthedocs.io/en/latest/)
* [tmux Cheat Sheet](https://tmuxcheatsheet.com/)

### Basic Usage

Tmux is a terminal multiplexer. It lets you switch easily between several programs in one
terminal, detach them (they keep running in the background) and reattach them to a different
terminal.

The huge advantage is, that as long as your tmux session is running, you can connect to it and your
settings (e.g., loaded modules, current working directory, ...) are in place. This is clearly
beneficial when working within an unstable network with connection loses (e.g., traveling with the
train in Germany), but also speed ups your workflow in the daily routine.

``` bash
marie@compute$ tmux new-session -s marie_is_testing -d
marie@compute$ tmux attach -t marie_is_testing
  echo "hello world"
  ls -l
Ctrl+b & d
```

!!! note

    If you want to jump out of your tmux session, hold the Control key and press 'b'. After that,
    release both keys and type 'd'. With the first key combination you address tmux itself, whereas
    'd' is the tmux command to "detach" yourself from it. The tmux session will stay alive and
    running. You can jump into it any time later by just using the aforementioned "tmux attach"
    command again.

### Using a More Recent Version

More recent versions of tmux are available via the module system. Using the well know
[module commands](modules.md#module-commands), you can query all available versions, load and unload
certain versions from your environment, e.g.,

``` bash
marie@login$ module load tmux/3.2a
```

### Error: Protocol Version Mismatch

When trying to connect to tmux, you might encounter the following error message:

``` bash
marie@compute$ tmux a -t juhu
protocol version mismatch (client 7, server 8)
```

To solve this issue, make sure that the tmux version you invoke
is the same as the tmux server that is running.
In particular you can determine your client's version with the command `tmux -V`.
Try to [load the appropriate tmux version](#using-a-more-recent-tmux-version) to match with your
client's tmux server like this:

```
marie@compute$ tmux -V
tmux 1.8
marie@compute$ module load tmux/3.2a
Module tmux/3.2a-GCCcore-11.2.0 and 5 dependencies loaded.
marie@compute$ tmux -V
tmux 3.2a
```

!!! hint

    When your client's version is newer than the server version, the aforementioned approach
    won't help you. In that case, you need to unload the loaded tmux module in order to downgrade
    the client to the client version that is supplied with the operating system (which
    should have a lower version number).

### Using Tmux on Compute Nodes

At times it might be quite handy to have tmux sessions running inside your computation jobs,
such that you perform your computations within an interactive tmux session.
For this purpose the following shorthand is to be placed inside the
[jobfile](../jobs_and_resources/slurm.md#job-files):

```bash
module load tmux/3.2a
tmux new-session -s marie_is_computing -d
sleep 1;
tmux wait-for CHANNEL_NAME_MARIE
```

You can then connect to the tmux session like this:

``` bash
ssh -t "$(squeue --me --noheader --format="%N" 2>/dev/null | tail -n 1)" "source /etc/profile.d/10_modules.sh; module load tmux/3.2a; tmux attach"
```

### Where Is My Tmux Session?

Please note that, as there are thousands of compute nodes available, there are also multiple login
nodes.

Thus, try checking the other login nodes as well:

``` bash
marie@login3$ tmux ls
failed to connect to server
marie@login3$ ssh login4 tmux ls
marie_is_testing: 1 windows (created Tue Mar 29 19:06:26 2022) [105x32]
```
