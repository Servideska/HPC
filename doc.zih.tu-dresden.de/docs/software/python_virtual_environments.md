# Python Virtual Environments

Virtual environments allow users to install additional Python packages and
create an isolated run-time environment. We recommend using `virtualenv` for
this purpose. In your virtual environment, you can use packages from the
[modules list](modules.md) or if you didn't find what you need you can install
required packages with the command: `pip install`. With the command
`pip freeze`, you can see a list of all installed packages and their versions.

There are two methods of how to work with virtual environments on ZIH systems:

1. **virtualenv** is a standard Python tool to create isolated Python
environments. It is the preferred interface for managing installations and
virtual environments on ZIH system and part of the Python modules.

2. **conda** is an alternative method for managing installations and
virtual environments on ZIH system. conda is an open-source package
management system and environment management system from Anaconda. The
conda manager is included in all versions of Anaconda and Miniconda.

!!! warning

    Keep in mind that you **cannot** use virtualenv for working
    with the virtual environments previously created with conda tool and
    vice versa! Prefer virtualenv whenever possible.

## Python Virtual Environment

This example shows how to start working with **virtualenv** and Python virtual
environment (using the module system).

!!! hint

    We recommend to use [workspaces](../data_lifecycle/workspaces.md) for your
    virtual environments.

At first, we check available Python modules and load the preferred version:

```console
marie@compute$ module avail Python    #Check the available modules with Python
[...]
marie@compute$ module load Python    #Load default Python
Module Python/3.7 2-GCCcore-8.2.0 with 10 dependencies loaded
marie@compute$ which python    #Check which python are you using
/sw/installed/Python/3.7.2-GCCcore-8.2.0/bin/python
```

Then create the virtual environment and activate it.

```console
marie@compute$ ws_allocate -F scratch python_virtual_environment 1
Info: creating workspace.
/scratch/ws/1/python_virtual_environment
[...]
marie@compute$ virtualenv --system-site-packages /scratch/ws/1/python_virtual_environment/env  #Create virtual environment
[...]
marie@compute$ source /scratch/ws/1/python_virtual_environment/env/bin/activate    #Activate virtual environment. Example output: (env) bash-4.2$
```

Now you can work in this isolated environment, without interfering with other
tasks running on the system. Note that the inscription (env) at the beginning of
each line represents that you are in the virtual environment. You can deactivate
the environment as follows:

```console
(env) marie@compute$ deactivate    #Leave the virtual environment
```

??? example

    This is an example on partition Alpha. The example creates a conda virtual environment, and
    installs the package `torchvision` with conda.
    ```console
    marie@login$ srun --partition=alpha-interactive --nodes=1 --gres=gpu:1 --time=01:00:00 --pty bash
    marie@alpha$ ws_allocate -F scratch my_python_virtualenv 100    # use a workspace for the environment
    marie@alpha$ cd /scratch/ws/1/marie-my_python_virtualenv
    marie@alpha$ module load modenv/hiera GCC/10.2.0 CUDA/11.1.1 OpenMPI/4.0.5 PyTorch/1.9.0
    Module GCC/10.2.0, CUDA/11.1.1, OpenMPI/4.0.5, PyTorch/1.9.0 and 54 dependencies loaded.
    marie@alpha$ which python
    /sw/installed/Python/3.8.6-GCCcore-10.2.0/bin/python
    marie@alpha$ pip list
    [...]
    marie@alpha$ virtualenv --system-site-packages my-torch-env
    created virtual environment CPython3.8.6.final.0-64 in 42960ms
    creator CPython3Posix(dest=[...]/my-torch-env, clear=False, global=True)
    seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=~/.local/share/virtualenv)
        added seed packages: pip==21.1.3, setuptools==57.2.0, wheel==0.36.2
    activators BashActivator,CShellActivator,FishActivator,PowerShellActivator,PythonActivator,XonshActivator
    marie@alpha$ source my-torch-env/bin/activate
    (my-torch-env) marie@alpha$ pip install torchvision==0.10.0
    [...]
    Installing collected packages: torchvision==0.10.0
    Successfully installed torchvision-0.10.0
    [...]
    (my-torch-env) marie@alpha$ python -c "import torchvision; print(torchvision.__version__)"
    0.10.0+cu102
    (my-torch-env) marie@alpha$ deactivate
    ```

### Persistence of Python Virtual Environment

To persist a virtualenv, you can store the names and versions of installed
packages in a file. Then you can restore this virtualenv by installing the
packages from this file. Use the `pip freeze` command for storing:

```console
(env) marie@compute$ pip freeze > requirements.txt    #Store the currently installed packages
```

In order to recreate python virtual environment, use the `pip install` command to install the
packages from the file:

```console
marie@compute$ module load Python    #Load default Python
[...]
marie@compute$ virtualenv --system-site-packages /scratch/ws/1/python_virtual_environment/env_post  #Create virtual environment
[...]
marie@compute$ source /scratch/ws/1/python_virtual_environment/env/bin/activate    #Activate virtual environment. Example output: (env_post) bash-4.2$
(env_post) marie@compute$ pip install -r requirements.txt    #Install packages from the created requirements.txt file
```

## Conda Virtual Environment

**Prerequisite:** Before working with conda, your shell needs to be configured
initially. Therefore login to the ZIH system, load the Anaconda module and run
`sh $EBROOTANACONDA3/etc/profile.d/conda.sh`. Note that changes take effect after closing and
re-opening your shell.

!!! warning
    We recommend to **not** use the `conda init` command, since it may cause unexpected behaviour
    when working with the ZIH system.

??? example

    ```console
    marie@compute$ module load Anaconda3    #load Anaconda module
    Module Anaconda3/2019.03 loaded.
    marie@compute$ sh $EBROOTANACONDA3/etc/profile.d/conda.sh    #init conda
    [...]
    ```

This example shows how to start working with **conda** and virtual environment
(with using module system). At first, we use an interactive job and create a
directory for the conda virtual environment:

```console
marie@compute$ ws_allocate -F scratch conda_virtual_environment 1
Info: creating workspace.
/scratch/ws/1/conda_virtual_environment
[...]
```

Then, we load Anaconda, create an environment in our directory and activate the
environment:

```console
marie@compute$ module load Anaconda3    #load Anaconda module
marie@compute$ conda create --prefix /scratch/ws/1/conda_virtual_environment/conda-env python=3.6    #create virtual environment with Python version 3.6
marie@compute$ conda activate /scratch/ws/1/conda_virtual_environment/conda-env    #activate conda-env virtual environment
```

Now you can work in this isolated environment, without interfering with other
tasks running on the system. Note that the inscription (conda-env) at the
beginning of each line represents that you are in the virtual environment. You
can deactivate the conda environment as follows:

```console
(conda-env) marie@compute$ conda deactivate    #Leave the virtual environment
```

!!! warning
    When installing conda packages via `conda install`, ensure to have enough main memory requested
    in your job allocation.

!!! hint
    We do not recommend to use conda environments together with EasyBuild modules due to
    dependency conflicts. Nevertheless, if you need EasyBuild modules, consider installing conda
    packages via `conda install --no-deps [...]` to prevent conda from installing dependencies.

??? example

    This is an example on partition Alpha. The example creates a conda virtual environment, and
    installs the package `torchvision` with conda.
    ```console
    marie@login$ srun --partition=alpha-interactive --nodes=1 --gres=gpu:1 --time=01:00:00 --pty bash
    marie@alpha$ ws_allocate -F scratch my_conda_virtualenv 100    # use a workspace for the environment
    marie@alpha$ cd /scratch/ws/1/marie-my_conda_virtualenv
    marie@alpha$ module load Anaconda3
    Module Anaconda3/2021.11 loaded.
    marie@alpha$ conda create --prefix my-torch-env python=3.8
    Collecting package metadata (current_repodata.json): done
    Solving environment: done
    [...]
    Proceed ([y]/n)? y
    [...]
    marie@alpha$ conda activate my-torch-env
    (my-torch-env) marie@alpha$ conda install -c pytorch torchvision
    Collecting package metadata (current_repodata.json): done
    [...]
    Preparing transaction: done
    Verifying transaction: done
    (my-torch-env) marie@alpha$ which python    # ensure to use the correct Python
    (my-torch-env) marie@alpha$ python -c "import torchvision; print(torchvision.__version__)"
    0.12.0
    (my-torch-env) marie@alpha$ conda deactivate
    ```

### Persistence of Conda Virtual Environment

To persist a conda virtual environment, you can define an `environments.yml`
file. Have a look a the [conda docs](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html?highlight=environment.yml#create-env-file-manually)
for a description of the syntax. See an example for the `environments.yml` file
below.

??? example
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

After specifying the `name`, the conda [channel priority](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/channels.html)
is defined. In the example above, packages will be first installed from the
`conda-forge` channel, and if not found, from the `default` Anaconda channel.

Below, dependencies can be specified. Optionally, <abbr title="Pinning is a
process that allows you to remain on a stable release while grabbing packages
from a more recent version."> pinning</abbr> can be used to delimit the packages
installed to compatible package versions.

Finally, packages not available on conda can be specified (indented) below
`- pip:`

Recreate the conda virtual environment with the packages from the created
`environment.yml` file:

```console
marie@compute$ mkdir workshop_env    #Create directory for environment
marie@compute$ module load Anaconda3    #Load Anaconda
marie@compute$ conda config --set channel_priority strict
marie@compute$ conda env create --prefix workshop_env --file environment.yml    #Create conda env in directory with packages from environment.yml file
```
