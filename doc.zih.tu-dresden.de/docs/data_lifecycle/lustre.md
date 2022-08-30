# Lustre

## Large Files in /scratch

The data containers in [Lustre](https://www.lustre.org) are called object storage targets (OST). The
capacity of one OST is about 21 TB. All files are striped over a certain number of these OSTs. For
small and medium files, the default number is 2. As soon as a file grows above ~1 TB it makes sense
to spread it over a higher number of OSTs, e.g. 16. Once the filesystem is used >75%, the average
space per OST is only 5 GB. So, it is essential to split your larger files so that the chunks can be
saved!

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

In this sense, you should minimize the usage of system calls quering or modifying file
and directory attributes, e.g. `stat()`, `statx()`, `open()`, `openat()` etc.

Please, also avoid commands basing on the above mentioned system calls such as `ls -l` and `ls
--color`.
Instead, you should invoke `ls` or `ls -l <filename` to reduce metadata operations.
This also holds
for commands walking the filessystems recursively performing massive metadata operations such as `ls
-R`, `find`, `locate`, `du` and `df`.

Lustre offers a number of commands that are suited to its architecture.

| Good | Bad |
|:-----|:----|
| `lfs df` | `df` |
| `lfs find` | `find` |
| `ls -l <filename>` | `ls -l` |
| `ls` | `ls --color` |

## Useful Commands for Lustre

These commands work for Lustre file systems `/scratch` and `/ssd`.

### Listing Disk Usages per OST and MDT

```console
marie@login$ lfs quota -h -u username /path/to/my/data
```

It is possible to display the usage on each OST by adding the argument `-v`.

### Listing Space Usage per OST and MDT

```console
marie@login$ lfs df -h /path/to/my/data
```

### Listing inode usage for an specific path

```console
marie@login$ lfs df -i /path/to/my/data
```

### Listing OSTs

```console
marie@login$ lfs osts /path/to/my/data
```

### View Striping Information

```console
marie@login$ lfs getstripe myfile
marie@login$ lfs getstripe -d mydirectory
```

The argument `-d` will also display striping for all files in the directory.
