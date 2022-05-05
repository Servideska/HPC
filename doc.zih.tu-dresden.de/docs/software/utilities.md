# Utilities

This pages provides tools and utilities that make your life on ZIH systems more comfortable.

## Tmux

### Best Practices

Terminal emulators are particularly well-suited for aiding the computer scientist in their trade.
We generally favor TMUX("**T**erminal **Mu**litple**x**er") as it's newer than certain others and
allows for better customization.

As there is already plenty of documentation on how to use Tmux,
we won't repeat that here.
But instead we would like to point you to those documentations:

* [Tmux manpage](https://manpages.org/tmux)
* [Tmux.conf customization](https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html#tmux-conf)
* [Tao of Tmux](https://tao-of-tmux.readthedocs.io/en/latest/)
* [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

### Making your interactive sessions more stable

Sometimes when you work on ZIH systems, you might encounter a connection loss.
While working on fixing the underlying issue
(e.g. an unstable Wi-Fi connection is certainly a good cause),
you might however find it to be quite efficient,
to just open up a Tmux session on ZIH systems,
into which you can connect to the running sessions anytime again
(e.g. also two days later):

```console
marie@compute$ tmux new-session -s marie_is_testing -d
marie@compute$ tmux attach -t marie_is_testing
  echo "hello world"
  ls -l
Ctrl+B & d
```

!!! note NOTE:
    Do note that if you want to jump out of your Tmux session,
    you would usually be using the key combination
    Control Key and B-Key (thus now addressing Tmux itself)
    and then you'd be using the D-Key to tell it to "detach" yourself from it
    (the Tmux session will stay alive and running).
    You can jump into it any time later by just using the aforementioned "tmux attach" command again.
    ++ctrl+B++  ++D++

### Using a more recent Tmux version on ZIH systems

You might find yourself wanting to use a more recent Tmux version
and you can do so with this command:

```console
marie@compute$ module load tmux
```

### Using Tmux on Computation Nodes

At times it might be quite handy to have Tmux sessions running inside your computation jobs,
such that you perform your computations within an interactive Tmux session.
For this purpose the following shorthand is to be placed inside an sbatch file that comes in handy:

```bash
module load tmux/3.2a
tmux new-session -s marie_is_computing -d
sleep 1;
tmux wait-for CHANNEL_NAME_MARIE
```

You can then connect to it like this:

```console
ssh -t "$(squeue -u $USER -o "%N" 2>/dev/null | tail -n 1)" "source /etc/profile.d/10_modules.sh; module load tmux/3.2a; tmux attach"
```

### Error: Protocol version mismatch

When trying to connect to Tmux, you might encounter the following error message:

```console
marie@compute$ tmux a -t juhu
protocol version mismatch (client 7, server 8)
```

To solve this issue, make sure that the Tmux-version you invoke
is the same as the Tmux-server that is running.
In particular you can determine your client's version with the command `tmux -V`.
Try to load the appropriate tmux-version to match with your client's tmux-server like this:

```console
marie@compute$ tmux -V
tmux 1.8
marie@compute$ module load tmux/3.2a
Module tmux/3.2a-GCCcore-11.2.0 and 5 dependencies loaded.
marie@compute$ tmux -V
tmux 3.2a
```

!!! hint NOTE:
    When your client's version is newer than the server-version,
    the aforementioned approach won't help you.
    In that case you might want to invoke `module unload tmux`,
    to downgrade your Tmux version to the Tmux version that is supplied with the operating system
    (which should have a lower version number).

### My Tmux session is gone, what happened?

Please note that, as there are thousands of compute nodes available,
there are also multiple login nodes.

Thus, try checking the other login nodes as well:

```console
marie@login3$ tmux ls
failed to connect to server
marie@login3$ ssh login4 tmux ls
marie_is_testing: 1 windows (created Tue Mar 29 19:06:26 2022) [105x32]
```
