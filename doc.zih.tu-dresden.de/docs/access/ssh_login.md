# Connecting via Terminal (Linux, Mac, Windows)

Connecting via terminal works on every operating system. For Linux and Mac operating systems
no additional software is required. For users of a Windows OS a recent version of Windows is
required (Windows 10, Build 1809 and higher). It is possible to use
[Command Prompt](https://en.wikipedia.org/wiki/Cmd.exe) or [PowerShell](https://en.wikipedia.org/wiki/PowerShell)).
Ensure that [OpenSSH](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/factoryos/connect-using-ssh?view=windows-10)
is installed on the system.

SSH establishes secure connections using authentication and encryption. The login nodes accept
the following encryption algorithms: `aes128-ctr`, `aes192-ctr`, `aes256-ctr`,
`aes128-gcm@openssh.com`, `aes256-gcm@openssh.com`, `chacha20-poly1305@openssh.com`,
`chacha20-poly1305@openssh.com`.

## Before Your First Connection

We suggest to create an SSH key pair before you work with the ZIH systems. This ensures high
connection security.

```console
marie@local$ mkdir -p ~/.ssh
marie@local$ ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
[...]
```

Type in a passphrase for the protection of your key. The passphrase should be **non-empty**.
Copy the public key to the ZIH system (Replace placeholder `marie` with your ZIH login):

```console
marie@local$ ssh-copy-id -i ~/.ssh/id_ed25519.pub marie@taurus.hrsk.tu-dresden.de
The authenticity of host 'taurus.hrsk.tu-dresden.de (141.30.73.104)' can't be established.
RSA key fingerprint is SHA256:HjpVeymTpk0rqoc8Yvyc8d9KXQ/p2K0R8TJ27aFnIL8.
Are you sure you want to continue connecting (yes/no)?
```

Compare the shown fingerprint with the [documented fingerprints](key_fingerprints.md). Make sure
they match. Then you can accept by typing `yes`.

!!! info
    If `ssh-copy-id` is not available, you need to do additional steps:

    ```console
    marie@local$ scp ~/.ssh/id_ed25519.pub marie@taurus.hrsk.tu-dresden.de:
    The authenticity of host 'taurus.hrsk.tu-dresden.de (141.30.73.104)' can't be established.
    RSA key fingerprint is SHA256:HjpVeymTpk0rqoc8Yvyc8d9KXQ/p2K0R8TJ27aFnIL8.
    Are you sure you want to continue connecting (yes/no)?
    ```

    After that, you need to manually copy the key to the right place:

    ```console
    marie@local$ ssh marie@taurus.hrsk.tu-dresden.de
    [...]
    marie@login$ mkdir -p ~/.ssh
    marie@login$ touch ~/.ssh/authorized_keys
    marie@login$ cat id_ed25519.pub >> ~/.ssh/authorized_keys
    ```

### Configuring Default Parameters for SSH

After you have copied your key to the ZIH system, you should be able to connect using:

```console
marie@local$ ssh marie@taurus.hrsk.tu-dresden.de
[...]
marie@login$ exit
```

However, you can make this more comfortable if you prepare an SSH configuration on your local
workstation. Navigate to the subdirectory `.ssh` in your home directory and open the file `config`
(`~/.ssh/config`) in your favorite editor. If it does not exist, create it. Put the following lines
in it (you can omit lines starting with `#`):

```bash
Host taurus
  #For login (shell access)
  HostName taurus.hrsk.tu-dresden.de
  #Put your ZIH-Login after keyword "User":
  User marie
  #Path to private key:
  IdentityFile ~/.ssh/id_ed25519
  #Don't try other keys if you have more:
  IdentitiesOnly yes
  #Enable X11 forwarding for graphical applications and compression. You don't need parameter -X and -C when invoking ssh then.
  ForwardX11 yes
  Compression yes
Host taurusexport
  #For copying data without shell access
  HostName taurusexport.hrsk.tu-dresden.de
  #Put your ZIH-Login after keyword "User":
  User marie
  #Path to private key:
  IdentityFile ~/.ssh/id_ed25519
  #Don't try other keys if you have more:
  IdentitiesOnly yes
```

Afterwards, you can connect to the ZIH system using:

```console
marie@local$ ssh taurus
```

If you want to copy data from/to ZIH systems, please refer to [Export Nodes: Transfer Data to/from
ZIH's Filesystems](../data_transfer/export_nodes.md) for more information on export nodes.

## X11-Forwarding

If you plan to use an application with graphical user interface (GUI), you need to enable
X11-forwarding for the connection. If you use the SSH configuration described above, everything is
already prepared and you can simply use:

```console
marie@local$ ssh taurus
```

If you have omitted the last two lines in the default configuration above, you need to add the
option `-X` or `-XC` to your SSH command. The `-C` enables compression which usually improves
usability in this case:

```console
marie@local$ ssh -XC taurus
```

!!! info

    Also consider to use a [DCV session](desktop_cloud_visualization.md) for remote desktop
    visualization at ZIH systems.
