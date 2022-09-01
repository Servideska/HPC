# Slurm Job Generator

<html lang="en-us">
  <head>
    <meta charset="utf-8">
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0"> -->
    <title>Slurm-Job-Generator</title>
    <!-- <link type="text/css" href="../misc/style.css" rel="stylesheet"> -->
    <!-- <script src="jquery-3.6.0.min.js"> </script> -->
  </head>

  <body>
    <div class="header">
      <label class="header">TU Dresden Slurm Job Generator</label>
    </div>
    <button type="button" class="collapsible">General</button>
    <div class="content">
      <div class="row">
        <label class="cell-name">Job name (<tt>-J, --job-name</tt>) </label>
        <div class="cell-tooltip">
          <img id="job-name-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="job-name" class="cell-input" type="text">
      </div>
      <div class="row">
        <label class="cell-name">Project (<tt>-A, --account</tt>)</label>
        <div class="cell-tooltip">
          <img id="account-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="account" class="cell-input" type="text">
      </div>
      <div class="row">
        <label class="cell-name">Email (<tt>--mail-user, --mail-type</tt>)</label>
        <div class="cell-tooltip">
          <img id="mail-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <div class="cell-input">
          <input id="mail" class="mail" type="mail">

          <input id="begin" type="checkbox">
          <lable for="begin">Begin</lable>
          <input id="end" type="checkbox">
          <lable for="end">End</lable>
          <input id="fail" type="checkbox">
          <lable for="fail">Fail</lable>
        </div>
      </div>
    </div>

    <button type="button" class="collapsible">Resources</button>
    <div class="content">
      <div class="partition-input">
        <div class="row">
          <label class="cell-name">Time limit (<tt>-t, --time</tt>)</label>
          <div class="cell-tooltip">
            <img id="time-info" class="info-img" src="../misc/info.png" title="days-hours:minutes:seconds">
          </div>
          <input id="time" class="cell-input" type="text" placeholder="00-00:00:00">
          <label id="time-text" class="limits cell-input"></label>
        </div>
        <div class="row">
          <label class="cell-name">Partition (<tt>-p, --partition</tt>)</label>
          <div class="cell-tooltip">
            <img id="partition-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <select id="partition" class="cell-input"></select>
        </div>
        <div class="row">
          <label class="cell-name">Nodes (<tt>-N, --nodes</tt>)</label>
          <div class="cell-tooltip">
            <img id="nodes-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <input id="nodes" class="cell-input" type="number">
          <label id="nodes-text" class="limits cell-input"></label>
        </div>
        <div class="row">
          <label class="cell-name">Tasks (<tt>-n, --ntasks</tt>)</label>
          <div class="cell-tooltip">
            <img id="tasks-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <input id="tasks" class="cell-input" type="number">
          <label id="tasks-text" class="limits cell-input"></label>
        </div>
        <div class="row">
          <label class="cell-name">Tasks/node</label>
          <div class="cell-tooltip">
            <img id="tasks/node-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <input id="tasks/node" class="cell-input" type="number">
          <label id="tasks/node-text" class="limits cell-input"></label>
        </div>
        <div class="row">
          <label class="cell-name">CPUs per task (<tt>-c, --cpus-per-task</tt>)</label>
          <div class="cell-tooltip">
            <img id="cpus-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <input id="cpus" class="cell-input" type="number">
          <label id="cpus-text" class="limits cell-input"></label>
        </div>
        <div id="div-thread" class="row">
          <span class="cell-name"></span>
          <div class="cell-tooltip">
            <img id="nomultithread-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <div class="cell-input">
            <input id="nomultithread" class="cell" type="checkbox">
            <lable for="nomultithread">No Multithreading</lable>
          </div>
        </div>
        <div id="div-gpu" class="row">
          <label class="cell-name">GPUs per node (<tt>--gpus-per-node</tt>)</label>
          <div class="cell-tooltip">
            <img id="gpus-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <input id="gpus" class="cell-input" type="number">
          <label id="gpus-text" class="limits cell-input"></label>
        </div>
        <div id="div-gpu/task" class="row">
          <label class="cell-name">GPUs per task (<tt>--gpus-per-task</tt>)</label>
          <div class="cell-tooltip">
            <img id="gpus/task-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <input id="gpus/task" class="cell-input" type="number">
          <label id="gpus/task-text" class="limits cell-input"></label>
        </div>
        <div class="row">
          <label class="cell-name">Memory per CPU (<tt>--mem-per-cpu</tt>)</label>
          <div class="cell-tooltip">
            <img id="mem-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <div class="cell-input">
            <input id="mem" type="number">
            <select id="byte">
              <option value="M" title="placeholder" selected="selected">MiB</option>
              <option value="G" title="placeholder">GiB</option>
            </select>
            <label id="mem-text" class="limits"></label>
          </div>
        </div>
        <div class="row">
          <span class="cell-name"></span>
          <div class="cell-tooltip">
            <img id="exclusive-info" class="info-img" src="../misc/info.png" title="help">
          </div>
          <div class="cell-input">
            <input id="exclusive" type="checkbox">
            <lable for="exclusive">Exclusive (<tt>--exclusive</tt>)</lable>
          </div>
        </div>
      </div>
      <div class="partition-info">
        <pre id="info-panel" class="info-pre"></pre>
      </div>
    </div>

    <button type="button" class="collapsible">Files</button>
    <div class="content">
      <div class="row">
        <label class="cell-name">Executable</label>
        <div class="cell-tooltip">
          <img id="executable-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="executable" class="cell-input executable" type="text">
      </div>
      <div class="row">
        <span class="cell-name"></span>
        <div class="cell-tooltip">
          <img id="one-output-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <div class="cell-input">
          <input id="one-output" type="checkbox">
          <lable for="one-output">just one output file</lable>
        </div>
      </div>
      <div class="row">
        <label class="cell-name">Output file (<tt>-o, --output</tt>) </label>
        <div class="cell-tooltip">
          <img id="output-file-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="output-file" class="cell-input" type="text">
      </div>
      <div id="err-div" class="row">
        <label class="cell-name">Error file (<tt>-e, --error</tt>) </label>
        <div class="cell-tooltip">
          <img id="error-file-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="error-file" class="cell-input" type="text">
      </div>
    </div>

    <button type="button" class="collapsible">Advanced</button>
    <div class="content">
      <div class="row">
        <label class="cell-name">Array (<tt>-a, --array</tt>)</label>
        <div class="cell-tooltip">
          <img id="array-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="array" class="cell-input" type="text" placeholder="1-5">
      </div>
      <div class="row">
        <label class="cell-name">Dependency (<tt>-d, --dependency</tt>)</label>
        <div class="cell-tooltip">
          <img id="dependency-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <div class="cell-input">
          <select id="type-depend">
            <option value="none" title="placeholder" selected="selected"></option>
            <option value="after" title="placeholder">after</option>
            <option value="afterany" title="placeholder">afterany</option>
            <option value="afterburstbuffer" title="placeholder">afterburstbuffer</option>
            <option value="aftercorr" title="placeholder">aftercorr</option>
            <option value="afternotok" title="placeholder">afternotok</option>
            <option value="afterok" title="placeholder">afterok</option>
            <option value="singleton" title="placeholder">singleton</option>
          </select>
          <input id="jobid" class="hidden" type="text" placeholder="jobid">
        </div>
      </div>
    </div>

    <button type="button" class="collapsible">Workspace</button>
    <div class="content">
      <div class="row">
        <span class="cell-name"></span>
        <div class="cell-tooltip">
          <img id="ws-alloc-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <div class="cell-input">
          <input id="check-workspace" type="checkbox">
          <label for="check-workspace">Allocate a workspace</label>
        </div>
      </div>
      <div class="row hidden">
        <label class="cell-name">Filesystem</label>
        <div class="cell-tooltip">
          <img id="ws-filesystem-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <select id="workspace-filesystem" class="cell-input"></select>
      </div>
      <div class="row hidden">
        <label class="cell-name">Name</label>
        <div class="cell-tooltip">
          <img id="ws-name-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <input id="name" class="cell-input" type="text">
      </div>
      <div class="row hidden">
        <label class="cell-name">Duration</label>
        <div class="cell-tooltip">
          <img id="ws-duration-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <div class="cell-input">
          <input id="duration" type="number" min="1">
          <label id="duration-text" class="limits"></label>
        </div>
      </div>
      <div class="row hidden">
        <span class="cell-name"></span>
        <div class="cell-tooltip">
          <img id="ws-delete-info" class="info-img" src="../misc/info.png" title="help">
        </div>
        <div class="cell-input">
          <input id="check-delete" type="checkbox">
          <label for="check-delete">Delete after job</label>
        </div>
      </div>
    </div>

    <div class="output">
      <button id="generate-button" class="output" type="button">Generate</button>
      <div class="code">
        <label id="output-text" class="limits">Output requires update</label>
        <pre id="output"></pre>
      </div>
      <button id="copy-button" class="output" type="button">Copy to Clipboard</button>
      <button id="save-button" class="output" type="button">Save as File</button>
    </div>

    <script>
      // dictionary containing the limits for the different partitions
      const limitsPartition = {
        'gpu2' : gpu2 = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 12,
          'threads' : 1,
          'nodes' : 59,
          'cores/node' : 24,
          'ht_cores/node' : 24,
          'mem/core' : 2583,
          'mem/node' : 62000,
          'gpu/node' : 4
        },
        'haswell' : haswell = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 12,
          'threads' : 1,
          'nodes' : 1399,
          'cores/node' : 24,
          'ht_cores/node' : 24,
          'mem/core' : 2541,
          'mem/node' : 61000,
          'gpu/node' : 0
        },
        'haswell64' : haswell64 = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 12,
          'threads' : 1,
          'nodes' : 1266,
          'cores/node' : 24,
          'ht_cores/node' : 24,
          'mem/core' : 2541,
          'mem/node' : 61000,
          'gpu/node' : 0
        },
        'haswell128' : haswell128 = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 12,
          'threads' : 1,
          'nodes' : 84,
          'cores/node' : 24,
          'ht_cores/node' : 24,
          'mem/core' : 5250,
          'mem/node' : 126000,
          'gpu/node' : 0
        },
        'haswell256' : haswell256 = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 12,
          'threads' : 1,
          'nodes' : 44,
          'cores/node' : 24,
          'ht_cores/node' : 24,
          'mem/core' : 10583,
          'mem/node' : 254000,
          'gpu/node' : 0
        },
        'haswell64ht' : haswell64ht = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 12,
          'threads' : 2,
          'nodes' : 18,
          'cores/node' : 24,
          'ht_cores/node' : 48,
          'mem/core' : 1270,
          'mem/node' : 61000,
          'gpu/node' : 0
        },
        'smp2' : smp2 = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 4,
          'cpu/socket' : 14,
          'threads' : 1,
          'nodes' : 5,
          'cores/node' : 56,
          'ht_cores/node' : 56,
          'mem/core' : 36500,
          'mem/node' : 2044000,
          'gpu/node' : 0
        },
        'broadwell' : broadwell = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 14,
          'threads' : 1,
          'nodes' : 32,
          'cores/node' : 28,
          'ht_cores/node' : 28,
          'mem/core' : 2214,
          'mem/node' : 62000,
          'gpu/node' : 0
        },
        'ifm' : ifm = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 60,
          'Sockets' : 2,
          'cpu/socket' : 8,
          'threads' : 2,
          'nodes' : 1,
          'cores/node' : 16,
          'ht_cores/node' : 32,
          'mem/core' : 12000,
          'mem/node' : 384000,
          'gpu/node' : 1
        },
        'hpdlf' : hpdlf = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 60,
          'Sockets' : 2,
          'cpu/socket' : 6,
          'threads' : 1,
          'nodes' : 14,
          'cores/node' : 12,
          'ht_cores/node' : 12,
          'mem/core' : 7916,
          'mem/node' : 95000,
          'gpu/node' : 3
        },
        'ml' : ml = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 60,
          'Sockets' : 2,
          'cpu/socket' : 22,
          'threads' : 4,
          'nodes' : 30,
          'cores/node' : 44,
          'ht_cores/node' : 176,
          'mem/core' : 1443,
          'mem/node' : 254000,
          'gpu/node' : 6
        },
        'romeo' : romeo = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 64,
          'threads' : 2,
          'nodes' : 190,
          'cores/node' : 128,
          'ht_cores/node' : 256,
          'mem/core' : 1972,
          'mem/node' : 505000,
          'gpu/node' : 0
        },
        'julia' : julia = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 32,
          'cpu/socket' : 28,
          'threads' : 1,
          'nodes' : 1,
          'cores/node' : 896,
          'ht_cores/node' : 896,
          'mem/core' : 54006,
          'mem/node' : 48390000,
          'gpu/node' : 0
        },
        'alpha' : alpha = {
          'MaxTime' : 'INFINITE',
          'DefaultTime' : 480,
          'Sockets' : 2,
          'cpu/socket' : 24,
          'threads' : 2,
          'nodes' : 32,
          'cores/node' : 48,
          'ht_cores/node' : 96,
          'mem/core' : 10312,
          'mem/node' : 990000,
          'gpu/node' : 8
        }
      };

      // dictionary containing the limits for the different workspaces
      const limitsWorkspace = {
        'scratch' : scratch = {
          'duration' : 100,
          'extensions' : 10
        },
        'warm_archive' : warm_archive = {
          'duration' : 365,
          'extensions' : 2
        },
        'ssd' : ssd = {
          'duration' : 30,
          'extensions' : 2
        },
        'beegfs' : beegfs = {
          'duration' : 30,
          'extensions' : 2
        }
      };

      // dictionary containing the texts and link for the info icons
      const info = {
        'job-name': {
          'text': 'Specify a name for the job allocation. The specified name will appear along with the job id number when querying running jobs on the system. (default: name of the job file)',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_job-name'
        },
        'account': {
          'text': 'Charge resources used by this job to specified project.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_account'
        },
        'mail': {
          'text': 'Specify which user is send a email notification of state changes as defined by --mail-type.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_mail-user'
        },
        'time': {
          'text': 'Set the total run time limit of the job allocation. When the time limit is reached, each task in each job step is sent SIGTERM followed by SIGKILL. The default time limit is the partition\'s default time limit. (currently only supports ddd-hh:mm:ss and hh:mm:ss)',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_time'
        },
        'partition': {
          'text': 'Request a specific partition for the resource allocation. If the job can use more than one partition, specify their names in a comma separate list and the one offering earliest initiation will be used with no regard given to the partition name ordering. (default: default paritition of the system)',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_partition'
        },
        'nodes': {
          'text': 'Request that number of nodes be allocated to this job.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_nodes'
        },
        'tasks': {
          'text': 'Request that many MPI tasks (default: one task per node)',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_ntasks'
        },
        'tasks/node': {
          'text': 'Allocate that many tasks per node.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_ntasks-per-node'
        },
        'cpus': {
          'text': 'Request that number of processors per MPI task. This is needed for multithreaded (e.g. OpenMP) jobs; typically <N> should be equal to OMP_NUM_THREADS',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_cpus-per-task'
        },
        'nomultithread': {
          'text': '[don\'t] use extra threads with in-core multi-threading which can benefit communication intensive applications.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_[no]multithread'
        },
        'gpus': {
          'text': 'help text for gpus',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_gpus'
        },
        'gpus/task': {
          'text': 'help text for gpus/task',
          'link': 'test'
        },
        'mem': {
          'text': 'Specify the real memory required per node.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_output'
        },
        'exclusive': {
          'text': 'The job allocation can not share nodes with other running job. Exclusive usage of compute nodes; you will be charged for all CPUs/cores on the node',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_exclusive'
        },
        'executable': {
          'text': 'help text for executable',
          'link': 'test'
        },
        'one-output': {
          'text': 'help text for one-output',
          'link': 'test'
        },
        'output-file': {
          'text': 'File to save all normal output (stdout) (default: slurm-%j.out)',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_output'
        },
        'error-file': {
          'text': 'File to save all error output (stderr) (default: slurm-%j.out)',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_error'
        },
        'array': {
          'text': 'help text for array',
          'link': 'test'
        },
        'dependency': {
          'text': 'help text for dependency',
          'link': 'test'
        },
        'ws-alloc': {
          'text': 'help text for allocate workspace',
          'link': 'test'
        },
        'ws-filesystem': {
          'text': 'help text for filesystem',
          'link': 'test'
        },
        'ws-name': {
          'text': 'help text for ws name',
          'link': 'test'
        },
        'ws-duration': {
          'text': 'help text for duration',
          'link': 'test'
        },
        'ws-delete': {
          'text': 'help text for delete workspace',
          'link': 'test'
        }
      };

      // dictionary for the max values
      var maxValues = {
        'nodes' : 1,
        'tasks' : 1,
        'tasks/node' : 1,
        'cpus' : 1,
        'gpus' : 0,
        'gpus/task' : 0,
        'mem' : 1,
        'duration': 1
      }

      // dictionary for the min values
      var minValues = {
        'nodes' : 1,
        'tasks' : 1,
        'tasks/node' : 1,
        'cpus' : 1,
        'gpus' : 0,
        'gpus/task' : 0,
        'mem' : 1,
        'duration': 1
      }

      /**
       *  Function to generate the output text
       */
      var generateOutput = function() {
        let outputText = document.getElementById('output')
        outputText.innerText = '#!/bin/bash\n';
        if (document.getElementById('job-name').value !== '') {
          outputText.innerText += '\n#SBATCH --job-name=\"'
          + document.getElementById('job-name').value + '\"';
        }
        if (document.getElementById('array').value !== '') {
          outputText.innerText += '\n#SBATCH --array='
          + document.getElementById('array').value;
        }
        if (document.getElementById('time').value !== '') {
          outputText.innerText += '\n#SBATCH --time='
          + document.getElementById('time').value;
        } else {
          outputText.innerText += '\n#SBATCH --time='
          + limitsPartition[document.getElementById('partition').value]['DefaultTime'];
        }
        outputText.innerText += '\n#SBATCH --partition='
        + document.getElementById('partition').value;
        if (document.getElementById('nodes').value !== '') {
          outputText.innerText += '\n#SBATCH --nodes=' + document.getElementById('nodes').value;
        }
        if (document.getElementById('tasks').value !== '') {
          outputText.innerText += '\n#SBATCH --ntasks='
          + document.getElementById('tasks').value;
        }
        if (document.getElementById('tasks/node').value !== '' && document.getElementById('gpus').value === '') {
          outputText.innerText += '\n#SBATCH --ntasks-per-node='
          + document.getElementById('tasks/node').value;
        } else if (document.getElementById('tasks/node').value !== '') {
          outputText.innerText += '\n#SBATCH --mincpus='
          + document.getElementById('tasks/node').value;
        }
        if (document.getElementById('cpus').value !== '') {
          outputText.innerText += '\n#SBATCH --cpus-per-task='
          + document.getElementById('cpus').value;
        }
        if (document.getElementById('gpus').value !== '') {
          outputText.innerText += '\n#SBATCH --gres=gpu:'
          + document.getElementById('gpus').value;
        }
        if (document.getElementById('gpus/task').value !== '') {
          outputText.innerText += '\n#SBATCH --gpus-per-task='
          + document.getElementById('gpus/task').value;
        }
        if (document.getElementById('mem').value !== '') {
          outputText.innerText += '\n#SBATCH --mem-per-cpu='
          + document.getElementById('mem').value
          + document.getElementById('byte').value;
        }
        if (document.getElementById('account').value !== '') {
          outputText.innerText += '\n#SBATCH --account=\"'
          + document.getElementById('account').value + '\"';
        }
        if (document.getElementById('mail').value !== '') {
          outputText.innerText += '\n#SBATCH --mail-user='
          + document.getElementById('mail').value;
          if (document.getElementById('begin').checked === true) {
            outputText.innerText += '\n#SBATCH --mail-type=BEGIN';
          }
          if (document.getElementById('end').checked === true) {
            outputText.innerText += '\n#SBATCH --mail-type=END';
          }
          if (document.getElementById('fail').checked === true) {
            outputText.innerText += '\n#SBATCH --mail-type=FAIL';
          }
        }
        if (document.getElementById('output-file').value !== '') {
          outputText.innerText += '\n#SBATCH --output='
          + document.getElementById('output-file').value;
        }
        if (document.getElementById('error-file').value !== '') {
          outputText.innerText += '\n#SBATCH --error='
          + document.getElementById('error-file').value;
        }
        if (document.getElementById('exclusive').checked === true) {
          outputText.innerText += '\n#SBATCH --exclusive';
        }
        if (document.getElementById('nomultithread').checked === true) {
          outputText.innerText += '\n#SBATCH --hint=nomultithread';
        }
        if (document.getElementById('type-depend').value !== 'none') {
          outputText.innerText += '\n#SBATCH --dependency='
          + document.getElementById('type-depend').value
          if (document.getElementById('type-depend').value !== 'singleton') {
            outputText.innerText += ':' + document.getElementById('jobid').value
          }
        }

        outputText.innerText += '\n\n# Setup computational environment, i.e, load desired modules';
        outputText.innerText += '\n# module purge';
        outputText.innerText += '\n# module load <module name>';
        outputText.innerText += '\n\n';

        if (document.getElementById('check-workspace').checked) {
          outputText.innerText += '\n# Allocate workspace as working directory';
          outputText.innerText += '\nWSNAME='
          + document.getElementById('name').value + '_$SLURM_JOB_ID';
          outputText.innerText += '\nexport WSDIR=$(ws_allocate -F '
          + document.getElementById('workspace-filesystem').value
          + ' -n $WSNAME -d '
          + document.getElementById('duration').value
          + ')';
          outputText.innerText += '\necho "Workspace: $WSDIR"';

          outputText.innerText += '\n# Check allocation';
          outputText.innerText += '\n[ -z "$WSDIR" ] && echo "Error: Cannot allocate workspace $WSNAME" && exit 1';

          outputText.innerText += '\n\n# Change to workspace';
          outputText.innerText += '\ncd $WSDIR';
        }

        if (document.getElementById('executable').value !== '') {
          outputText.innerText += '\n\n# Execute parallel application '
          outputText.innerText += '\nsrun '
          + document.getElementById('executable').value;
        } else {
          outputText.innerText += '\n\n# Execute parallel application '
          outputText.innerText += '\n# srun <file to execute>'
        }

        if (document.getElementById('check-workspace').checked && document.getElementById('check-delete').checked) {
          outputText.innerText += '\n\n# Save your results!'
          outputText.innerText += '\n# cp <results> <dest>'
          outputText.innerText += '\n\n# Clean up workspace'
          outputText.innerText += '\nif [ -d $WORK_SCRDIR ] && rm -rf $WSDIR/*';
          outputText.innerText += '\nws_release -F '
          + document.getElementById('workspace-filesystem').value
          + ' $WSDIR';
        }
      }

      /**
       * Proof if all values are correct, if yes it prints the output, else it highlights incorrect values
       */
      var proofValues = function() {
        let boolValues = true;
        // proof values and set/unset warnings
        // walltime
        let reArray = /^(([0-9]{1,3})-)?([0-9]{2}):[0-9]{2}:[0-9]{2}$/;
        if (!reArray.test(document.getElementById('time').value) && document.getElementById('time').value) {
          document.getElementById('time').style.backgroundColor = 'rgb(255, 121, 121)';
          boolValues = false;
        } else {
          document.getElementById('time').style.backgroundColor = '';
        }
        // proof multiple fields
        const fields = ['nodes', 'tasks', 'tasks/node', 'cpus', 'gpus', 'gpus/task', 'mem'];
        if (document.getElementById('check-workspace').checked === true) {
          fields.push('duration');
        }
        [].forEach.call(fields, function(field) {
          // remove all leading zeros
          document.getElementById(field).value = document.getElementById(field).value.replace(/^0+/, '');

          let element = document.getElementById(field);
          let elementText = document.getElementById(field + '-text');
          let value = Number(document.getElementById(field).value);
          let min = Number(minValues[field]);
          let max = Number(maxValues[field]);
          if (value >= min && value <= max || document.getElementById(field).value === '') {
            element.style.backgroundColor = '';
            elementText.style.display = 'none';
          } else {
            boolValues = false;
            element.style.backgroundColor = 'rgb(255, 121, 121)';
            elementText.style.display = 'inline';
          }
        })

        if (boolValues === true) {
          document.getElementById('output-text').style.display = 'none';
          generateOutput();
        } else {
          document.getElementById('output-text').style.display = 'block';
        }
      }

      // copy to clipboard
      document.getElementById('copy-button').addEventListener('click', function () {
        let code = document.getElementById('output');

        // select the text
        let range = document.createRange();
        range.selectNodeContents(code);
        let selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);

        // copy to clipboard
        navigator.clipboard.writeText(code.innerText);

        // remove selection
        selection.removeAllRanges();
      });

      // save as file
      document.getElementById('save-button').addEventListener('click', function () {
        // create file informations
        var file = new Blob([document.getElementById('output').innerText], {type: 'text/plain'});
        // create url and link
        var url = URL.createObjectURL(file);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'sbatchfile.sh';
        document.body.appendChild(a);
        // activate the link
        a.click();
        // remove link after some time
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }, 0);
      });

      // remove the error field, if checkbox is active
      document.getElementById('one-output').addEventListener('change', function () {
        if (document.getElementById('one-output').checked) {
          document.getElementById('err-div').style.display = 'none';
          document.getElementById('err-div').value = '';
        } else {
          document.getElementById('err-div').style.display = '';
        }
      });

      // show workspace div, if checkbox is active
      document.getElementById('check-workspace').addEventListener('change', function () {
        let hidden = document.getElementsByClassName('row hidden');
        [].forEach.call(hidden, function (row) {
          if (document.getElementById('check-workspace').checked === true) {
            row.style.cssText = 'display:flex !important';
          } else {
            row.style.cssText = 'display:none !important';
          }
        })
      });

      // input mask for array
      document.getElementById('array').addEventListener('change', function () {
        let reArray = /^[0-9]+(-[0-9]+)?(,[0-9]+(-[0-9]+)?)*(:[0-9]+)?(%[0-9]+)?$/;
        if (!reArray.test(document.getElementById('array').value) && document.getElementById('array').value) {
          document.getElementById('array').style.backgroundColor = 'rgb(255, 121, 121)';
        } else {
          document.getElementById('array').style.backgroundColor = '';
        }
      });
      // input mask for walltime
      document.getElementById('time').addEventListener('change', function () {
        let reArray = /^([0-9]{1,3}-)?[0-9]{2}:[0-9]{2}:[0-9]{2}$/;
        if (!reArray.test(document.getElementById('time').value) && document.getElementById('time').value) {
          document.getElementById('time').style.backgroundColor = 'rgb(255, 121, 121)';
        } else {
          document.getElementById('time').style.backgroundColor = '';
          setLimitDuration()
        }
      });

      /**
       * Function to fill the information panel about the currently selected partition
       */
      var fillInfo = function() {
        let panelText = document.getElementById('info-panel');
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        panelText.innerText = partitionLimits['info'];
        panelText.innerText += '\nNodes: ' + partitionLimits['nodes'];
        panelText.innerText += '\nCores per node: ' + partitionLimits['cores/node'];
        panelText.innerText += '\nHyper threading: ' + partitionLimits['ht_cores/node'];
        panelText.innerText += '\nRAM per core: ' + partitionLimits['mem/core'] + 'MB';
        panelText.innerText += '\nRAM per node: ' + partitionLimits['mem/node'] + 'MB';
        panelText.innerText += '\nGPUs per node: ' + partitionLimits['gpu/node'];
      }

      /**
       * Function to fill the tooltip about the partitions
       */
      var fillTooltips = function() {
        for (const [key, value] of Object.entries(limitsPartition)) {
          let panelText = document.getElementById(key);
          let partitionLimits = limitsPartition[key];

          panelText.title = partitionLimits['info'];
          panelText.title += '\nNodes: ' + partitionLimits['nodes'];
          panelText.title += '\nCores per node: ' + partitionLimits['cores/node'];
          panelText.title += '\nHyper threading: ' + partitionLimits['ht_cores/node'];
          panelText.title += '\nRAM per core: ' + partitionLimits['mem/core'] + 'MB';
          panelText.title += '\nRAM per node: ' + partitionLimits['mem/node'] + 'MB';
          panelText.title += '\nGPUs per node: ' + partitionLimits['gpu/node'];
        }
      }

      /**
       * Function to fill the tooltip about the workspaces
       */
       var fillTooltipsWorkspace = function() {
        for (const [key, value] of Object.entries(limitsWorkspace)) {
          let panelText = document.getElementById(key);
          let partitionLimits = limitsWorkspace[key];

          panelText.title = partitionLimits['info'];
          panelText.title += '\nDuration: ' + partitionLimits['duration'];
          panelText.title += '\nExtensions: ' + partitionLimits['extensions'];
        }
      }

      /**
       * Function to fill the tooltip about limits of the field
       *
       * @param {string} field The id for the field to set the tooltip
       */
      var setTooltips = function(field) {
        let panelText = document.getElementById(field);

        panelText.title = 'Limits by current setting:';
        panelText.title += '\nmin: ' + minValues[field];
        panelText.title += '\nmax: ' + maxValues[field];
        panelText.title += '\nEmpty the field if unneeded'

        // set limit labels
        let limitText = document.getElementById(field + '-text');
        limitText.innerText = 'min: ' + minValues[field];
        limitText.innerText += ' max: ' + maxValues[field];
      }

      /**
       * Get the value of a field, or its maximum
       */
      var getValue = function(field, type) {
        let number = 0;
        // get field value
        rawNodes = document.getElementById(field).value;
        // set to maximum if value is undefined or out of range
        if (
          rawNodes !== ''
          && Number(rawNodes) >= minValues[field]
          && Number(rawNodes) <= maxValues[field]
        ) {
          number = Number(document.getElementById(field).value);
        } else {
          number = type === 'min' ? minValues[field] : maxValues[field];
        }
        return number;
      }

      /**
       * Set the limits for the nodes field
       */
       var setLimitNodes = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        // set max for nodes
        maxValues['nodes'] = partitionLimits['nodes'];

        // set min for nodes
        if (
          document.getElementById('tasks').value !== ''
          && document.getElementById('tasks/node').value !== ''
          ) {
          let tasks = getValue('tasks', 'min');
          let tasksPerNode = getValue('tasks/node', 'min');
          minValues['nodes'] = Math.ceil(tasks / tasksPerNode);
        } else {
          minValues['nodes'] = 1;
        }

        // set min for nodes
        setTooltips('nodes');
      }

      /**
       * Set the limits for the tasks field
       */
      var setLimitTasks = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        // set max
        let nodes = getValue('nodes', 'max');
        let taskPerNode = getValue('tasks/node', 'max');
        // multithreading
        let limit = document.getElementById('nomultithread').checked === true ? 'cores/node' : 'ht_cores/node';
        maxValues['tasks'] = nodes * partitionLimits[limit];
        // limit if nodes and tasks/node
        if (
          document.getElementById('tasks/node').value !== ''
          && document.getElementById('nodes').value !== ''
        ) {
          maxValues['tasks'] = taskPerNode * nodes;
        } else {
          minValues['tasks/node'] = 1;
        }

        // set min
        nodes = getValue('nodes', 'min');
        minValues['tasks'] = nodes;
        setTooltips('tasks');
      }

      /**
       * Set the limits for tasks per node field
       */
      var setLimitTasksPerNode = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        // set max
        let nodes = getValue('nodes', 'max');
        let tasks = getValue('tasks', 'max');

        // multithreading
        let limit = document.getElementById('nomultithread').checked === true ? 'cores/node' : 'ht_cores/node';
        maxValues['tasks/node'] = partitionLimits[limit];
        //set min
        nodes = getValue('nodes', 'min');
        tasks = getValue('tasks', 'min');
        if (
          document.getElementById('tasks').value !== ''
          && document.getElementById('nodes').value !== ''
        ) {
          minValues['tasks/node'] = Math.ceil(tasks / nodes);
        } else {
          minValues['tasks/node'] = 1;
        }

        // set min and max for --mincpus if gpus are allocated
        if (
          document.getElementById('gpus').value !== ''
          && document.getElementById('nodes').value !== ''
          && document.getElementById('tasks').value !== ''
        ) {
          minValues['tasks/node'] = Math.ceil(tasks / nodes);
          nodes = getValue('nodes', 'max');
          tasks = getValue('tasks', 'max');
          maxValues['tasks/node'] = Math.floor(tasks / nodes);
        }
        // set tooltips
        setTooltips('tasks/node');
      }

      /**
       * Set the limits for cpu per task field
       */
       var setLimitCpu = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        // set max
        // multithreading
        let limit = document.getElementById('nomultithread').checked === true ? 'cores/node' : 'ht_cores/node';
        let nodes = getValue('nodes', 'max');
        let tasks = getValue('tasks', 'max');
        let tasksPerNode = getValue('tasks/node', 'max');
        let maxValue = [partitionLimits[limit]];
        maxValue.push(Math.floor(partitionLimits[limit] / Math.ceil(tasks / nodes)));
        maxValue.push(Math.floor(partitionLimits[limit] / tasksPerNode));
        maxValues['cpus'] = Math.min.apply(null, maxValue);
        // set max for cpus if gpus are set
        if (
          document.getElementById('gpus').value !== ''
          && document.getElementById('gpus').value !== '0'
          && document.getElementById('exclusive').checked !== true
        ) {
          let gpus = getValue('gpus', 'max');
          maxValues[field] = Math.floor(gpus / partitionLimits['gpu/node'] * partitionLimits[limit]);
        }
        //set min
        minValues['cpus'] = 1;
        // set tooltips
        setTooltips('cpus');
      }

      /**
       * Set the limits for gpu per node field
       */
       var setLimitGpu = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        // set max for gpus
        maxValues['gpus'] = partitionLimits['gpu/node'];
        setTooltips('gpus');
        //set min
        if (document.getElementById('gpus/task').value !== '') {
          let tasks = getValue('tasks', 'min');
          let nodes = getValue('nodes', 'min');
          let gpusPerTask = getValue('gpus/task', 'min');
          minValues['gpus'] = Math.ceil(tasks / nodes * gpusPerTask);
        } else {
          minValues['gpus'] = 0;
        }
        // set tooltips
        setTooltips('gpus');
      }

      /**
       * Set the limits for the gpus per task field
       */
      var setLimitGpuPerTask = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        // get value from base
        let tasks = getValue('tasks', 'max');
        let tasksNode = getValue('tasks/node', 'max');
        let nodes = getValue('nodes', 'max');

        // set new max
        let maxValue = [partitionLimits['gpu/node']];
        if (tasks !== '') {
          maxValue.push(Math.floor(partitionLimits['gpu/node'] / Math.ceil(Number(tasks) / Number(nodes))));
        }
        if (tasksNode !== '') {
          maxValue.push(Math.floor(partitionLimits['gpu/node'] / Number(document.getElementById('tasks/node').value)));
        }
        maxValues['gpus/task'] = Math.min.apply(null, maxValue);
        // set tooltips for new limits
        setTooltips('gpus/task');
      }

      /**
       * Update the max for memory per cpu values
       */
      var setLimitMem = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];
        maxValues['mem'] = partitionLimits['mem/core'];
        if (document.getElementById('nomultithread').checked === true) {
          maxValues['mem'] *= partitionLimits['threads'];
        }
        if (document.getElementById('byte').value === 'G') {
        maxValues['mem'] = Math.floor(maxValues['mem'] / 1024);
        }
        setTooltips('mem');
      }

      /**
       * Set the limits for the duration field
       */
      var setLimitDuration = function() {
        // get partition limits from dictionary
        let workspaceLimits = limitsWorkspace[document.getElementById('workspace-filesystem').value];
        // set new max
        maxValues['duration'] = workspaceLimits['duration'];

        //set min
        // get days and hours from walltime
        let reArray = /^(([0-9]{1,3})-)?([0-9]{2}):([0-9]{2}):([0-9]{2})$/;
        let match = reArray.exec(document.getElementById('time').value);
        if (match === null) {
          setTooltips('duration');
          return;
        }
        // if days are defined or not
        if (match[2]) {
          minValues['duration'] = Number(match[2]);
        }
        minValues['duration'] += Math.ceil(Number(match[3]) / 24);
        if ((Number(match[4]) !== 0 || Number(match[5]) !== 0) && Number(match[3]) % 24 === 0) {
          minValues['duration'] += 1;
        }
        // set tooltips for new limits
        setTooltips('duration');
      }

      /**
       * Update the value und max for CPU and GPU values
       */
      var LimitChange = function() {
        setLimitNodes();
        setLimitTasks();
        setLimitTasksPerNode();
        setLimitCpu();
        if (document.getElementById('div-gpu').style.display !== 'none') {
          setLimitGpu();
          setLimitGpuPerTask();
        }
        setLimitMem();
        setLimitDuration();
      }

      /**
       * Function to trigger updates, if parttion was changed
       */
      var partitionLimitChange = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];
        // hide the GPU field, if partition do not have GPUs
        if (partitionLimits['gpu/node'] === 0) {
          document.getElementById('div-gpu').style.display = 'none';
          document.getElementById('div-gpu/task').style.display = 'none';
          document.getElementById('gpus').value = '';
          document.getElementById('gpus/task').value = '';
        } else {
          document.getElementById('div-gpu').style.display = '';
          document.getElementById('div-gpu/task').style.display = '';
        }
        // hide the multithreading field if it isnt supported
        if (partitionLimits['threads'] === 1) {
          document.getElementById('div-thread').style.display = 'none';
          document.getElementById('nomultithread').checked = false;
        } else {
          document.getElementById('div-thread').style.display = '';
        }
        // update other values
        LimitChange();
      }

      // set up event listeners, if field change
      document.getElementById('partition').addEventListener('change', partitionLimitChange);
      document.getElementById('partition').addEventListener('change', fillInfo);
      document.getElementById('nodes').addEventListener('change', LimitChange);
      document.getElementById('tasks').addEventListener('change', LimitChange);
      document.getElementById('tasks/node').addEventListener('change', LimitChange);
      document.getElementById('cpus').addEventListener('change', LimitChange);
      document.getElementById('gpus').addEventListener('change', LimitChange);
      document.getElementById('gpus/task').addEventListener('change', LimitChange);
      document.getElementById('mem').addEventListener('change', LimitChange);
      document.getElementById('byte').addEventListener('change', setLimitMem);
      document.getElementById('exclusive').addEventListener('change', LimitChange);
      document.getElementById('nomultithread').addEventListener('change', LimitChange);
      document.getElementById('workspace-filesystem').addEventListener('change', setLimitDuration);

      // hide jobid field if unneeded
      document.getElementById('type-depend').addEventListener('change', function() {
        if (document.getElementById('type-depend').value === 'none' ||
          document.getElementById('type-depend').value === 'singleton') {
          document.getElementById('jobid').style.cssText = 'display:none !important';
        } else {
          document.getElementById('jobid').style.cssText = 'display:inline !important';
        }
      });

      document.getElementById('generate-button').addEventListener('click', proofValues);

      // initialize webpage

      // set up the collapsible fields
      let colls = document.getElementsByClassName('collapsible');
      [].forEach.call(colls, function (coll) {
        // add event listeners
        coll.addEventListener('click', function() {
          this.classList.toggle('active');
          let content = this.nextElementSibling;
          if (content.style.display === 'block') {
            content.style.display = 'none';
          } else {
            content.style.display = 'block';
          }
        });

        // extended at beginning
        let content = coll.nextElementSibling;
        content.style.display = 'block';
        coll.classList.toggle('active');
      })

      // set up of partition options
      let select = document.getElementById('partition');

      for (const [key, value] of Object.entries(limitsPartition)) {
        let option = document.createElement('option');
        option.id = key;
        option.value = key;
        option.innerText = key;
        if (key === 'haswell64') {
          option.selected = 'selected';
        }
        select.appendChild(option);
      }

      // set up of workspace options
      select = document.getElementById('workspace-filesystem');

      for (const [key, value] of Object.entries(limitsWorkspace)) {
        let option = document.createElement('option');
        option.id = key;
        option.value = key;
        option.innerText = key;
        if (key === 'scratch') {
          option.selected = 'selected';
        }
        select.appendChild(option);
      }

      // set up info texts
      for (const [key, value] of Object.entries(info)) {
        document.getElementById(key + '-info').title = value['text'];
      }

      // initialize UI
      partitionLimitChange();
      fillInfo();
      fillTooltips();
      fillTooltipsWorkspace();
    </script>
  </body>
</html>
