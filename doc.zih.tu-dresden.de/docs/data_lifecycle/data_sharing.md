# Sharing Data

This page should provide you some commands to share your data with other users or projects.
Read on, if you want to restrict access to specific persons outside of your group, but don't want to
permit everyone to access your data.

## Managing Access Control Lists

[Access Control Lists](https://en.wikipedia.org/wiki/Access-control_list) (ACLs) can be used, when
`chmod` is not sufficient anymore, e. g. because you want to permit accessing a particular file for
persons from your project and also some persons outside of your project, but not everyone.

!!! note

    At the moment `setfacl` is only working on our Lustre filesystems, which contain the workspaces
    `scratch` and `ssd`.

The command `setfacl` is used manage access rights for workspaces. To view the current access
rights, use the command `getfacl`. The following commands are used to grant a user access to the
workspace.

If you are unsure what your group/project is, you can use the following command to find out:

```console
marie@login$ id --group --name
p_number_crunch
```

If you are in multiple projects, you could see all of them using `--groups` instead of `--group`:

```console
marie@login$ id --groups --name
p_number_crunch
```

!!! example "Grant a user full access to the workspace folder"

    ```console
    marie@login$ setfacl --modify=u:<username>:rwx <path_to_workspace>
    ```

    For example, if `marie` wants to give her colleague `martin` access to the workspace
    `input-data` she has created, she would use the following command:

    ```console
    marie@login$ setfacl --modify=u:martin:rwx /scratch/ws/1/marie-input-data
    ```

!!! example "Inherit these same rights to all newly created files and folders"

    ```console
    marie@login$ setfacl --modify=d:u:<username>:rwx <path_to_workspace>
    ```

!!! example "Grant a project full access to the workspace folder"

    ```console
    marie@login$ setfacl --modify=g:<projectname>:rwx <path_to_workspace>
    ```

    For example, if `marie` wants to give all colleagues in `martin`'s project `p_long_computations`
    access to the workspace `input-data` she has created, she would use the following command:

    ```console
    marie@login$ setfacl --modify=g:p_long_computations:rwx /scratch/ws/1/marie-input-data
    ```

!!! example "Inherit these same rights to all newly created files and folders"

    ```console
    marie@login$ setfacl --modify=d:g:<projectname>:rwx <path_to_workspace>
    ```

If you already have files inside your workspace, remember to use the `-R` or `--recursive` options
to apply these ACL changes to all files.

!!! example "Remove the access rights for a particular user"

    If you want to remove a user's access then use:

    ```console
    marie@login$ setfacl --remove=u:<username> <path_to_workspace>
    ```

    Remember to also remove the default access rights, if you added them previously:

    ```console
    marie@login$ setfacl --remove=d:u:<username> <path_to_workspace>
    ```

    For example, if `marie` wants to remove access to the workspace `input-data` she has given
    `martin` earlier:

    ```console
    marie@login$ setfacl --remove=u:martin /scratch/ws/1/marie-input-data
    ```

    And just to be sure, she would also remove default access rights for him:

    ```console
    marie@login$ setfacl --remove=d:u:martin /scratch/ws/1/marie-input-data
    ```

More details on ACLs can be found on the [setfacl man page](https://man.archlinux.org/man/setfacl.1).
