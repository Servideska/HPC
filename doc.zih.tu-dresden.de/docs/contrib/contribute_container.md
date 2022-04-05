# Contribute via Local Clone

In the following, it is outlined how to contribute to the
[HPC documentation](https://doc.zih.tu-dresden.de/) of
[TU Dresden/ZIH](https://tu-dresden.de/zih/) via a local clone of the Git repository. Although, this
document might seem very long describing complex steps, contributing is quite easy - trust us.

## Initial Setup of your Local Clone

Please follow this standard Git procedure for working with a local clone:

1. Fork the project on
[https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/hpc-compendium)
or request access to the project.
1. Change to a local (unencrypted) filesystem. (We have seen problems running the container on an
ecryptfs filesystem. So you might want to use e.g. `/tmp` as the start directory.)
1. Create a new directory, e.g. with `mkdir hpc-wiki`
1. Change into the new directory, e.g. `cd hpc-wiki`
1. Clone the Git repository:
    1. `git clone git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git .` (don't forget the
dot)
    1. if you forked the repository, use
`git clone git@gitlab.hrz.tu-chemnitz.de:<YOUR_LOGIN>/hpc-compendium.git .` (don't forget the dot).
Add the original repository as a so-called remote:
`git remote add upstream-zih git@gitlab.hrz.tu-chemnitz.de:zih/hpcsupport/hpc-compendium.git`

## Working with your Local Clone

1. Whenever you start working on an issue, first make sure that your local data is up to date:
    1. `git checkout preview`
    1. `git pull origin preview`
    1. `git pull upstream-zih preview` (only required when you forked the project)
1. Create a new feature branch for you to work in. Ideally, name it like the file you want to
modify or the issue you want to work on, e.g.:
`git checkout -b 174-check-contribution-documentation` for issue 174 with title "Check contribution
documentation". (If you are uncertain about the name of a file, please look into `mkdocs.yaml`.)
1. Improve the documentation with your preferred editor, i.e. add new files and correct mistakes.
1. Use `git add <FILE>` to select your improvements for the next commit.
1. Commit the changes with `git commit -m "<DESCRIPTION>"`. The description should be a meaningful
description of your changes. If you work on an issue, please also add "Closes 174" (for issue 174).
1. Push the local changes to the GitLab server, e.g. with
`git push origin 174-check-contribution-documentation`.
1. As an output you get a link to create a merge request against the preview branch.
1. When the merge request is created, a continuous integration (CI) pipeline automatically checks
your contributions.

When you contribute, please follow our [content rules](content_rules.md) to make incorporating your
changes easy. We also check these rules via continuous integration checks and/or reviews.
You can find the details and commands to preview your changes and apply checks in the next sections.

## Tools to Ensure Quality

Assuming you already have a working Docker installation and have cloned the repository as mentioned
above, a few more steps are necessary.

Build the docker image. This might take a bit longer, as `mkdocs` and other necessary software
needs to be downloaded, but you have to run it only once in a while.
Building a container could be done with the following steps:

```bash
cd hpc-wiki
doc.zih.tu-dresden.de/util/download-newest-mermaid.js.sh
docker build -t hpc-compendium .
```

To avoid a lot of retyping, use the following in your shell:

```bash
alias wikiscript="docker run --name=hpc-compendium --rm -w /docs --mount src=$PWD,target=/docs,type=bind hpc-compendium"
alias wiki="docker run --name=hpc-compendium -p 8000:8000 --rm -w /docs --mount src=$PWD/doc.zih.tu-dresden.de,target=/docs,type=bind hpc-compendium"
```

## Working with the Docker Container

Here is a suggestion of a workflow which might be suitable for you.

### Start the Local Web Server

The command(s) to start the dockerized web server is this:

```bash
wiki mkdocs serve -a 0.0.0.0:8000
```

You can view the documentation via `http://localhost:8000` in your browser, now.

!!! note

    You can keep the local web server running in this shell to always have the opportunity to see
    the result of your changes in the browser. Simply open another terminal window for other
    commands.
    If you cannot see the page in your browser, check if you can get the URL for your browser's
    address bar from a different terminal window:

    ```bash
    echo http://$(docker inspect -f "{{.NetworkSettings.IPAddress}}" $(docker ps -qf "name=hpc-compendium")):8000
    ```

You can now update the contents in you preferred editor. The running container automatically takes
care of file changes and rebuilds the documentation whenever you save a file.

With the details described below, it will then be easy to follow the guidelines for local
correctness checks before submitting your changes and requesting the merge.

### Run the Proposed Checks Inside Container

In our continuous integration (CI) pipeline, a merge request triggers the automated check of

* correct links,
* correct spelling,
* correct text format.

These checks ensure a high quality and consistency of the content and follow our
[content rules](content_rules.md). If one of them fails, the merge request will not be accepted. To
prevent this, you can run these checks locally and adapt your files accordingly.

You are now ready to use the different checks, however we suggest to try the pre-commit hook.

#### Pre-commit Git Hook

We have several checks on the markdown sources to ensure for a consistent and high quality of the
documentation. We recommend to automatically run checks whenever you try to commit a change. In this
case, failing checks prevent commits (unless you use option `--no-verify`). This can be accomplished
by adding a pre-commit hook to your local clone of the repository. The following code snippet shows
how to do that:

```bash
cp doc.zih.tu-dresden.de/util/pre-commit .git/hooks/
```

!!! note
    The pre-commit hook only works, if you can use docker without using `sudo`. If this is not
    already the case, use the command `adduser $USER docker` to enable docker commands without
    `sudo` for the current user. Restart the docker daemons afterwards.

Read on if you want to run a specific check.

#### Linter

If you want to check whether the markdown files are formatted properly, use the following command:

```bash
wiki markdownlint docs
```

#### Spell Checker

For spell-checking a single file, e.g.
`doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```bash
wikiscript doc.zih.tu-dresden.de/util/check-spelling.sh doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md
```

For spell-checking all files, use:

```bash
wikiscript doc.zih.tu-dresden.de/util/check-spelling.sh -a
```

This outputs all words of all files that are unknown to the spell checker.
To let the spell checker "know" a word, append it to
`doc.zih.tu-dresden.de/wordlist.aspell`.

#### Check Pages Structure

The script `util/check-no-floating.sh` first checks the hierarchy depth of the pages structure and
the second check tests if every markdown file is included in the navigation section of the
`mkdocs.yaml` file. Invoke it as follows:

```bash
wikiscript doc.zih.tu-dresden.de/util/check-no-floating.sh doc.zih.tu-dresden.de
```

#### Link Checker

!!! quote "Unknown programmer"

    No one likes dead links.

Therefore, we check the internal and external links within the markdown source files. To check a
single file, e.g.  `doc.zih.tu-dresden.de/docs/software/big_data_frameworks.md`, use:

```bash
wikiscript doc.zih.tu-dresden.de/util/check-links.sh docs/software/big_data_frameworks.md
```

The script can also check all modified files, i.e., markdown files which are part of the repository
and different to the `main` branch. Use this script before committing your changes to make sure
your commit passes the CI/CD pipeline:

```bash
wikiscript doc.zih.tu-dresden.de/util/check-links.sh
```

To check all markdown file, which may take a while and give a lot of output, use:

```bash
wikiscript doc.zih.tu-dresden.de/util/check-links.sh -a
```
