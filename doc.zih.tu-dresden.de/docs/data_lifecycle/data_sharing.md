# Sharing Data

This chapter should provide you some commands to share your data with other user or projects.

## Managing ACLs

!!! note

    At the moment `setfacl` is only working on our Lustre file systems, which contain the
    workspaces `scratch` and `ssd`.

The command `setfacl` is used manage access rights for workspaces. To view the
current access rights, use the command `getfacl`.  The following commands are
used to grant a user access to the workspace.

```shell console
# Grant a user full access to the workspace folder
setfacl --modify=u:<username>:rwx /path/to/workspace

# Inherit these same rights to all newly created files and folders
setfacl --modify=d:u:<username>:rwx /path/to/workspace

# Grant a project full access to the workspace folder
setfacl --modify=g:<projectname>:rwx /path/to/workspace

# Inherit these same rights to all newly created files and folders
setfacl --modify=d:g:<projectname>:rwx /path/to/workspace
```

If you already have files inside your workspace, remember to use the `-R` or
`--recursive` options to apply these ACL changes to all files.

If you want to remove a user's access then use `setfacl --remove=u:<username>
/path/to/workspace` and remember to also remove the default access rights
(`setfacl --remove=d:u:<username> /path/to/workspace`)

For more detailed management of the ACLs refer to the
[man pages](https://man.archlinux.org/man/setfacl.1).
