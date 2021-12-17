# JupyterLab Teaching Example

Setting up a Jupyter Lab Course involves additional steps, beyond JupyterHub, such as creating
course specific environments, and allowing participants to link and activate these environments during
the course. This page includes a work through of these additional steps, with best practice examples
for each part.

## Context

- The common situation described here is that one or several Jupyter Lab Notebooks
(`ipynb` files) are available and prepared. Students are supposed to open these notebooks
through the [ZIH JupyterHub](../access/jupyterhub.md) and work through them during a course.

- These notebooks are typically prepared for specific dependencies (Python packages) 
that need to be activated by participants in the course, when opening the notebooks.

- These environments can either be chosen based on the preconfigured ZIH conda environments,
or built in advance. We will focus on the custom environment approach here.

## Prerequisites

- A public git repository with notebook files (`ipynb`) and all other starting files required
  by participants. One option to host the repository is the [TU Chemnitz Gitlab](https://gitlab.hrz.tu-chemnitz.de/).
- A tested `environment.yml`, with specific conda dependencies, that is used for creating
  the environment. We will summarize steps below.
- A [HPC project](https://hpcprojekte.zih.tu-dresden.de/managers/) for teaching, 
  with students as registered participants
- For the tutor, a shell access to the HPC resources and project folder.

## Preparing the git repository

Notebooks need to be available in the repository as `.ipynb` files. 

??? "Tracking with Jupytext"
    Version tracking of `.ipynb` in git can be improved with
    [Jupytext](https://jupytext.readthedocs.io/en/latest/).
    Jupytext will provide Markdown (`.md`) and Python (`.py`)
    conversions of Notebooks on the fly, next to `.ipynb`. 
    
    Tracking these files will provide a cleaner git history. A 
    further advantage is that Python notebook versions can be imported, 
    allowing to split larger notebooks into smaller ones, based on 
    chained imports. 
    
    However, `ipynb` files need still to be made available 
    in the repository, since Jupytext is not installed in the base 
    JupyterHub environment at the ZIH.
    
A basic structured git repository could look like this.

```output
.
├─.git
├─notebooks
├───01_intro.ipynb
├───02_part1.ipynb
├───02_part2.ipynb
├─.gitignore
├─environment.yml
└─Readme.md
```

**1. Creating a custom conda environment**

There are several ways to [create conda environments](../../software/python_virtual_environments/#conda-virtual-environment).

For preparing a custom environment for a Jupyter Lab course,
all participants will need to have read-access to this environment.
This is best done by storing the conda environment in the project
folder (e.g. `/projects/p_lv_jupyter_course/`).

Shown below is the process to prepare this environment from a `environment.yml`.

**2. Clone the repository**

First connect to taurus and clone the repository to a user folder in `/home/`.

```bash
git clone git@gitlab.hrz.tu-chemnitz.de:zih/username/jupyterlab_course.git
cd jupyterlab_course
```

**3. Prepare the `environment.yml`**

First, have a look a the [conda docs](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html?highlight=environment.yml#create-env-file-manually)
that describe the environment.yml syntax.

An example course environment.yml could be:
```yml
name: workshop_env
channels:
  - conda-forge
  - defaults
dependencies:
  - python>=3.7
  - pip
  - colorcet
  - 'geoviews-core=1.8.1'
  - 'ipywidgets=7.6.*'
  - geopandas
  - hvplot
  - pyepsg
  - python-dotenv
  - 'shapely=1.7.1'
  - pip:
    - python-hll
```

After specifying the `name`, the conda 
[channel priority](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/channels.html) is defined. 
In the example above, packages will be first installed from the `conda-forge` channel, and if not found, 
from the `default` Anaconda channel.

Below, dependencies can be specified. Optionally, <abbr title="Pinning is a process that 
allows you to remain on a stable release while grabbing packages from a more recent version.">
pinning</abbr> can be used to delimit the packages installed to compatible package versions.

Finally, packages not available on conda can be specified (indented) below `- pip:`

**4. Re-create the environment in the user home folder**

The `/project` file system can be slow to write. It is
therefore advised to create the environment in the user's home
folder first, and then move the environment to the
`/project` partition using the [Data Mover Tools](../../data_transfer/datamover/)

!!! note
    There is a time limit of `5` Minutes for commands directly
    issued on Taurus. It is therefore adviced to create a job
    for the conda environment installation.

Create an interactive job shell.
```bash
srun --account=p_lv_jupyter_course \
    --pty --ntasks=1 --cpus-per-task=4 \
    --time=1:00:00 --mem-per-cpu=1700 bash -l
```

```output
> srun: job xxxxxxxx queued and waiting for resources
> srun: job xxxxxxxx has been allocated resources
```

Create the environment in your user home folder. This uses the `--prefix` flag to
override the default location of new environments (see [the docs](https://docs.conda.io/projects/conda/en/latest/commands/create.html#Target%20Environment%20Specification)).

```bash
mkdir /home/$USER/workshop_env
module load Anaconda3
conda config --set channel_priority strict
conda env create \
    --prefix /home/$USER/workshop_env \
    --file /$USER/jupyterlab_course/environment.yml \
    --quiet
```

This may take a while. Once the environment is created, 
logout from the job (<kbd>CTRL+D</kbd>) and test activation.
```bash
source /sw/installed/Anaconda3/2019.03/bin/activate ~/workshop_env
```

If successful, move the environment to the central course
project folder on `/projects` using the [Data Mover Tools](../../data_transfer/datamover/).

```bash
dtmv /home/$USER/workshop_env /projects/jupyterlab_course/.
```

The process can be inspected using `squeue`.
```
squeue -u $USER
```

Test the activation from the central `/projects` filesystem.

```bash
source /sw/installed/Anaconda3/2019.03/bin/activate /projects/jupyterlab_course/workshop_env
```

## Prepare the spawn link

Have a look at the instructions to prepare 
[a custom spawn link in combination with the git-pull feature](../jupyterhub_for_teaching/#combination-of-quickstart-and-git-pull-feature).

## Preparing activation of the custom environment in notebooks

When students open the notebooks (e.g.) through a Spawn Link that pulls the Git files 
and notebooks from our repository, the conda central environment must be linked and activated
first.

This can be done inside the first notebook using a shell command (`.sh`).

Create a file called `activate_workshop_env.sh` in your repository.

In the file, instructions are given to install the `ipykernel` to the user-folder,
linking the central `workshop_env` to the ZIH JupyterLab.

```sh
/projects/jupyterlab_course/workshop_env/bin/python \
    -m ipykernel install \
    --user \
    --name workshop_env \
    --display-name="workshop_env"
```

The students will need to run this shell file, which can be done
in the first cell of the first notebook (e.g. inside `01_intro.ipynb`).

In a code cell in `01_intro.ipynb`, add:
```bash
!cd .. && sh activate_workshop_env.sh
```

When students run this file, the following output signals a successful setup.

![Installed kernelspec](misc/kernelspec.png)
{: align="center"}

Afterwards, the `workshop_env` can be selected in the top-right corner of Jupyter Lab.

!!! note
    A few seconds may be needed until the environment becomes available in the list.

# Test spawn link and environment activation 

During testing, it may be necessary to reset the workspace
to the initial state. There are two steps involved

First, remove the cloned git repository in user home folder.

!!! warning
    Check carefully the syntax below, to avoid removing the wrong files.
    
```bash
cd ~
rm -rf ./jupyterlab_course.git
```

Second, the IPython Kernel must be unlinked from the user workshop_env.
```bash
jupyter kernelspec uninstall workshop_env
```

# Summary 

The following video shows an example of the process of opening the 
spawn link and activating the environment, from the students perspective.

<div align="center">
<video width="446" height="240" controls muted>
  <source src="../misc/startup_hub.webm" type="video/webm">
Your browser does not support the video tag.
</video>
</div>

!!! note
    - The spawn link may not work the first time a user logs in.
    
    - Students must be advised to _not_ click "Start My Server" or edit the form,
    if the server does not start automatically.
    
    - If the server does not start automatically, click (or copy & paste) the spawn link again.