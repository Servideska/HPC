# Utilities

This pages provides tools and utilities that make your life on ZIH systems more comfortable.

## Tmux

### Best Practices

Terminal emulators are particularly well-suited for aiding the computer scientist in their trade. We
generally favor tmux ("**Te**rminal **Mu**litple**x**er") as it's newer than certain others and
allows for better customization.

As there is already plenty of documentation on how to use tmux, we won't repeat that here.  But
instead we would like to point you to that documentation:

* [Tmux manpage](https://manpages.org/tmux) [tmux.conf
* customization](https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html#tmux-conf) [Tmux Cheat
* Sheet](https://tmuxcheatsheet.com/)

## Making your interactive sessions more stable

Sometimes when you work on taurus, you might encounter a connection loss.  While working on fixing
the underlying cause (e.g. an unstable wifi connection) is certainly a good cause, you might however
find it to be quite efficient, to just open up a tmux session on taurus, into which you can connect
again and again (e.g. also two days later):

``` bash marie@compute$ tmux new-session -s marie_is_testing -d marie@compute$ tmux attach -t
marie_is_testing echo "hello world" ls -l Ctrl+B & d ```

!!! PENCIL Do note that if you want to jump out of your tmux session you would usually be using the
key combination Control Key and B-Key (thus now adressing tmux itself) and then you'd be using the
D-Key to tell it to "detach" yourself from it (the tmux will stay alive and running). You can jump
into it at any later time by just using the aforementioned "tmux attach" command again.  ++ctrl+B++
++D++

## Using a more recent Tmux on Taurus

You might find yourself wanting to use a more recent tmux, you can do so like this: ``` bash
marie@compute$ module load tmux ```

## Using Tmux on Computation Nodes

At times it might be quite handy to have tmux running inside your computation jobs, such that you
perform your computations within an interactive tmux session.  For this purpose the following
shorthand to be placed inside an sbatch file has come in handy:

``` bash module load tmux/3.1c tmux new-session -s marie_is_computing -d sleep 1; tmux wait-for
CHANNEL_NAME_MARIE ```

You can then connect to it like this: ``` bash ssh -t "$(squeue -u $USER -o "%N" 2>/dev/null | tail
-n 1)" "source /etc/profile.d/10_modules.sh; module load tmux/3.2a; tmux attach" ```

## Error: Protocol version mismatch

When trying to connect to tmux, you might encounter the following error message:

``` bash marie@compute$ tmux a -t juhu protocol version mismatch (client 7, server 8) ```

To solve this issue, make sure the `tmux` you invoke, is the same as the tmux-server that is
running.  In particular you can determine your client's version with the command `tmux -V`.  Try to
load the appropriate tmux-version to match your client with the tmux-server, like this: ```
marie@compute$ tmux -V tmux 1.8 marie@compute$ module load tmux/3.2a Module tmux/3.2a-GCCcore-11.2.0
and 5 dependencies loaded.  marie@compute$ tmux -V tmux 3.2a ```

!!! NOTE When your client version is newer than the server-version however the aforementioned
approach won't help you.  In that case you might want to invoke `module unload tmux`, to downgrade
your tmux to the tmux that is supplied, with the operating system (which should have a lower version
number).


## My tmux session is gone, what happened?

Please note that, as there are thousands of computes-nodes, so, also, there are multiple login
nodes.  Thus try checking the other login nodes as well:

``` bash marie@tauruslogin3$ tmux ls failed to connect to server marie@tauruslogin3$ ssh
tauruslogin4 tmux ls marie_is_testing: 1 windows (created Tue Mar 29 19:06:26 2022) [105x32] ```
