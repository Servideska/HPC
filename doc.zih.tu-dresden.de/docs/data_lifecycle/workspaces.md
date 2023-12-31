# Workspaces

Storage systems differ in terms of capacity, streaming bandwidth, IOPS rate, etc. Price and
efficiency don't allow to have it all in one. That is why fast parallel filesystems at ZIH have
restrictions with regards to **age of files** and [quota](permanent.md#quotas). The mechanism of
workspaces enables you to better manage your HPC data. It is common and used at a large number
of HPC centers.

!!! note

    A **workspace** is a directory, with an associated expiration date, created on behalf of a user
    in a certain filesystem.

Once the workspace has reached its expiration date, it gets moved to a hidden directory and enters a
grace period. Once the grace period ends, the workspace is deleted permanently. The maximum lifetime
of a workspace depends on the storage system. All workspaces can be extended a certain amount of
times.

!!! tip

    Use the faster filesystems if you need to write temporary data in your computations, and use
    the capacity oriented filesystems if you only need to read data for your computations. Please
    keep track of your data and move it to a capacity oriented filesystem after the end of your
    computations.

## Workspace Management

### List Available Filesystems

To list all available filesystems for using workspaces, you can either invoke `ws_list -l` or
`ws_find -l`, e.g.,

```console
marie@login$ ws_find -l
available filesystems:
scratch (default)
warm_archive
ssd
beegfs_global0
beegfs
```

!!! note "Default is `scratch`"

    The default filesystem is `scratch`. If you prefer another filesystem (cf. section
    [List Available Filesystems](#list-available-filesystems)), you have to explictly
    provide the option `-F <fs>` to the workspace commands.

### List Current Workspaces

The command `ws_list` lists all your currently active (,i.e, not expired) workspaces, e.g.

```console
marie@login$ ws_list
id: test-workspace
     workspace directory  : /scratch/ws/0/marie-test-workspace
     remaining time       : 89 days 23 hours
     creation time        : Thu Jul 29 10:30:04 2021
     expiration date      : Wed Oct 27 10:30:04 2021
     filesystem name      : scratch
     available extensions : 10
```

The output of `ws_list` can be customized via several options. The following switch tab provides a
overview of some of these options. All available options can be queried by `ws_list --help`.

=== "Certain filesystem"

    ```
    marie@login$ ws_list --filesystem scratch_fast
    id: numbercrunch
         workspace directory  : /lustre/ssd/ws/marie-numbercrunch
         remaining time       : 2 days 23 hours
         creation time        : Thu Mar  2 14:15:33 2023
         expiration date      : Sun Mar  5 14:15:33 2023
         filesystem name      : ssd
         available extensions : 2
    ```

=== "Verbose output"

    ```
    marie@login$ ws_list -v
    id: test-workspace
         workspace directory  : /scratch/ws/0/marie-test-workspace
         remaining time       : 89 days 23 hours
         creation time        : Thu Jul 29 10:30:04 2021
         expiration date      : Wed Oct 27 10:30:04 2021
         filesystem name      : scratch
         available extensions : 10
         acctcode             : p_numbercrunch
         reminder             : Sat Oct 20 10:30:04 2021
         mailaddress          : marie@tu-dresden.de
    ```

=== "Terse output"

    ```
    marie@login$ ws_list -t
    id: test-workspace
         workspace directory  : /scratch/ws/0/marie-test-workspace
         remaining time       : 89 days 23 hours
         available extensions : 10
    id: foo
         workspace directory  : /scratch/ws/0/marie-foo
         remaining time       : 3 days 22 hours
         available extensions : 10
    ```

=== "Show only names"

    ```
    marie@login$ ws_list -s
    test-workspace
    foo
    ```

=== "Sort by remaining time"

    You can list your currently allocated workspace by remaining time. This is especially useful
    for housekeeping tasks, such as extending soon expiring workspaces if necessary.

    ```
    marie@login$ ws_list -R -t
    id: test-workspace
         workspace directory  : /scratch/ws/0/marie-test-workspace
         remaining time       : 89 days 23 hours
         available extensions : 10
    id: foo
         workspace directory  : /scratch/ws/0/marie-foof
         remaining time       : 3 days 22 hours
         available extensions : 10
    ```

### Allocate a Workspace

To allocate a workspace in one of the listed filesystems, use `ws_allocate`. It is necessary to
specify a unique name and the duration of the workspace.

```console
ws_allocate: [options] workspace_name duration

Options:
  -h [ --help]               produce help message
  -V [ --version ]           show version
  -d [ --duration ] arg (=1) duration in days
  -n [ --name ] arg          workspace name
  -F [ --filesystem ] arg    filesystem
  -r [ --reminder ] arg      reminder to be sent n days before expiration
  -m [ --mailaddress ] arg   mailaddress to send reminder to (works only with tu-dresden.de mails)
  -x [ --extension ]         extend workspace
  -u [ --username ] arg      username
  -g [ --group ]             group workspace
  -c [ --comment ] arg       comment
```

!!! example

    ```console
    marie@login$ ws_allocate -F scratch -r 7 -m marie.testuser@tu-dresden.de test-workspace 90
    Info: creating workspace.
    /scratch/ws/marie-test-workspace
    remaining extensions  : 10
    remaining time in days: 90
    ```

This will create a workspace with the name `test-workspace` on the `/scratch` filesystem for 90
days with an email reminder for 7 days before the expiration.

!!! Note "Email reminder"

    Setting the reminder to `7` means you will get a reminder email on every day starting `7` days
    prior to expiration date. We strongly recommend to set this email reminder.

!!! Note "Name of a workspace"

   The workspace name should help you to remember the experiment and data stored here. It has to
   be unique on a certain filesystem. On the other hand it is possible to use the very same name
   for workspaces on different filesystems.

Please refer to the section [section Cooperative Usage](#cooperative-usage-group-workspaces) for
group workspaces.

### Extension of a Workspace

The lifetime of a workspace is finite and different filesystems (storage systems) have different
maximum durations. A workspace can be extended multiple times, depending on the filesystem.

| Filesystem (use with parameter `-F <fs>`) | Duration, days | Extensions | [Filesystem Feature](../jobs_and_resources/slurm.md#filesystem-features) | Remarks |
|:-------------------------------------|---------------:|-----------:|:-------------------------------------------------------------------------|:--------|
| `scratch` (default)                  | 100            | 10         | `fs_lustre_scratch2`                                                     | Scratch filesystem (`/lustre/scratch2`, symbolic link: `/scratch`) with high streaming bandwidth, based on spinning disks |
| `ssd`                                | 30             | 2          | `fs_lustre_ssd`                                                          | High-IOPS filesystem (`/lustre/ssd`, symbolic link: `/ssd`) on SSDs. |
| `beegfs_global0` (deprecated)        | 30             | 2          | `fs_beegfs_global0`                                                      | High-IOPS filesystem (`/beegfs/global0`) on NVMes. |
| `beegfs`                             | 30             | 2          | `fs_beegfs`                                                              | High-IOPS filesystem (`/beegfs`) on NVMes. |
| `warm_archive`                       | 365            | 2          | `fs_warm_archive_ws`                                                     | Capacity filesystem based on spinning disks |
{: summary="Settings for Workspace Filesystem."}

Use the command `ws_extend` to extend your workspace:

```console
marie@login$ ws_extend -F scratch test-workspace 100
Info: extending workspace.
/scratch/ws/marie-test-workspace
remaining extensions  : 1
remaining time in days: 100
```

Mail reminder settings are retained. I.e., previously set mail alerts apply to the extended
workspace, too.

!!! attention

    With the `ws_extend` command, a new duration for the workspace is set. The new duration is not
    added to the remaining lifetime!

This means when you extend a workspace that expires in 90 days with the command

```console
marie@login$ ws_extend -F scratch my-workspace 40
```

it will now expire in 40 days **not** 130 days.

### Send Reminder for Workspace Expiry Date

Send a calendar invitation by Email to ensure that the expiration date of a workspace is not
forgotten

```console
marie@login$ ws_send_ical -F scratch my-workspace -m marie.testuser@tu-dresden.de
```

### Deletion of a Workspace

To delete a workspace use the `ws_release` command. It is mandatory to specify the name of the
workspace and the filesystem in which it is located:

```console
marie@login$ ws_release -F scratch my-workspace
```

You can list your already released or expired workspaces using the `ws_restore -l` command.

```console
marie@login$ ws_restore -l
warm_archive:
scratch:
marie-my-workspace-1665014486
  unavailable since Thu Oct  6 02:01:26 2022
marie-foo-647085320
  unavailable since Sat Mar 12 12:42:00 2022
ssd:
marie-bar-1654074660
  unavailable since Wen Jun 1 11:11:00 2022
beegfs_global0:
beegfs:
```

In this example, the user `marie` has three inactive, i.e., expired, workspaces namely
`my-workspace` in `scratch`, as well as `foo` and `bar` in `ssd` filesystem. The command `ws_restore
-l` lists the name of the workspace and the expiration date. As you can see, the expiration date is
added to the workspace name as Unix timestamp.

!!! hint "Deleting data in in an expired workspace"

    If you are short on quota, you might want to delete data in expired workspaces since it counts
    to your quota. Expired workspaces are moved to a hidden directory named `.removed`. The access
    rights remain unchanged. I.e., you can delete the data inside the workspace directory but you
    must not delete the workspace directory itself!

#### Expirer Process

The clean up process of expired workspaces is automatically handled by a so-called expirer process.
It performs the following steps once per day and filesystem:

- Check for remaining life time of all workspaces.
  - If the workspaces expired, move it to a hidden directory so that it becomes inactive.
- Send reminder Emails to users if the reminder functionality was configured for their particular
  workspaces.
- Scan through all workspaces in grace period.
  - If a workspace exceeded the grace period, the workspace and its data are deleted.

### Restoring Expired Workspaces

At expiration time your workspace will be moved to a special, hidden directory. For a month (in
warm_archive: 2 months), you can still restore your data **into an existing workspace**.

!!! warning

    When you release a workspace **by hand**, it will not receive a grace period and be
    **permanently deleted** the **next day**. The advantage of this design is that you can create
    and release workspaces inside jobs and not swamp the filesystem with data no one needs anymore
    in the hidden directories (when workspaces are in the grace period).

Use

```console
marie@login$ ws_restore -l -F scratch
scratch:
marie-my-workspace-1665014486
  unavailable since Thu Oct  6 02:01:26 2022
```

to get a list of your expired workspaces, and then restore them like that into an existing, active
workspace 'new_ws':

```console
marie@login$ ws_restore -F scratch marie-my-workspace-1665014486 new_ws
```

The expired workspace has to be specified by its full name as listed by `ws_restore -l`, including
username prefix and timestamp suffix (otherwise, it cannot be uniquely identified). The target
workspace, on the other hand, must be given with just its short name, as listed by `ws_list`,
without the username prefix.

Both workspaces must be on the same filesystem. The data from the old workspace will be moved into
a directory in the new workspace with the name of the old one. This means a fresh workspace works as
well as a workspace that already contains data.

## Linking Workspaces in HOME

It might be valuable to have links to personal workspaces within a certain directory, e.g., your
home directory. The command `ws_register DIR` will create and manage links to all personal
workspaces within in the directory `DIR`. Calling this command will do the following:

- The directory `DIR` will be created if necessary.
- Links to all personal workspaces will be managed:
    - Create links to all available workspaces if not already present.
    - Remove links to released workspaces.

**Remark**: An automatic update of the workspace links can be invoked by putting the command
`ws_register DIR` in your personal `shell` configuration file (e.g., `.bashrc`).

## How to use Workspaces

There are three typical options for the use of workspaces:

### Per-Job Storage

The idea of a "workspace per-job storage" addresses the need of a batch job for a directory for
temporary data which can be deleted afterwards. To help you to write your own
[(Slurm) job file](../jobs_and_resources/slurm.md#job-files), suited to your needs, we came up with
the following example (which works [for the program g16](../software/nanoscale_simulations.md)).

!!! hint

    Please do not blind copy the example, but rather take the essential idea and concept and adjust
    it to your needs and workflow, e.g.

    * adopt Slurm options for ressource specification,
    * inserting the path to your input file,
    * what software you want to [load](../software/modules.md),
    * and calling the actual software to do your computation.

!!! example "Using temporary workspaces for I/O intensive tasks"

    ```bash
    #!/bin/bash

    #SBATCH --partition=haswell
    #SBATCH --time=48:00:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    ## The optional constraint for the filesystem feature depends
    ## on the filesystem on which you want to use a workspace.
    ## Documentation here https://doc.zih.tu-dresden.de/jobs_and_resources/slurm/#available-features
    #SBATCH --constraint=fs_lustre_ssd
    #SBATCH --cpus-per-task=24

    # Load the software you need here
    module purge
    module load <modules>

    # The path to where your input file is located
    INPUTFILE="/path/to/my/inputfile.data"
    test ! -f "${INPUTFILE}" && echo "Error: Could not find the input file ${INPUTFILE}" && exit 1

    # The workspace where results from multiple expirements will be saved for later analysis
    RESULT_WSDIR="/path/to/workspace-experiments-results"
    test -z "${RESULT_WSDIR}" && echo "Error: Cannot find workspace ${RESULT_WSDIR}" && exit 1

    # Allocate workspace for this job. Adjust time span to time limit of the job (-d <N>).
    WSNAME=computation_$SLURM_JOB_ID
    export WSDDIR=$(ws_allocate -F ssd -n ${WSNAME} -d 2)
    echo ${WSDIR}

    # Check allocation
    test -z "${WSDIR}" && echo "Error: Cannot allocate workspace ${WSDIR}" && exit 1

    # Change to workspace directory
    cd ${WSDIR}

    # Adjust the following line to invoke the program you want to run
    srun <application> < "${INPUTFILE}" > logfile.log

    # Move result and log files of interest to directory named 'results'. This directory and its
    # content will be saved in another storage location for later analysis. All files and
    # directories will be deleted right away at the end of this job file.
    mkdir results
    cp <results and log files> results/

    # Save result files in a general workspace (RESULT_WSDIR, s.a.) holding results from several
    # experiments.
    # Compress results with bzip2 (which includes CRC32 Checksums).
    bzip2 --compress --stdout -4 "${WSDIR}/results" > ${RESULT_WSDIR}/gaussian_job-${SLURM_JOB_ID}.bz2
    RETURN_CODE=$?
    COMPRESSION_SUCCESS="$(if test ${RETURN_CODE} -eq 0; then echo 'TRUE'; else echo 'FALSE'; fi)"

    # Clean up workspace
    if [ "TRUE" = ${COMPRESSION_SUCCESS} ]; then
        test -d ${WSDIR} && rm -rf ${WSDIR}/*
        # Reduces grace period to 1 day!
        ws_release -F ssd ${WSNAME}
    else
        echo "Error with compression and writing of results"
        echo "Please check the folder \"${WSDIR}\" for any partial(?) results."
        exit 1
    fi
    ```

### Data for a Campaign

For a series of jobs or calculations that work on the same data, you should allocate a workspace
once, e.g., in `scratch` for 100 days:

```console
marie@login$ ws_allocate -F scratch my_scratchdata 100
Info: creating workspace.
/scratch/ws/marie-my_scratchdata
remaining extensions  : 2
remaining time in days: 99
```

You can grant your project group access rights:

```
chmod g+wrx /scratch/ws/marie-my_scratchdata
```

And verify it with:

```console
marie@login$ ls -la /scratch/ws/marie-my_scratchdata
total 8
drwxrwx--- 2 marie    hpcsupport 4096 Jul 10 09:03 .
drwxr-xr-x 5 operator adm        4096 Jul 10 09:01 ..
```

### Mid-Term Storage

For data that seldom changes but consumes a lot of space, the warm archive can be used. Note that
this is mounted read-only on the compute nodes, so you cannot use it as a work directory for your
jobs!

```console
marie@login$ ws_allocate -F warm_archive my_inputdata 365
/warm_archive/ws/marie-my_inputdata
remaining extensions  : 2
remaining time in days: 365
```

!!!Attention

    The warm archive is not built for billions of files. There
    is a quota for 100.000 files per group. Please archive data.

To see your active quota use

```console
marie@login$ qinfo quota /warm_archive/ws/
```

Note that the workspaces reside under the mountpoint `/warm_archive/ws/` and not `/warm_archive`
anymore.

## Cooperative Usage (Group Workspaces)

When a workspace is created with the option `-g, --group`, it gets a group workspace that is visible
to others (if in the same group) via `ws_list -g`.

!!! hint "Chose group"

    If you are member of multiple groups, than the group workspace is visible for your primary
    group. You can list all groups you belong to via `groups`, and the first entry is your
    primary group.

    Nevertheless, you can create a group workspace for any of your groups following these two
    steps:

    1. Change to the desired group using `newgrp <other-group>`.
    1. Create the group workspace as usual, i.e., `ws_allocate --group [...]`

    The [page on Sharing Data](data_sharing.md) provides
    information on how to grant access to certain colleagues and whole project groups.

!!! Example "Allocate and list group workspaces"

    If Marie wants to share results and scripts in a workspace with all of her colleagues
    in the project `p_number_crunch`, she can allocate a so-called group workspace.

    ```console
    marie@login$ ws_allocate --group --name numbercrunch --duration 30
    Info: creating workspace.
    /scratch/ws/0/marie-numbercrunch
    remaining extensions  : 10
    remaining time in days: 30
    ```

    This workspace directory is readable for the group, e.g.,

    ```console
    marie@login$ ls -ld /scratch/ws/0/marie-numbercrunch
    drwxr-x--- 2 marie p_number_crunch 4096 Mar  2 15:24 /scratch/ws/0/marie-numbercrunch
    ```

    All members of the project group `p_number_crunch` can now list this workspace using
    `ws_list -g` and access the data (read-only).

    ```console
    martin@login$ ws_list -g -t
    id: numbercrunch
         workspace directory  : /scratch/ws/0/marie-numbercrunch
         remaining time       : 29 days 23 hours
         available extensions : 10
    ```

## FAQ and Troubleshooting

**Q**: I am getting the error `Error: could not create workspace directory!`

**A**: Please check the "locale" setting of your SSH client. Some clients (e.g. the one from Mac)
set values that are not valid on our ZIH systems. You should overwrite `LC_CTYPE` and set it to a
valid locale value like `export LC_CTYPE=de_DE.UTF-8`.

A list of valid locales can be retrieved via `locale -a`.

Please use `language_CountryCode.UTF-8` (or plain) settings. Avoid "iso" codepages!

Examples:

| Language | Code |
| -------- | ---- |
| Chinese - Simplified | zh_CN.UTF-8 |
| English | en_US.UTF-8 |
| French | fr_FR.UTF-8 |
| German | de_DE.UTF-8 |

----

**Q**: I am getting the error `Error: target workspace does not exist!` when trying to restore my
workspace.

**A**: The workspace you want to restore into is either not on the same filesystem or you used the
wrong name. Use only the short name that is listed after `id:` when using `ws_list`.

----

**Q**: Man, I've missed to specify mail alert when allocating my workspace. How can I add the mail
alert functionality to an existing workspace?

**A**: You can add the mail alert by "overwriting" the workspace settings via `ws_allocate -x -m
<mail address> -r <days> -n <ws-name> -d <duration> -F <fs>`. (This will lower the remaining
extensions by one.)
