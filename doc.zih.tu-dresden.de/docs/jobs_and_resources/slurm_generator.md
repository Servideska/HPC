<!--
This file is part of sgen software.
Slurm Jobfile Generator

Copyright (c) 2022,
    Technische Universitaet Dresden, Germany

sgen is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Foobar is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sgen.  If not, see <http://www.gnu.org/licenses/>.
-->

<html lang="en-us">
  <head>
    <meta charset="utf-8">
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0"> -->
    <title>Slurm-Job-File-Generator</title>
    <!--<link type="text/css" href="../misc/style.css" rel="stylesheet">-->
    <!--<script src="jquery-3.6.0.min.js"> </script>-->
  </head>

  <body>
    <button id="header" type="button" class="collapsible"
      style="height: 60px; background-color: #002557; padding-left: 0px; padding-top: 20px;">
    <label class="header">TU Dresden Slurm Job File Generator</label>
    </button>
    <div class="content">
        <div class="row">
          <label class="cell-longopt">Appearance</label>
          <tt class="cell-shortopt"></tt>
          <input id="radio-basic" type="radio" name="appearance" value="basic" checked>
          <label for="radio-basic">&nbsp;Basic&nbsp;&nbsp;&nbsp;</label>
          <input id="radio-advanced" type="radio" name="appearance" value="advanced">
          <label for="radio-advanced">&nbsp;Advanced</label>
        </div>
    </div>
  </body>
</html>

# Slurm Job File Generator
<br>
Generate a batch file to submit your job to the HPC system via `sbatch <submit_file.sh>`.

Check the resource allocation with `scontrol show job -d $SLURM_JOB_ID`, especially for multi-node
GPU jobs.

This form does not cover all available options. Refer to Slurm's man page or
[web page](https://slurm.schedmd.com/sbatch.html) for more details.

Find this project at
[gitlab](https://gitlab.hrz.tu-chemnitz.de/zih/hpcsupport/slurm-jobfile-generator)
in order to contribute or deploy this tool for your HPC system.
<br><br>

<html lang="en-us">
  <head>
    <meta charset="utf-8">
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0"> -->
    <title>Slurm-Job-File-Generator</title>
    <!--<link type="text/css" href="../misc/style.css" rel="stylesheet">-->
    <!--<script src="jquery-3.6.0.min.js"> </script>-->
  </head>

  <body>
    <button type="button" class="collapsible">General</button>
      <div class="content">
        <div id="job-name-info" class="row" title="help">
          <tt class="cell-shortopt">-J</tt>
          <tt class="cell-longopt">--job-name</tt>
          <label class="cell-description">Job name</label>
          <input id="job-name" class="cell-input" type="text">
        </div>
        <div id="account-info" class="row" title="help">
          <tt class="cell-shortopt">-A</tt>
          <tt class="cell-longopt">--account</tt>
          <label class="cell-description">Project name</label>
          <input id="account" class="cell-input" type="text">
        </div>
        <div id="mail-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--mail-type</tt>
          <label class="cell-description">Email notification</label>
          <div class="cell-input">
            <input id="mail" type="checkbox" style="display:none">
            <input id="begin" type="checkbox" value='BEGIN'>
            <lable for="begin">Begin</lable>
            <input id="end" type="checkbox" value='END'>
            <lable for="end">End</lable>
            <input id="fail" type="checkbox" value='FAIL'>
            <lable for="fail">Fail</lable>
          </div>
        </div>
        <div id="mail-info2" class="row advanced" title="help">
          <label class="cell-name"></label>
          <div class="cell-input">
            <input id="timelimit50" type="checkbox" value='TIME_LIMIT_50'>
            <lable for="timelimit50">50%</lable>
            <input id="timelimit80" type="checkbox" value='TIME_LIMIT_80'>
            <lable for="timelimit80">80%</lable>
            <input id="timelimit90" type="checkbox" value='TIME_LIMIT_90'>
            <lable for="timelimit90">90%</lable>&nbsp;Time Limit
          </div>
        </div>
        <div id="mail-info3" class="row advanced" title="help">
          <label class="cell-name"></label>
          <div class="cell-input">
            <input id="stage-out" type="checkbox" value='STAGE_OUT'>
            <lable for="stage-out">Burst</lable>
            <input id="inv-depend" type="checkbox" value='INVALID_DEPEND'>
            <lable for="inv-depend">Invalid</lable>
            <input id="all" type="checkbox" value='ALL'>
            <lable for="all">ALL</lable>
          </div>
        </div>
        <div id="mail-user-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--mail-user</tt>
          <label class="cell-description">Email address</label>
          <div class="cell-input">
            <input id="mail-user" class="mail" type="mail" placeholder="user@tu-dresden.de">
          </div>
        </div>
        <div id="timelimit-info" class="row" title="help">
          <tt class="cell-shortopt">-t</tt>
          <tt class="cell-longopt">--time</tt>
          <label class="cell-description">Time limit</label>
          <input id="timelimit" class="cell-input" type="text" placeholder="000-00:00:00">
          <label id="timelimit-text" class="limits cell-input"></label>
        </div>
        <div id="begin-job-info" class="row advanced" title="help">
          <tt class="cell-shortopt">-b</tt>
          <tt class="cell-longopt">--begin</tt>
          <label class="cell-description">Not before</label>
          <input id="begin-job" class="cell-input" type="text" placeholder="[YYYY-MM-DD][T][HH:MM]" value="">
          <label id="begin-job-text" class="limits cell-input"></label>
        </div>
        <div id="deadline-info" class="row advanced" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--deadline</tt>
          <label class="cell-description">Deadline</label>
          <input id="deadline" class="cell-input" type="text" placeholder="[YYYY-MM-DD][T][HH:MM]">
          <label id="deadline-text" class="limits cell-input"></label>
        </div>
        <div id="info" class="info-box">
          <p><b>Info Panel</b><br><br>Additional information is displayed here.</p>
        </div>
      </div>

    <button type="button" class="collapsible">Resources</button>
    <div class="content">
      <div class="partition-input">
        <div id="partition-info" class="row" title="help">
          <tt class="cell-shortopt">-p</tt>
          <tt class="cell-longopt">--partition</tt>
          <label class="cell-description">Partition</label>
          <select id="partition" class="cell-input"></select>
        </div>
        <div id="nodes-info" class="row" title="help">
          <tt class="cell-shortopt">-N</tt>
          <tt class="cell-longopt">--nodes</tt>
          <label class="cell-description">Nodes</label>
          <input id="nodes" class="cell-input" type="number" min="1">
          <label id="nodes-text" class="limits cell-input"></label>
        </div>
        <div id="tasks-info" class="row advanced" title="help">
          <tt class="cell-shortopt">-n</tt>
          <tt class="cell-longopt">--ntasks</tt>
          <label class="cell-description">Number of tasks</label>
          <input id="tasks" class="cell-input" type="number" min="1">
          <label id="tasks-text" class="limits cell-input"></label>
        </div>
        <div id="tasks-per-node-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--ntasks-per-node</tt>
          <label class="cell-description">Tasks per node</label>
          <input id="tasks-per-node" class="cell-input" type="number" min="1">
          <label id="tasks-per-node-text" class="limits cell-input"></label>
        </div>
        <div id="cpus-info" class="row" title="help">
          <tt class="cell-shortopt">-c</tt>
          <tt class="cell-longopt">--cpus-per-task</tt>
          <label class="cell-description">CPUs per task</label>
          <input id="cpus" class="cell-input" type="number" min="1">
          <label id="cpus-text" class="limits cell-input"></label>
        </div>
        <div id="mem-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--mem-per-cpu</tt>
          <label class="cell-description">Memory per CPU</label>
          <div class="cell-input">
            <input id="mem" type="number" min="1">
            <select id="byte">
              <option value="M" title="placeholder" selected="selected">MiB</option>
              <option value="G" title="placeholder">GiB</option>
            </select>
            <label id="mem-text" class="limits"></label>
          </div>
        </div>
        <div id="gpus-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--gres=gpu</tt>
          <label class="cell-description">GPUs per node</label>
          <input id="gpus" class="cell-input" type="number" min="0">
          <label id="gpus-text" class="limits cell-input"></label>
        </div>
        <div id="gpus-per-task-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--gpus-per-task</tt>
          <label class="cell-description">GPUs per task</label>
          <input id="gpus-per-task" class="cell-input" type="number" min="0">
          <label id="gpus-per-task-text" class="limits cell-input"></label>
        </div>
        <div id="nodelist-info" class="row advanced" title="help">
          <tt class="cell-shortopt">-w</tt>
          <tt class="cell-longopt">--nodelist</tt>
          <label class="cell-description">Nodelist</label>
          <input id="nodelist" class="cell-input" type="text" placeholder="taurusi[6403-6408,6410]">
        </div>
        <div id="exclude-info" class="row advanced" title="help">
          <tt class="cell-shortopt">-x</tt>
          <tt class="cell-longopt">--exclude</tt>
          <label class="cell-description">Exclude nodes</label>
          <input id="exclude" class="cell-input" type="text" placeholder="taurusi6409">
        </div>
        <div id="distribution-info" class="row advanced" title="help">
          <tt class="cell-shortopt">-m</tt>
          <tt class="cell-longopt">--distribution</tt>
          <label class="cell-description">Process distribution</label>
          <div class="cell-input">
            <select id="distribution">
              <option value="none" title="placeholder" selected="selected"></option>
              <option value="arbitrary" title="placeholder">arbitrary</option>
              <option value="block" title="placeholder">block</option>
              <option value="cyclic" title="placeholder">cyclic</option>
              <option value="plane" title="placeholder">plane</option>
            </select>
            <input id="distribution-option" class="hidden" type="text" placeholder="=n">
            <select id="distribution2" class="hidden">
              <option value="none" title="placeholder" selected="selected"></option>
              <option value=":block" title="placeholder">block</option>
              <option value=":cyclic" title="placeholder">cyclic</option>
              <option value=":fcyclic" title="placeholder">fcyclic</option>
            </select>
          </div>
        </div>
        <div id="distribution2-info" class="row advanced" title="help" style="display:none"></div>
        <div id="contiguous-info" class="row advanced" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--contiguous</tt>
          <label class="cell-description"></label>
          <div class="cell-input">
            <input id="contiguous" class="cell" type="checkbox">
            <lable for="contiguous">Contiguous node set</lable>
          </div>
        </div>
        <div id="exclusive-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--exclusive</tt>
          <label class="cell-description"></label>
          <div class="cell-input">
            <input id="exclusive" type="checkbox">
            <lable for="exclusive">Exclusive Resources</lable>
          </div>
        </div>
        <div id="nomultithread-info" id="div-thread" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--hint=nomultithread</tt>
          <label class="cell-description"></label>
          <div class="cell-input">
            <input id="nomultithread" class="cell" type="checkbox">
            <lable for="nomultithread">No Multithreading</lable>
          </div>
        </div>
        <div id="nomonitoring-info" class="row advanced" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--hint=no_monitoring</tt>
          <label class="cell-description"></label>
          <div class="cell-input">
            <input id="nomonitoring" class="cell" type="checkbox">
            <lable for="nomonitoring">No PIKA recording</lable>
          </div>
        </div>
        <div id="reservation-info" class="row" title="help">
          <tt class="cell-shortopt"></tt>
          <tt class="cell-longopt">--reservation</tt>
          <label class="cell-description">Reservation</label>
          <input id="reservation" class="cell-input" type="text">
        </div>
      </div>
      <div class="partition-info">
        <pre id="info-panel" class="info-pre">
          <table class="table-pre">
            <tr><td><b>Partition</b></td><td align="right" id="td-partition"></td></tr>
            <tr><td>Number of Nodes:</td><td align="right" id="td-nodes"></td></tr>
            <tr><td>Cores per node:</td><td align="right" id="td-Cores"></td></tr>
            <tr><td>Hyper threading:</td><td align="right" id="td-HTCores"></td></tr>
            <tr><td>RAM per core [MB]:</td><td align="right" id="td-MemoryPerCore"></td></tr>
            <tr><td>RAM per node [MB]:</td><td align="right" id="td-MemoryPerNode"></td></tr>
            <tr><td>GPUs per node:</td><td align="right" id="td-GPUsPerNode"></td></tr>
          </table>
        </pre>
      </div>
    </div>

    <button type="button" class="collapsible">Files</button>
    <div class="content">
      <div id="executable-info" class="row" title="help">
        <tt class="cell-shortopt"></tt>
        <tt class="cell-longopt"></tt>
        <label class="cell-description">Executable</label>
        <input id="executable" class="cell-input executable" type="text"
          placeholder="/scratch/ws/0/p_number_crunch/bin/app">
      </div>
      <div id="srun-info" class="row" title="help">
        <tt class="cell-shortopt"></tt>
        <tt class="cell-longopt"></tt>
        <label class="cell-description">Execution with srun</label>
        <div class="cell-input">
          <input id="srun" type="checkbox" value="srun">
          <label for="srun">Execute command is included in the config (replace mpirun!)</label>
        </div>
      </div>
      <div id="one-output-info" class="row" title="help">
        <tt class="cell-shortopt"></tt>
        <tt class="cell-longopt"></tt>
        <label class="cell-description">Output</label>
        <div class="cell-input">
          <input id="one-output" type="checkbox">
          <label for="one-output">One output file (<tt>stdout</tt> and <tt>stderr</tt>)</label>
        </div>
      </div>
      <div id="output-file-info" class="row" title="help">
        <tt class="cell-shortopt">-o</tt>
        <tt class="cell-longopt">--output</tt>
        <label class="cell-description">Output filename</label>
        <input id="output-file" class="cell-input" type="text" placeholder="slurm-%j.out">
      </div>
      <div id="error-file-info" class="row" title="help">
        <tt class="cell-shortopt">-e</tt>
        <tt class="cell-longopt">--error</tt>
        <label class="cell-description">Error filename</label>
        <input id="error-file" class="cell-input" type="text" placeholder="slurm-%j.out">
      </div>
    </div>

    <button id="array-button" type="button" class="collapsible">Array Job</button>
    <div class="content">
      <div id="array-info" class="row advanced" title="help">
        <tt class="cell-shortopt">-a</tt>
        <tt class="cell-longopt">--array</tt>
        <label class="cell-description">Array</label>
        <input id="array" class="cell-input" type="text" placeholder="1-5">
      </div>
      <div id="dependency-info" class="row advanced" title="help">
        <tt class="cell-shortopt">-d</tt>
        <tt class="cell-longopt">--dependency</tt>
        <label class="cell-description">Dependency</label>
        <div class="cell-input">
          <select id="dependency">
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

    <button type="button" class="collapsible">Workspace and Environment</button>
    <div class="content">
      <div class="partition-input">
        <div id="ws-alloc-info" class="row" title="help">
          <label class="cell-name">Allocate a workspace</label>
          <div class="cell-input">
            <input id="ws-alloc" type="checkbox">
            <label for="ws-alloc">Allocation</label>
          </div>
        </div>
        <div id="filesystem-info" class="row hidden">
          <label class="cell-name">Filesystem</label>
          <select id="filesystem" class="cell-input"></select>
        </div>
        <div id="ws-name-info" class="row hidden">
          <label class="cell-name">Name</label>
          <input id="ws-name" class="cell-input" type="text">
        </div>
        <div id="duration-info" class="row hidden">
          <label class="cell-name">Duration</label>
          <div class="cell-input">
            <input id="duration" type="number" min="1">
            <label id="duration-text" class="limits"></label>
          </div>
        </div>
        <div id="ws-delete-info" class="row hidden">
          <label class="cell-name">Clean up</label>
          <div class="cell-input">
            <input id="ws-delete" type="checkbox">
            <label for="ws-delete">Delete after job</label>
          </div>
        </div>
        <div id="chdir-info" class="row advanced" title="help">
          <tt class="cell-shortopt">-D</tt>
          <tt class="cell-longopt">--chdir</tt>
          <label class="cell-description">Working directory</label>
          <input id="chdir" class="cell-input" type="text" placeholder="[/scratch/ws/0/]wdir">
        </div>
        <div id="module-info" class="row" title="help">
          <label class="cell-name">Print list of loaded software</label>
          <div class="cell-input">
            <input id="module" type="checkbox" value="checked">
            <label for="module"><tt>module list</tt></label>
          </div>
        </div>
      </div>
      <div class="partition-info">
        <pre id="ws-info-panel" class="ws-info-pre">
          <table class="table-pre">
            <tr><td><b>Filesystem</b></td><td align="right" id="td-filesystem"></td></tr>
            <tr><td>Capacity:</td><td align="right" id="td-size"></td></tr>
            <tr><td>Duration [d]:</td><td align="right" id="td-duration"></td></tr>
            <tr><td>Extensions:</td><td align="right" id="td-extensions"></td></tr>
          </table>
        </pre>
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
        'haswell': haswell = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 2,
          'CoresPerSocket': 12,
          'ThreadsPerCore': 1,
          'nodes': 612,
          'Cores': 24,
          'HTCores': 24,
          'MemoryPerCore': 2541,
          'MemoryPerNode': 61000,
          'GPUsPerNode': 0
        },
        'haswell64': haswell64 = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 2,
          'CoresPerSocket': 12,
          'ThreadsPerCore': 1,
          'nodes': 594,
          'Cores': 24,
          'HTCores': 24,
          'MemoryPerCore': 2541,
          'MemoryPerNode': 61000,
          'GPUsPerNode': 0
        },
        'haswell256': haswell256 = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 18,
          'Sockets': 2,
          'CoresPerSocket': 12,
          'ThreadsPerCore': 1,
          'nodes': 44,
          'Cores': 24,
          'HTCores': 24,
          'MemoryPerCore': 10583,
          'MemoryPerNode': 254000,
          'GPUsPerNode': 0
        },
        'gpu2': gpu2 = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 2,
          'CoresPerSocket': 12,
          'ThreadsPerCore': 1,
          'nodes': 59,
          'Cores': 24,
          'HTCores': 24,
          'MemoryPerCore': 2583,
          'MemoryPerNode': 62000,
          'GPUsPerNode': 4
        },
        'smp2': smp2 = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 4,
          'CoresPerSocket': 14,
          'ThreadsPerCore': 1,
          'nodes': 5,
          'Cores': 56,
          'HTCores': 56,
          'MemoryPerCore': 36500,
          'MemoryPerNode': 2044000,
          'GPUsPerNode': 0
        },
        'ifm': ifm = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 60,
          'Sockets': 2,
          'CoresPerSocket': 8,
          'ThreadsPerCore': 2,
          'nodes': 1,
          'Cores': 16,
          'HTCores': 32,
          'MemoryPerCore': 12000,
          'MemoryPerNode': 384000,
          'GPUsPerNode': 1
        },
        'hpdlf': hpdlf = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 60,
          'Sockets': 2,
          'CoresPerSocket': 6,
          'ThreadsPerCore': 1,
          'nodes': 14,
          'Cores': 12,
          'HTCores': 12,
          'MemoryPerCore': 7916,
          'MemoryPerNode': 95000,
          'GPUsPerNode': 3
        },
        'ml': ml = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 60,
          'Sockets': 2,
          'CoresPerSocket': 22,
          'ThreadsPerCore': 4,
          'nodes': 30,
          'Cores': 44,
          'HTCores': 176,
          'MemoryPerCore': 1443,
          'MemoryPerNode': 254000,
          'GPUsPerNode': 6
        },
        'romeo': romeo = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 2,
          'CoresPerSocket': 64,
          'ThreadsPerCore': 2,
          'nodes': 190,
          'Cores': 128,
          'HTCores': 256,
          'MemoryPerCore': 1972,
          'MemoryPerNode': 505000,
          'GPUsPerNode': 0
        },
        'julia': julia = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 32,
          'CoresPerSocket': 28,
          'ThreadsPerCore': 1,
          'nodes': 1,
          'Cores': 896,
          'HTCores': 896,
          'MemoryPerCore': 54006,
          'MemoryPerNode': 48390000,
          'GPUsPerNode': 0
        },
        'alpha': alpha = {
          'MaxTime': 'INFINITE',
          'DefaultTime': 480,
          'Sockets': 2,
          'CoresPerSocket': 24,
          'ThreadsPerCore': 2,
          'nodes': 32,
          'Cores': 48,
          'HTCores': 96,
          'MemoryPerCore': 10312,
          'MemoryPerNode': 990000,
          'GPUsPerNode': 8
        }
      };

      // dictionary containing the limits for the different workspaces
      const limitsWorkspace = {
        'scratch': scratch = {
          'size': '4 PB',
          'duration': 100,
          'extensions': 10
        },
        'warm_archive': warm_archive = {
          'size': '4.5 PB',
          'duration': 365,
          'extensions': 2
        },
        'ssd': ssd = {
          'size': '40 TB',
          'duration': 30,
          'extensions': 2
        },
        'beegfs': beegfs = {
          'size': '500 TB',
          'duration': 30,
          'extensions': 2
        }
      };

      // dictionary containing the tooltip texts, texts and links for the info-panel on the right
      const info = {
        'job-name': {
          'opt':  '--job-name',
          'text': 'Specify a name for the job allocation. The specified name will appear along with the job id number when querying running jobs on the system with squeue. (default: name of the job file)',
          'info': 'Specify a name for the job allocation. The specified name will appear along with the job id number when querying running jobs on the system. The default is the name of the batch script or just "sbatch" if the script is read on sbatch\'s standard input.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_job-name'
        },
        'account': {
          'opt':  '--account',
          'text': 'Charge resources used by this job to specified project.',
          'info': 'Charge resources used by this job to specified account. The account is an arbitrary string. The account name may be changed after job submission using the scontrol command.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_account'
        },
        'mail': {
          'opt':  '--mail-type',
          'text': 'Send an email notification on specified event.',
          'info': 'Notify user by email when certain event types occur. Valid type values are NONE BEGIN END FAIL REQUEUE ALL (equivalent to BEGIN END FAIL INVALID_DEPEND REQUEUE and STAGE_OUT) INVALID_DEPEND (dependency never satisfied) STAGE_OUT (burst buffer stage out and teardown completed) TIME_LIMIT TIME_LIMIT_90 (reached 90 percent of time limit) TIME_LIMIT_80 (reached 80 percent of time limit) TIME_LIMIT_50 (reached 50 percent of time limit) and ARRAY_TASKS (send emails for each array task). Multiple type val‐ ues may be specified in a comma separated list. The user to be notified is indicated with --mail-user. Unless the ARRAY_TASKS option is specified mail notifications on job BEGIN END and FAIL apply to a job array as a whole rather than generating individual email messages for each task in the job array.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_mail-type'
        },
        'mail-user': {
          'opt':  '--mail-user',
          'text': 'Specify the email address where notifications defined by --mail-type are sent to.',
          'info': 'User to receive email notification of state changes as defined by --mail-type. The default value is the submitting user.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_mail-user'
        },
        'timelimit': {
          'opt':  '--time',
          'text': 'Set the total run time limit of the job allocation. When the time limit is reached, each task in each job step is sent SIGTERM followed by SIGKILL. The default time limit is the partition\'s default time limit. (currently only supports ddd-hh:mm:ss and hh:mm:ss)',
          'info': 'Set a limit on the total run time of the job allocation. If the requested time limit exceeds the partition\'s time limit, the job will be left in a PENDING state (possibly indefinitely). The default time limit is the partition\'s default time limit. When the time limit is reached, each task in each job step is sent SIGTERM followed by SIGKILL. The interval between signals is specified by the Slurm configuration parameter KillWait. The OverTimeLimit configuration parameter may permit the job to run longer than scheduled. Time resolution is one minute and second values are rounded up to the next minute. A time limit of zero requests that no time limit be imposed. Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_time'
        },
        'begin-job': {
          'opt':  '--begin',
          'text': 'Tell the controller to defer the allocation of the job until the specified time.',
          'info': 'Submit the batch script to the Slurm controller immediately like normal but tell the controller to defer the allocation of the job until the specified time. Time may be of the form HH:MM:SS to run a job at a specific time of day (seconds are optional). (If that time is already past the next day is assumed.) You may also specify midnight, noon, fika (3 PM) or teatime (4 PM) and you can have a time-of-day suffixed with AM or PM for running in the morning or the evening. You can also say what day the job will be run by specifying a date of the form MMDDYY or MM/DD/YY YYYY-MM-DD. Combine date and time using the following format YYYY-MM-DD[THH:MM[:SS]]. You can also give times like now + count time-units where the time-units can be seconds (default) minutes hours days or weeks and you can tell Slurm to run the job today with the keyword today and to run the job tomorrow with the keyword tomorrow. The value may be changed after job submission using the scontrol command.<br>See also --deadline for formats.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_begin'
        },
        'deadline': {
          'opt':  '--deadline',
          'text': 'Remove the job if no ending is possible before this deadline. Default: No deadline.',
          'info': "Remove the job if no ending is possible before this deadline (start > (deadline - time[-min])). Default is no deadline. Valid time formats are:<br>HH:MM[:SS] [AM|PM]<br>MMDD[YY] or MM/DD[/YY] or MM.DD[.YY]<br>MM/DD[/YY]-HH:MM[:SS]<br>YYYY-MM-DD[THH[:MM[:SS]]]<br>now[+count[seconds(default)|minutes| hours| days |weeks]]",
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_deadline'
        },
        'partition': {
          'opt':  '--partition',
          'text': 'Request a specific partition for the resource allocation. If the job can use more than one partition, specify their names in a comma separate list and the one offering earliest initiation will be used with no regard given to the partition name ordering. (default: default paritition of the system)',
          'info': 'Request a specific partition for the resource allocation. If not specified the default behavior is to allow the slurm controller to select the default partition as designated by the system administrator. If the job can use more than one partition specify their names in a comma separate list and the one offering earliest initiation will be used with no regard given to the partition name ordering (although higher priority partitions will be considered first). When the job is initiated the name of the partition used will be placed first in the job record partition string.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_partition'
        },
        'nodes': {
          'opt':  '--nodes',
          'text': 'Request that number of nodes be allocated to this job.',
          'info': 'Request that a minimum of minnodes nodes be allocated to this job. A maximum node count may also be specified with maxnodes. If only one number is specified this is used as both the minimum and maximum node count. The partition\'s node limits supersede those of the job. If a job\'s node limits are outside of the range permitted for its associated partition the job will be left in a PENDING state. This permits possible execution at a later time when the partition limit is changed. If a job node limit exceeds the number of nodes configured in the partition the job will be rejected. Note that the environment variable SLURM_JOB_NUM_NODES will be set to the count of nodes actually allocated to the job. See the ENVIRONMENT VARIABLES section for more information. If -N is not specified the default behavior is to allocate enough nodes to satisfy the requested resources as expressed by per-job specification options e.g. -n -c and --gpus. The job will be allocated as many nodes as possible within the range specified and without delaying the initiation of the job. The node count specification may include a numeric value followed by a suffix of "k" (multiplies numeric value by 1024) or "m" (multiplies numeric value by 1,048,576).',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_nodes'
        },
        'tasks': {
          'opt':  '--ntasks',
          'text': 'Request that many MPI tasks (default: one task per node)',
          'info': 'sbatch does not launch tasks it requests an allocation of resources and submits a batch script. This option advises the Slurm controller that job steps run within the allocation will launch a maximum of number tasks and to provide for sufficient resources. The default is one task per node but note that the --cpus-per-task option will change this default.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_ntasks'
        },
        'tasks-per-node': {
          'opt':  '--ntasks-per-node',
          'text': 'Allocate <n> tasks per node. If used with the --ntasks option, the --ntasks option will take precedence and the --ntasks-per-node will be treated as a maximum count of tasks per node. Meant to be used with the --nodes option.',
          'info': 'Request that ntasks be invoked on each node. If used with the --ntasks option the --ntasks option will take precedence and the --ntasks-per-node will be treated as a maximum count of tasks per node. Meant to be used with the --nodes option. This is related to --cpus-per-task=ncpus but does not require knowledge of the actual number of cpus on each node. In some cases it is more convenient to be able to request that no more than a specific number of tasks be invoked on each node. Examples of this include submitting a hybrid MPI/OpenMP app where only one MPI "task/rank" should be assigned to each node while allowing the OpenMP portion to utilize all of the parallelism present in the node or submitting a single setup/cleanup/monitoring job to each node of a pre-existing allocation as one step in a larger job script.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_ntasks-per-node'
        },
        'cpus': {
          'opt':  '--cpus-per-task',
          'text': 'Request that number of processors per MPI task. This is needed for multithreaded (e.g. OpenMP) jobs; typically <N> should be equal to OMP_NUM_THREADS',
          'info': 'Advise the Slurm controller that ensuing job steps will require ncpus number of processors per task. Without this option the controller will just try to allocate one processor per task. For instance consider an application that has 4 tasks each requiring 3 processors. If our cluster is comprised of quad-processors nodes and we simply ask for 12 processors the controller might give us only 3 nodes. However by using the --cpus-per-task=3 options the controller knows that each task requires 3 processors on the same node and the controller will grant an allocation of 4 nodes one for each of the 4 tasks.<br><br>NOTE: Beginning with 22.05 srun will not inherit the --cpus-per-task value requested by salloc or sbatch. It must be requested again with the call to srun or set with the SRUN_CPUS_PER_TASK environment variable if desired for the task(s).',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_cpus-per-task'
        },
        'mem': {
          'opt':  '--mem-per-cpu',
          'text': 'Memory required per usable allocated CPU.',
          'info': 'Minimum memory required per usable allocated CPU. Default units are megabytes. The default value is DefMemPerCPU and the maximum value is MaxMemPerCPU (see exception below). If configured both parameters can be seen using the scontrol show config command. Note that if the job\'s --mem-per-cpu value exceeds the configured MaxMemPerCPU then the user\'s limit will be treated as a memory limit per task; --mem-per-cpu will be reduced to a value no larger than MaxMemPerCPU; --cpus-per-task will be set and the value of --cpus-per-task multiplied by the new --mem-per-cpu value will equal the original --mem-per-cpu value specified by the user. This parameter would generally be used if individual processors are allocated to jobs (SelectType=select/cons_res). If resources are allocated by core socket or whole nodes then the number of CPUs allocated to a job may be higher than the task count and the value of --mem-per-cpu should be adjusted accordingly. Also see --mem and --mem-per-gpu. The --mem --mem-per-cpu and --mem-per-gpu options are mutually exclusive. NOTE: If the final amount of memory requested by a job can\'t be satisfied by any of the nodes configured in the partition the job will be rejected. This could happen if --mem-per-cpu is used with the --exclusive option for a job allocation and --mem-per-cpu times the number of CPUs on a node is greater than the total memory of that node.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_mem-per-cpu'
        },
        'gpus': {
          'opt':  '--gres=gpu',
          'text': 'Specify the number of GPUs required for the job on each node included in the job\'s resource allocation.',
          'info': 'Specifies a comma-delimited list of generic consumable resources per node. The format of each entry on the list is "name[[:type]:count]". The name is that of the consumable resource. The count is the number of those resources with a default value of 1. The count can have a suffix of "k" or "K" (multiple of 1024), "m" or "M" (multiple of 1024 x 1024), "g" or "G" (multiple of 1024 x 1024 x 1024), "t" or "T" (multiple of 1024 x 1024 x 1024 x 1024), "p" or "P" (multiple of 1024 x 1024 x 1024 x 1024 x 1024). The specified resources will be allocated to the job on each node. The available generic consumable resources is configurable by the system administrator. A list of available generic consumable resources will be printed and the command will exit if the option argument is "help". Examples of use include "--gres=gpu:2", "--gres=gpu:kepler:2", and "--gres=help".',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_gpus-per-node'
        },
        'gpus-per-task': {
          'opt':  '--gpus-per-task',
          'text': 'Specify the number of GPUs required for the job on each task to be spawned in the job\'s resource allocation.',
          'info': 'Specify the number of GPUs required for the job on each task to be spawned in the job\'s resource allocation. An optional GPU type specification can be supplied. For example "--gpus-per-task=volta:1". Multiple options can be requested in a comma separated list for example: "--gpus-per-task=volta:3 kepler:1". See also the --gpus --gpus-per-socket and --gpus-per-node options. This option requires an explicit task count e.g. -n --ntasks or "--gpus=X --gpus-per-task=Y" rather than an ambiguous range of nodes with -N --nodes. This option will implicitly set --gpu-bind=per_task:<gpus_per_task> but that can be overridden with an explicit --gpu-bind specification.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_gpus-per-task'
        },
        'nodelist': {
          'opt':  '--nodelist',
          'text': 'Request a specific list of hosts. The job will contain all of these hosts and possibly additional hosts as needed to satisfy resource requirements.',
          'info': 'Request a specific list of hosts. The job will contain all of these hosts and possibly additional hosts as needed to satisfy resource requirements. The list may be specified as a comma-separated list of hosts, a range of hosts (host[1-5,7,...] for example), or a filename. The host list will be assumed to be a filename if it contains a "/" character. If you specify a minimum node or processor count larger than can be satisfied by the supplied host list, additional resources will be allocated on other nodes as needed. Duplicate node names in the list will be ignored. The order of the node names in the list is not important; the node names will be sorted by Slurm.',
          'detail': 'See also: https://doc.zih.tu-dresden.de/jobs_and_resources/binding_and_distribution_of_tasks',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_nodelist'
        },
        'exclude': {
          'opt':  '--exclude',
          'text': 'Explicitly exclude certain nodes from the resources granted to the job.',
          'info': 'Explicitly exclude certain nodes from the resources granted to the job. Uses the same pattern as in --nodelist.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_exclude'
        },
        'distribution': {
          'opt':  '--distribution',
          'text': 'Specify alternate distribution methods for remote processes.',
          'info': 'This option controls the distribution of tasks to the nodes on which resources have been allocated and the distribution of those resources to tasks for binding (task affinity). The first distribution method (before the first ":") controls the distribution of tasks to nodes. The second distribution method (after the first ":") controls the distribution of allocated CPUs across sockets for binding to tasks. The third distribution method (after the second ":") controls the distribution of allocated CPUs across cores for binding to tasks. The second and third distributions apply only if task affinity is enabled. The third distribution is supported only if the task/cgroup plugin is configured. The default value for each distribution type is specified by *. <br><b>block:</b><br> The block distribution method will distribute tasks to a node such that consecutive tasks share a node. For example consider an allocation of three nodes each with two cpus. A four-task block distribution request will distribute those tasks to the nodes with tasks one and two on the first node task three on the second node and task four on the third node. Block distribution is the default behavior if the number of tasks exceeds the number of allocated nodes. <br><b>cyclic:</b><br> The cyclic distribution method will distribute tasks to a node such that consecutive tasks are distributed over consecutive nodes (in a round-robin fashion). For example consider an allocation of three nodes each with two cpus. A four-task cyclic distribution request will distribute those tasks to the nodes with tasks one and four on the first node task two on the second node and task three on the third node. Note that when SelectType is select/cons_res the same number of CPUs may not be allocated on each node. Task distribution will be round-robin among all the nodes with CPUs yet to be assigned to tasks. Cyclic distribution is the default behavior if the number of tasks is no larger than the number of allocated nodes. <br><b>plane:</b><br> The tasks are distributed in blocks of size <size>. The size must be given or SLURM_DIST_PLANESIZE must be set. The number of tasks distributed to each node is the same as for cyclic distribution but the taskids assigned to each node depend on the plane size. Additional distribution specifications cannot be combined with this option. For more details (including examples and diagrams) please see the mc_support document and https://slurm.schedmd.com/dist_plane.html <br><b>arbitrary:</b><br> The arbitrary method of distribution will allocate processes in-order as listed in file designated by the environment variable SLURM_HOSTFILE. If this variable is listed it will over ride any other method specified. If not set the method will default to block. Inside the hostfile must contain at minimum the number of hosts requested and be one per line or comma separated. If specifying a task count (-n --ntasks=<number>) your tasks will be laid out on the nodes in the order of the file. <br>NOTE: The arbitrary distribution option on a job allocation only controls the nodes to be allocated to the job and not the allocation of CPUs on those nodes. This option is meant primarily to control a job step\'s task layout in an existing job allocation for the srun command. <br>NOTE: If the number of tasks is given and a list of requested nodes is also given the number of nodes used from that list will be reduced to match that of the number of tasks if the number of nodes in the list is greater than the number of tasks.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_distribution'
        },
        'distribution2': {
          'opt':  '--distribution',
          'text': 'Specify alternate distribution methods for remote processes.',
          'info': 'Second distribution method (distribution of CPUs across sockets for binding): <br><b>block:</b><br> The block distribution method will distribute allocated CPUs consecutively from the same socket for binding to tasks before using the next consecutive socket. <br><b>cyclic:</b><br> The cyclic distribution method will distribute allocated CPUs for binding to a given task consecutively from the same socket and from the next consecutive socket for the next task in a round-robin fashion across sockets. Tasks requiring more than one CPU will have all of those CPUs allocated on a single socket if possible. <br><b>fcyclic:</b><br> The fcyclic distribution method will distribute allocated CPUs for binding to tasks from consecutive sockets in a round-robin fashion across the sockets. Tasks requiring more than one CPU will have each CPUs allocated in a cyclic fashion across sockets.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_distribution'
        },
        'contiguous': {
          'opt':  '--contiguous',
          'text': 'If set, then the allocated nodes must form a contiguous set.',
          'info': 'If set then the allocated nodes must form a contiguous set. <br>NOTE: If SelectPlugin=cons_res this option won\'t be honored with the topology/tree or topology/3d_torus plugins both of which can modify the node ordering.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_contiguous'
        },
        'exclusive': {
          'opt':  '--exclusive',
          'text': 'The job allocation can not share nodes with other running job. Exclusive usage of compute nodes; you will be charged for all CPUs/cores on the node',
          'info': 'The job allocation can not share nodes with other running jobs (or just other users with the "=user" option or with the "=mcs" option). If user/mcs are not specified (i.e. the job allocation can not share nodes with other running jobs) the job is allocated all CPUs and GRES on all nodes in the allocation but is only allocated as much memory as it requested. This is by design to support gang scheduling because suspended jobs still reside in memory. To request all the memory on a node use --mem=0. The default shared/exclusive behavior depends on system configuration and the partition\'s OverSubscribe option takes precedence over the job\'s option. <br>NOTE: Since shared GRES (MPS) cannot be allocated at the same time as a sharing GRES (GPU) this option only allocates all sharing GRES and no underlying shared GRES.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_exclusive'
        },
        'nomultithread': {
          'opt':  '--hint=nomultithread',
          'text': '[don\'t] use extra threads with in-core multi-threading which can benefit communication intensive applications.',
          'info': '[don\'t] use extra threads with in-core multi-threading which can benefit communication intensive applications. nomultithread implies --threads-per-core=1.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_[no]multithread'
        },
        'nomonitoring': {
          'opt':  '--hint=no_monitoring',
          'text': 'Disable PIKA monitoring. <br>NOTE: This is only possible for exclusive jobs since PIKA runs on a per-node basis.',
          'info': 'If users wish to perform their own measurement of performance counters using performance tools other than PIKA it is recommended to disable PIKA monitoring. This can be done using the following Slurm flags --exclusive --hint=no_monitoring.',
          'link': 'https://doc.zih.tu-dresden.de/software/pika/'
        },
        'reservation': {
          'opt':  '--reservation',
          'text': 'Allocate resources for the job from the named reservation.',
          'info': 'Allocate resources for the job from the named reservation. If the job can use more than one reservation specify their names in a comma separate list and the one offering earliest initiation. Each reservation will be considered in the order it was requested. All reservations will be listed in scontrol/squeue through the life of the job. In accounting the first reservation will be seen and after the job starts the reservation used will replace it.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_reservation'
        },
        'executable': {
          'opt':  'executable',
          'text': 'Relative or absolute path to the application\'s binary.',
          'info': 'SCRIPT PATH RESOLUTION The batch script is resolved in the following order: 1. If script starts with "." then path is constructed as: current working directory / script 2. If script starts with a "/" then path is considered absolute. 3. If script is in current working directory. 4. If script can be resolved through PATH. See path_resolution(7).',
          'link': 'https://slurm.schedmd.com/sbatch.html#SECTION_SCRIPT-PATH-RESOLUTION'
        },
        'srun': {
          'opt':  'srun',
          'text': 'Check this box if the application has a configuration file and the execute command, e.g. `srun ./myapp` is included in it. Make sure to replace mpirun in the configuration to avoid struggles.',
          'info': 'srun handling. If you have e.g. downloaded a software project that runs with a configuration file, it is likely that the execution command is already included in it. In this case, make sure that it says srun (instead of mpirun) and check this box so srun doesn\'t appear a second time in the batch script. When both the configuration and the batch script call srun, this results in unexpected behavior of the app and has a high chance of job abortion.',
          'link': 'https://slurm.schedmd.com/sbatch.html#SECTION_SCRIPT-PATH-RESOLUTION'
        },
        'one-output': {
          'opt':  'merge output',
          'text': 'By default both standard output and standard error are directed to the same file.',
          'info': 'By default (box checked) both standard output and standard error are directed to the same file.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_output'
        },
        'output-file': {
          'opt':  '--output',
          'text': 'Save normal output (stdout) to file (default: slurm-%j.out)',
          'info': 'Instruct Slurm to connect the batch script\'s standard output directly to the file name specified in the "filename pattern". By default both standard output and standard error are directed to the same file. For job arrays the default file name is "slurm-%A_%a.out" "%A" is replaced by the job ID and "%a" with the array index. For other jobs the default file name is "slurm-%j.out" where the "%j" is replaced by the job ID. See the filename pattern section below for filename specification options.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_output'
        },
        'error-file': {
          'opt':  '--error',
          'text': 'Save error output (stderr) to file (default: slurm-%j.err)',
          'info': 'Instruct Slurm to connect the batch script\'s standard error directly to the file name specified in the "filename pattern". By default both standard output and standard error are directed to the same file. For job arrays the default file name is "slurm-%A_%a.out" "%A" is replaced by the job ID and "%a" with the array index. For other jobs the default file name is "slurm-%j.out" where the "%j" is replaced by the job ID. See the filename pattern section below for filename specification options.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_error'
        },
        'array': {
          'opt':  '--array',
          'text': 'Submit a job array, multiple jobs to be executed with identical parameters. The indexes specification identifies what array index values should be used.',
          'info': 'Submit a job array multiple jobs to be executed with identical parameters. The indexes specification identifies what array index values should be used. Multiple values may be specified using a comma separated list and/or a range of values with a "-" separator. For example "--array=0-15" or "--array=0 6 16-32". A step function can also be specified with a suffix containing a colon and number. For example "--array=0-15:4" is equivalent to "--array=0 4 8 12". A maximum number of simultaneously running tasks from the job array may be specified using a "%" separator. For example "--array=0-15%4" will limit the number of simultaneously running tasks from this job array to 4. The minimum index value is 0. the maximum value is one less than the configuration parameter MaxArraySize. <br>NOTE: currently federated job arrays only run on the local cluster.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_array'
        },
        'dependency': {
          'opt':  '--dependency',
          'text': 'Defer the start of this job until the specified dependencies have been satisfied completed.',
          'info': "after:job_id[[+time][:jobid[+time]...]]<br> After the specified jobs start or are cancelled and 'time' in minutes from job start or cancellation happens this job can begin execution. If no 'time' is given then there is no delay after start or cancellation.<br><br> afterany:job_id[:jobid...]<br> This job can begin execution after the specified jobs have terminated. This is the default dependency type.<br><br> afterburstbuffer:job_id[:jobid...]<br> This job can begin execution after the specified jobs have terminated and any associated burst buffer stage out operations have completed.<br><br> aftercorr:job_id[:jobid...]<br> A task of this job array can begin execution after the corresponding task ID in the specified job has completed successfully (ran to completion with an exit code of zero).<br><br> afternotok:job_id[:jobid...]<br> This job can begin execution after the specified jobs have terminated in some failed state (non-zero exit code node failure timed out etc).<br><br> afterok:job_id[:jobid...]<br> This job can begin execution after the specified jobs have successfully executed (ran to completion with an exit code of zero).<br><br> singleton<br> This job can begin execution after any previously launched jobs sharing the same job name and user have terminated. In other words only one job by that name and owned by that user can be running or suspended at any point in time. In a federation a singleton dependency must be fulfilled on all clusters unless DependencyParameters=disable_remote_singleton is used in slurm.conf.",
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_dependency'
        },
        'ws-alloc': {
          'opt':  'Workspace Allocation',
          'text': 'Allocate workspace before running the job',
          'info': 'For the article about workspaces see the link below.',
          'link': 'https://doc.zih.tu-dresden.de/data_lifecycle/workspaces/'
        },
        'filesystem': {
          'opt':  'Filesystems',
          'text': 'Choose a filesystem',
          'info': 'For an overview of the different filesystems see the link below.',
          'link': 'https://doc.zih.tu-dresden.de/data_lifecycle/file_systems/#work-directories'
        },
        'ws-name': {
          'opt':  'Workspace name',
          'text': 'Workspace name',
          'info': 'Valid characters for workspace names are only alphanumeric characters, -, ., and _. Workspace name has to start with an alphanumeric character.',
          'link': 'https://doc.zih.tu-dresden.de/data_lifecycle/workspaces/#allocate-a-workspace'
        },
        'duration': {
          'opt':  'Workspace Duration',
          'text': 'Duration in days',
          'info': 'Set the duration of the workspace in days.',
          'link': 'https://doc.zih.tu-dresden.de/data_lifecycle/workspaces/#allocate-a-workspace'
        },
        'ws-delete': {
          'opt':  'Workspace Deletion',
          'text': 'Release workspace after the job has finished.',
          'info': 'All job results and errors will be zipped and put to your home directory so that the workspace can be deleted as a final step.',
          'link': 'https://doc.zih.tu-dresden.de/data_lifecycle/workspaces/#deletion-of-a-workspace'
        },
        'chdir': {
          'opt':  '--chdir',
          'text': 'Set the working directory of the batch script before it is executed.',
          'info': 'Set the working directory of the batch script to directory before it is executed. The path can be specified as full path or relative path to the directory where the command is executed.',
          'link': 'https://slurm.schedmd.com/sbatch.html#OPT_chdir'
        },
        'module': {
          'opt':  'module list',
          'text': 'List loaded software modules',
          'info': 'If checked, the command `module list` is added which prints the loaded software modules to detect possible discrepancies.',
          'link': 'https://doc.zih.tu-dresden.de/software/modules/#module-environments'
        }
      };

      // dictionary for the max values
      var maxValues = {
        'nodes': 1,
        'tasks': 1,
        'tasks-per-node': 1,
        'cpus': 1,
        'gpus': 0,
        'gpus-per-task': 0,
        'mem': 1,
        'duration': 1
      };

      // dictionary for the min values
      var minValues = {
        'nodes': 1,
        'tasks': 1,
        'tasks-per-node': 1,
        'cpus': 1,
        'gpus': 0,
        'gpus-per-task': 0,
        'mem': 1,
        'duration': 1
      };

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
        if (document.getElementById('account').value !== '') {
          outputText.innerText += '\n#SBATCH --account=\"'
          + document.getElementById('account').value + '\"';
        }
        if (hasValue('mail-user') && !isHidden('mail-user-info')) {
          outputText.innerText += '\n#SBATCH --mail-user='
          + document.getElementById('mail-user').value
          + '\n#SBATCH --mail-type=';
          const mailprops = ['begin', 'end', 'fail', 'timelimit50',
          'timelimit80',  'timelimit90', 'stage-out', 'inv-depend', 'all']
          mailprops.forEach(function(prop) {
            if (document.getElementById(prop).checked === true) {
              if (outputText.innerText.slice(-1) !== '=') {
                outputText.innerText += ',';
              }
              outputText.innerText += document.getElementById(prop).value;
            }
          });
        }
        if (document.getElementById('timelimit').value !== '') {
          outputText.innerText += '\n#SBATCH --time='
          + document.getElementById('timelimit').value;
        } else {
          outputText.innerText += '\n#SBATCH --time='
          + limitsPartition[document.getElementById('partition').value]['DefaultTime'];
        }
        if (hasValue('begin-job') && !isHidden('begin-job-info')) {
          outputText.innerText += '\n#SBATCH --begin='
          + document.getElementById('begin-job').value;
        }
        if (hasValue('deadline') && !isHidden('deadline-info')) {
          outputText.innerText += '\n#SBATCH --deadline='
          + document.getElementById('deadline').value;
        }
        outputText.innerText += '\n#SBATCH --partition='
        + document.getElementById('partition').value;
        if (document.getElementById('nodes').value !== '') {
          outputText.innerText += '\n#SBATCH --nodes=' + document.getElementById('nodes').value;
        }
        if (hasValue('tasks') && !isHidden('tasks-info')) {
          outputText.innerText += '\n#SBATCH --ntasks='
          + document.getElementById('tasks').value;
        }
        if (document.getElementById('tasks-per-node').value !== '') {
          outputText.innerText += '\n#SBATCH --ntasks-per-node='
          + document.getElementById('tasks-per-node').value;
        }
        if (document.getElementById('cpus').value !== '') {
          outputText.innerText += '\n#SBATCH --cpus-per-task='
          + document.getElementById('cpus').value;
        }
        if (document.getElementById('mem').value !== '') {
          outputText.innerText += '\n#SBATCH --mem-per-cpu='
          + document.getElementById('mem').value
          + document.getElementById('byte').value;
        }
        if (document.getElementById('gpus').value !== '') {
          outputText.innerText += '\n#SBATCH --gres=gpu:'
          + document.getElementById('gpus').value;
        }
        if (document.getElementById('gpus-per-task').value !== '') {
          outputText.innerText += '\n#SBATCH --gpus-per-task='
          + document.getElementById('gpus-per-task').value;
        }
        if (hasValue('nodelist') && !isHidden('nodelist-info')) {
          outputText.innerText += '\n#SBATCH --nodelist='
          + document.getElementById('nodelist').value;
        }
        if (hasValue('exclude') && !isHidden('exclude-info')) {
          outputText.innerText += '\n#SBATCH --exclude='
          + document.getElementById('exclude').value;
        }
        if (hasValue('distribution') && !isHidden('distribution-info')) {
          outputText.innerText += '\n#SBATCH --distribution='
          + document.getElementById('distribution').value;
          if (document.getElementById('distribution-option').value !== '') {
            outputText.innerText += document.getElementById('distribution-option').value;
          }
          if (document.getElementById('distribution2').value !== 'none') {
            outputText.innerText += document.getElementById('distribution2').value;
          }
        }
        if (hasValue('contiguous') && !isHidden('contiguous-info')) {
          outputText.innerText += '\n#SBATCH --contiguous';
        }
        if (document.getElementById('exclusive').checked === true) {
          outputText.innerText += '\n#SBATCH --exclusive';
        }
        if (document.getElementById('nomultithread').checked === true) {
          outputText.innerText += '\n#SBATCH --hint=nomultithread';
        }
        if (hasValue('nomonitoring') && !isHidden('nomonitoring-info')) {
          outputText.innerText += '\n#SBATCH --hint=no_monitoring';
        }
        if (document.getElementById('reservation').value !== '') {
          outputText.innerText += '\n#SBATCH --reservation='
          + document.getElementById('reservation').value;
        }
        if (document.getElementById('output-file').value !== '') {
          outputText.innerText += '\n#SBATCH --output='
          + document.getElementById('output-file').value;
        }
        if (hasValue('error-file') && !isHidden('error-file-info')) {
          outputText.innerText += '\n#SBATCH --error='
          + document.getElementById('error-file').value;
        }
        if (hasValue('chdir') && !isHidden('chdir-info')) {
          outputText.innerText += '\n#SBATCH --chdir='
          + document.getElementById('chdir').value;
        }
        if (hasValue('array') && !isHidden('array-info')) {
          outputText.innerText += '\n#SBATCH --array='
          + document.getElementById('array').value;
        }
        if (hasValue('dependency') && !isHidden('dependency-info')) {
          outputText.innerText += '\n#SBATCH --dependency='
          + document.getElementById('dependency').value;
          if (document.getElementById('dependency').value !== 'singleton') {
            outputText.innerText += ':' + document.getElementById('jobid').value;
          }
        }

        outputText.innerText += '\n\n# software environment';
        outputText.innerText += '\n# module load ';
        if (document.getElementById('partition').value === 'alpha' ||
            document.getElementById('partition').value === 'romeo') {
              outputText.innerText += 'modenv/hiera ';
            } else if (document.getElementById('partition').value === 'ml') {
              outputText.innerText += 'modenv/ml ';
            }
        outputText.innerText += '<module1 module2/version>\n';
        if (document.getElementById('module').checked) {
          outputText.innerText += 'module list\n';
        }

        if (document.getElementById('ws-alloc').checked) {
          outputText.innerText += '\n# Allocate workspace as working directory';
          outputText.innerText += '\nWSNAME='
          + document.getElementById('ws-name').value.trim() + '_${SLURM_JOB_ID}';
          outputText.innerText += '\nexport WSDIR=$(ws_allocate -F '
          + document.getElementById('filesystem').value
          + ' -n ${WSNAME} -d '
          + document.getElementById('duration').value
          + ')';

          outputText.innerText += '\n# Check allocation and change directory';
          outputText.innerText += '\nif [ -z "${WSDIR}" ] ; then';
          outputText.innerText += '\n    echo "Error: Cannot allocate workspace ${WSNAME}"'
          outputText.innerText += ' && exit 1';
          outputText.innerText += '\nelse';
          outputText.innerText += '\n    cd ${WSDIR}';
          outputText.innerText += '\n    echo "Current working directory: ${WSDIR}"';
          outputText.innerText += '\nfi\n';
        }

        outputText.innerText += '\n\n# Execute parallel application\n'
        if (document.getElementById('executable').value === '') {
          outputText.innerText += '# ';
        }
        if (document.getElementById('srun').value !== '') {
          outputText.innerText += document.getElementById('srun').value + ' ';
        }
        if (document.getElementById('executable').value !== '') {
          if (document.getElementById('executable').value.toString().slice(0,1) !== '/') {
            outputText.innerText += './';
          }
          outputText.innerText += document.getElementById('executable').value;
        } else {
          outputText.innerText += '<application>';
        }

        if (document.getElementById('ws-alloc').checked &&
            document.getElementById('ws-delete').checked) {
          outputText.innerText += '\n\n# Compress results with bzip2 (which includes CRC32 checksums) for saving';
          outputText.innerText += '\nZIP_SUCCESS=$(bzip2 --compress --stdout -4 "${WSDIR}" > ${HOME}/${SLURM_JOB_ID}.bz2)\n';

          outputText.innerText += '\n# Clean up workspace';
          outputText.innerText += '\nif [ ${ZIP_SUCCESS} -eq 0 ]; then';
          outputText.innerText += '\n    if [ -d ${WSDIR} ] && rm -rf ${WSDIR}/*';
          outputText.innerText += '\n    # Reduce grace period to 1 day';
          outputText.innerText += '\n    ws_release -F '
                                  + document.getElementById('filesystem').value
                                  + ' ${WSNAME}';
          outputText.innerText += '\nelse'
          outputText.innerText += '\n    echo "Error while compressing and/or writing results"'
          outputText.innerText += '\n    echo "Please check the folder ${WSDIR} for any'
                                  + ' (partial?) results."';
          outputText.innerText += '\n    exit 1';
          outputText.innerText += '\nfi';
        }
      }

      function validateTimelimit() {
        // walltime: Check if value is set
        let elem = document.getElementById('timelimit')
        elem.style.backgroundColor = '';
        let walltime = elem.value.trim()
        if (walltime) {
          // minutes, minutes:seconds, hours:minutes:seconds
          let re_minutes = /^([0-9]+:)?[0-9]+(:[0-9]+)?$/;
          // days-hours, days-hours:minutes and days-hours:minutes:seconds
          let re_days = /^[0-9]+-[0-9]+(:[0-9]+){0,2}$/;
          if (!re_minutes.test(walltime) &&
              !re_days.test(walltime)) {
            elem.style.backgroundColor = 'rgb(255, 121, 121)';
            return false;
          }
        }
        return true;
      }

      const validateEmailString = (email) => {
        return String(email)
          .toLowerCase()
          .match(
            /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
          );
      };

      function validateEmail() {
        let elem = document.getElementById('mail-user')
        elem.style.backgroundColor = '';
        let email = elem.value.trim()
        if (hasValue('mail-user') && !isHidden('mail-user-info')) {
          // if checked type but empty email or invalid email
          if (! email || !validateEmailString(email)) {
            elem.style.backgroundColor = 'rgb(255, 121, 121)';
            return false;
          }
        } else {
          // If email is given but no Type is selected
          if (email) {
            elem.style.backgroundColor = 'rgb(255, 121, 121)';
            return false;
          }
        }
        return true;
      }

      function validateArray() {
        // walltime: Check if value is set
        let elem = document.getElementById('array')
        elem.style.backgroundColor = '';
        let array = elem.value.trim()
        let reArray = /^[0-9]+(-[0-9]+)?(,[0-9]+(-[0-9]+)?)*(:[0-9]+)?(%[0-9]+)?$/;
        // If array is filled, check validity
        if (array) {
          if (!reArray.test(array)) {
            elem.style.backgroundColor = 'rgb(255, 121, 121)';
            return false;
          }
        }
        return true;
      }

      function validateWorkspace() {
        // Workspace name can consist of alphanumeric characters, -, ., and _.
        // Has to start with alphanumerical character.
        let elem = document.getElementById('ws-name')
        elem.style.backgroundColor = '';
        let ws_name = elem.value.trim()
        let re_allowed = /^[a-zA-Z0-9][a-zA-Z0-9\-\.\_]*$/;
        if (!re_allowed.test(ws_name)) {
          elem.style.backgroundColor = 'rgb(255, 121, 121)';
          return false;
        }
        return true;
      }


      /**
       * Verify if all values are correct, if yes it prints the output, else it highlights incorrect values
       */
      var validateAllFields = function() {
        let allFieldsValid = true;
        if (!validateTimelimit()) {
          allFieldsValid = false;
        }
        if (!validateEmail()) {
          allFieldsValid = false;
        }
        if (!validateArray()) {
          allFieldsValid = false;
        }


        if (allFieldsValid === true) {
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
        let appname = 'app';
        if (hasValue('executable')) {
          appname = document.getElementById('executable').value.split('/').reverse()[0];
        } else {
          appname = 'to_' + document.getElementById('partition').value;
        }
        a.download = 'submit_' + appname + '.sh';
        document.body.appendChild(a);
        // activate the link
        a.click();
        // remove link after some time
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }, 0);
      });


      // Function to hide/expand advanced opitons
      var toggleAdvanced = function () {
        let advanced = document.getElementsByClassName('row advanced');
        [].forEach.call(advanced, function (row) {
          if (document.getElementById('radio-basic').checked === true) {
            row.style.cssText = 'display:none !important';
            document.getElementById('array-button').style.display = 'none';
          } else if (document.getElementById('radio-advanced').checked === true) {
            row.style.cssText = 'display:flex !important';
            document.getElementById('array-button').style.display = '';
          }
        })
        toggleMail();
        toggleAllocation();
      }

      // show the mail address field if one of the mail checkboxes has been activated
      var toggleMail = function () {
        if (document.getElementById('begin').checked ||
            document.getElementById('end').checked ||
            document.getElementById('fail').checked) {
          document.getElementById('mail-user-info').style.cssText = 'display:flex !important';
        } else if ((document.getElementById('radio-advanced').checked === true) && (
          document.getElementById('timelimit50').checked === true ||
          document.getElementById('timelimit80').checked === true ||
          document.getElementById('timelimit90').checked === true ||
          document.getElementById('stage-out').checked === true ||
          document.getElementById('inv-depend').checked === true ||
          document.getElementById('all').checked === true )
        ) {
          document.getElementById('mail-user-info').style.cssText = 'display:flex !important';
        } else {
          document.getElementById('mail-user-info').style.cssText = 'display:none !important';
        }
      }

      var mailInfoChange = function () {
        // uncheck 'ALL' if one mail option is checked
        document.getElementById('all').checked = false;
      }

      // display information according to the active field in the right info panel
      var fillInfoPanel = function (row) {
        // content only works with no line break
        content = "<p><b>" + info[row]['opt'] + "</b><br><br>" + info[row]['info'] + '<br><br><a target="_blank" rel="noopener noreferrer" href="' + info[row]['link'] + '" style="color:#002557;">' + info[row]['link'] + '</a></p>';
        document.getElementById('info').innerHTML = content;
      }

      // deactivate mail options if option 'all' is checked
      document.getElementById('all').addEventListener('change', function () {
        if (document.getElementById('all').checked) {
          document.getElementById('begin').checked = false;
          document.getElementById('end').checked = false;
          document.getElementById('fail').checked = false;
          document.getElementById('timelimit50').checked = false;
          document.getElementById('timelimit80').checked = false;
          document.getElementById('timelimit90').checked = false;
          document.getElementById('stage-out').checked = false;
          document.getElementById('inv-depend').checked = false;
        }
      });

      // remove the field for seperate error output if checkbox for single output file is active
      document.getElementById('one-output').addEventListener('change', function () {
        if (document.getElementById('one-output').checked) {
          document.getElementById('error-file-info').style.display = 'none';
          document.getElementById('error-file-info').value = '';
        } else {
          document.getElementById('error-file-info').style.display = '';
        }
      });

      // set wether or not srun is used in the execute command
      document.getElementById('srun').addEventListener('change', function () {
        if (document.getElementById('srun').checked) {
          document.getElementById('srun').value = '';
        } else {
          document.getElementById('srun').value = "srun";
        }
      });

      // function to show workspace div if checkbox is active
      var toggleAllocation = function () {
        let hidden = document.getElementsByClassName('row hidden');
        let display = document.getElementById('ws-alloc').checked ? 'display:flex !important' : 'display:none !important';
        [].forEach.call(hidden, function (row) {
          row.style.cssText = display;
        })
        // also show/hide ws info panel
        document.getElementById('ws-info-panel').style.cssText = display;
        // hide --chdir if workspace allocation is checked
        if (document.getElementById('ws-alloc').checked) {
          document.getElementById('chdir-info').style.display = 'none';
          setLimitDuration();
        } else if (document.getElementById('radio-advanced').checked) {
          document.getElementById('chdir-info').style.display = 'flex';
        }
      }

      // hide --duration if ws clean-up is checked
      document.getElementById('ws-delete').addEventListener('change', function () {
        if (document.getElementById('ws-delete').checked) {
          document.getElementById('duration-info').style.display = 'none';
          document.getElementById('duration').value = minValues['duration'];
        } else {
          document.getElementById('duration-info').style.cssText = 'display:flex !important';
        }
      });

      /**
       * Function to fill the information panel about the currently selected partition
       */
      var fillPartitionInfo = function() {
        let partition = document.getElementById('partition').value;
        let partitionLimits = limitsPartition[partition];

        document.getElementById('td-partition').innerHTML = '<b>'+partition+'</b>';

        const fields = ['nodes', 'Cores', 'HTCores', 'MemoryPerCore', 'MemoryPerNode', 'GPUsPerNode'];
        [].forEach.call(fields, function(attr) {
          document.getElementById('td-'+attr).innerText = partitionLimits[attr];
        });
      }

      /**
       * Function to fill the information panel about the currently selected filesystem partition
       */
       var fillWsInfo = function() {
        let ws = document.getElementById('filesystem').value;
        let wsLimits = limitsWorkspace[ws];

        document.getElementById('td-filesystem').innerHTML = '<b>'+ws+'</b>';

        const fields = ['size', 'duration', 'extensions'];
        [].forEach.call(fields, function(attr) {
          document.getElementById('td-'+attr).innerText = wsLimits[attr];
        });
      }

      // Move the partition info box into the right panel
      //document.getElementsByClassName('md-sidebar__scrollwrap')[1].appendChild(document.getElementsByClassName('partition-info')[0]);

      // Move the info box into the right panel
      document.getElementsByClassName('md-sidebar__scrollwrap')[1].appendChild(document.getElementById('info'));

      /**
       * Function to fill the tooltip about the partitions
       */
      var fillTooltips = function() {
        for (const [key, value] of Object.entries(limitsPartition)) {
          let panelText = document.getElementById(key);
          let partitionLimits = limitsPartition[key];

          panelText.title = partitionLimits['info'];
          panelText.title += '\nNodes: ' + partitionLimits['nodes'];
          panelText.title += '\nCores per node: ' + partitionLimits['Cores'];
          panelText.title += '\nHyper threading: ' + partitionLimits['HTCores'];
          panelText.title += '\nRAM per core: ' + partitionLimits['MemoryPerCore'] + ' MB';
          panelText.title += '\nRAM per node: ' + partitionLimits['MemoryPerNode'] + ' MB';
          panelText.title += '\nGPUs per node: ' + partitionLimits['GPUsPerNode'];
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
        panelText.title += '\nEmpty the field if unneeded';

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

      // function to check if element has an empty value
      var hasValue = function (element) {
        if (typeof(element) === 'string') {
          element = document.getElementById(element);
        }
        if (element.type === "checkbox") {
          return element.checked;
        }
        if (element.value !== '' && element.value !== 'none') {
              return true;
            }
        return false;
      }

      // function to check hidden/visible status
      var isHidden = function (element) {
        if (typeof(element) === 'string') {
          element = document.getElementById(element);
        }
        if (element.style.cssText === 'display:none' ||
            element.style.display === 'none') {
              return true;
            }
        return false;
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
        minValues['nodes'] = 1;
        if (
          document.getElementById('tasks').value !== ''
          && document.getElementById('tasks-per-node').value !== ''
          ) {
          let tasks = getValue('tasks', 'min');
          let tasksPerNode = getValue('tasks-per-node', 'min');
          minValues['nodes'] = Math.ceil(tasks / tasksPerNode);
          maxValues['nodes'] = Math.ceil(tasks / tasksPerNode);
        } else if ( document.getElementById('tasks').value !== '') {
          maxValues['nodes'] = Math.min(document.getElementById('tasks').value, getValue('tasks-per-node', 'max'))
        }

        // show min/max in tooltip
        setTooltips('nodes');
      }

      /**
       * Set the limits for the ntasks field
       */
      var setLimitTasks = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        let nodes = getValue('nodes', 'max');
        let taskPerNode = getValue('tasks-per-node', 'max');
        // multithreading
        let corelimit = document.getElementById('nomultithread').checked === true ? 'Cores' : 'HTCores';

        minValues['tasks'] = 1;
        maxValues['tasks'] = nodes * partitionLimits[corelimit];
        // limit if nodes is set
        if (document.getElementById('nodes').value !== '') {
          let tasks = taskPerNode * document.getElementById('nodes').value;
          minValues['tasks'] = document.getElementById('nodes').value;
          maxValues['tasks'] = tasks;
          if (document.getElementById('tasks-per-node').value !== '') {
            document.getElementById('tasks').placeholder = '[='+tasks+']';
            maxValues['tasks'] = document.getElementById('tasks-per-node').value * nodes;
          }
        }
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
        let limit = document.getElementById('nomultithread').checked === true ? 'Cores' : 'HTCores';
        maxValues['tasks-per-node'] = partitionLimits[limit];
        document.getElementById('tasks-per-node').max = partitionLimits[limit];

        //set min
        minValues['tasks-per-node'] = 1;
        nodes = document.getElementById('nodes').value;
        tasks = document.getElementById('tasks').value;
        if (nodes !== '' && tasks !== '') {
          minValues['tasks-per-node'] = Math.ceil(tasks / nodes);
        }

        // set min and max for --mincpus if gpus are allocated
        if (
          document.getElementById('gpus').value !== ''
          && document.getElementById('nodes').value !== ''
          && document.getElementById('tasks').value !== ''
        ) {
          minValues['tasks-per-node'] = Math.ceil(tasks / nodes);
          nodes = getValue('nodes', 'max');
          tasks = getValue('tasks', 'max');
          maxValues['tasks-per-node'] = Math.floor(tasks / nodes);
        }
        // set tooltips
        setTooltips('tasks-per-node');
      }

      /**
       * Set the limits for cpu per task field
       */
       var setLimitCpu = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];

        let nodes = getValue('nodes', 'max');
        let tasks = getValue('tasks', 'max');
        let tasksPerNode = getValue('tasks-per-node', 'max');
        // multithreading
        let limit = document.getElementById('nomultithread').checked === true ? 'Cores' : 'HTCores';

        // set max
        maxValues['cpus'] = [partitionLimits[limit]];
        document.getElementById('cpus').max = partitionLimits[limit];

        if (document.getElementById('tasks-per-node').value !== '') {
          maxValues['cpus'] = Math.floor(partitionLimits[limit] / document.getElementById('tasks-per-node').value);
        } else if (document.getElementById('tasks').value !== '') {
          maxValues['cpus'] = Math.floor(partitionLimits[limit] / (1 + Math.floor( (document.getElementById('tasks').value - 1) / partitionLimits['nodes'])));
        }
        // set max for cpus if gpus are set
        if (
          document.getElementById('gpus').value !== ''
          && document.getElementById('gpus').value !== '0'
          && document.getElementById('exclusive').checked !== true
        ) {
          let gpus = getValue('gpus', 'max');
          maxValues['cpus'] = Math.floor(gpus / partitionLimits['GPUsPerNode'] * partitionLimits[limit]);
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
        maxValues['gpus'] = partitionLimits['GPUsPerNode'];
        setTooltips('gpus');
        //set min
        if (document.getElementById('gpus-per-task').value !== '') {
          let tasks = getValue('tasks', 'min');
          let nodes = getValue('nodes', 'min');
          let gpusPerTask = getValue('gpus-per-task', 'min');
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
        let tasksNode = getValue('tasks-per-node', 'max');
        let nodes = getValue('nodes', 'max');

        // set new max
        let maxValue = [partitionLimits['GPUsPerNode']];
        if (tasks !== '') {
          maxValue.push(Math.floor(partitionLimits['GPUsPerNode'] / Math.ceil(Number(tasks) / Number(nodes))));
        }
        if (tasksNode !== '') {
          maxValue.push(Math.floor(partitionLimits['GPUsPerNode'] / Number(document.getElementById('tasks-per-node').value)));
        }
        maxValues['gpus-per-task'] = Math.min.apply(null, maxValue);
        // set tooltips for new limits
        setTooltips('gpus-per-task');
      }

      /**
       * Update the max for memory per cpu values
       */
      var setLimitMem = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];
        maxValues['mem'] = partitionLimits['MemoryPerCore'];
        if (document.getElementById('nomultithread').checked === true) {
          maxValues['mem'] *= partitionLimits['ThreadsPerCore'];
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
        let workspaceLimits = limitsWorkspace[document.getElementById('filesystem').value];
        // set new max
        maxValues['duration'] = workspaceLimits['duration'];
        document.getElementById('duration').max = workspaceLimits['duration'];

        // get days and hours from walltime
        let reArray = /^(([0-9]{1,3})-)?([0-9]{2}):([0-9]{2}):([0-9]{2})$/;
        let match = reArray.exec(document.getElementById('timelimit').value);
        if (match === null) {
          setTooltips('duration');
          return;
        }
        // if days are defined or not
        minValues['duration'] = Math.ceil((Number(match[3])+1) / 24);
        if (match[2]) {
          minValues['duration'] += Number(match[2]);
        }
        // set tooltips for new limits
        setTooltips('duration');
        // update ws info panel
        fillWsInfo();
      }

      /**
       * Update the value und max for CPU and GPU values
       */
      var LimitChange = function() {
        setLimitNodes();
        setLimitTasks();
        setLimitTasksPerNode();
        setLimitCpu();
        if (document.getElementById('gpus-info').style.display !== 'none') {
          setLimitGpu();
          setLimitGpuPerTask();
        }
        setLimitMem();
      }

      /**
       * Function to trigger updates, if partion was changed
       */
      var partitionLimitChange = function() {
        // get partition limits from dictionary
        let partitionLimits = limitsPartition[document.getElementById('partition').value];
        // hide the GPU field, if partition do not have GPUs
        if (partitionLimits['GPUsPerNode'] === 0) {
          document.getElementById('gpus-info').style.display = 'none';
          document.getElementById('gpus-per-task-info').style.display = 'none';
          document.getElementById('gpus').value = '';
          document.getElementById('gpus-per-task').value = '';
        } else {
          document.getElementById('gpus-info').style.display = '';
          document.getElementById('gpus-per-task-info').style.display = '';
        }
        // hide the multithreading field if it isnt supported
        if (partitionLimits['ThreadsPerCore'] === 1) {
          document.getElementById('nomultithread-info').style.display = 'none';
          document.getElementById('nomultithread').checked = true;
        } else {
          document.getElementById('nomultithread-info').style.display = '';
        }
        // update other values
        LimitChange();
        document.getElementById('nodes').max = partitionLimits['nodes'];
        document.getElementById('gpus').max = partitionLimits['GPUsPerNode'];
        document.getElementById('gpus-per-task').max = partitionLimits['GPUsPerNode'];
        // update partition info panel
        fillPartitionInfo();
      }

      // set up event listeners, if field change
      document.getElementById('radio-basic').addEventListener('change', toggleAdvanced);
      document.getElementById('radio-advanced').addEventListener('change', toggleAdvanced);
      document.getElementById('mail-info').addEventListener('change', function () {toggleMail(); mailInfoChange(); fillInfoPanel('mail')});
      document.getElementById('mail-info2').addEventListener('change', function () {toggleMail(); mailInfoChange(); fillInfoPanel('mail')});
      document.getElementById('mail-info3').addEventListener('change', function () {toggleMail(); fillInfoPanel('mail')});
      document.getElementById('stage-out').addEventListener('change', mailInfoChange);
      document.getElementById('inv-depend').addEventListener('change', mailInfoChange);
      document.getElementById('timelimit').addEventListener('change', validateTimelimit);
      document.getElementById('partition').addEventListener('change', partitionLimitChange);
      document.getElementById('nodes').addEventListener('change', LimitChange);
      document.getElementById('tasks').addEventListener('change', LimitChange);
      document.getElementById('tasks-per-node').addEventListener('change', LimitChange);
      document.getElementById('cpus').addEventListener('change', LimitChange);
      document.getElementById('gpus').addEventListener('change', LimitChange);
      document.getElementById('gpus-per-task').addEventListener('change', LimitChange);
      document.getElementById('mem').addEventListener('change', LimitChange);
      document.getElementById('byte').addEventListener('change', setLimitMem);
      document.getElementById('exclusive').addEventListener('change', LimitChange);
      document.getElementById('nomultithread').addEventListener('change', LimitChange);
      document.getElementById('array').addEventListener('change', validateArray);
      document.getElementById('ws-alloc').addEventListener('change', toggleAllocation);
      document.getElementById('ws-name').addEventListener('change', validateWorkspace);
      document.getElementById('filesystem').addEventListener('change', setLimitDuration);
      // We do not validate Email on change since the validateEmail checks if mail is correct + a box is selected.
      // In the user workflow, this would trigger a red field when they enter a correct Email, but have not selected a checkbox
      // To avoid confusion, we only check on generate.

      // for no_monitoring, enable the --exclusive flag
      document.getElementById('nomonitoring-info').addEventListener('change', function() {
        if ( document.getElementById('nomonitoring').checked === true ) {
          document.getElementById('exclusive').checked = true;
        }
      });

      // in distribution, hide option field if unneeded
      document.getElementById('distribution-info').addEventListener('change', function() {
        if (
          document.getElementById('distribution').value === 'none' ||
          document.getElementById('distribution').value === 'arbitrary'
        ) {
          document.getElementById('distribution-option').style.cssText = 'display:none !important';
          document.getElementById('distribution2').style.cssText = 'display:none !important';
        } else {
          document.getElementById('distribution-option').style.cssText = 'display:inline !important';
          document.getElementById('distribution2').style.cssText = 'display:inline !important';
          document.getElementById('distribution-option').style.width = '35px';
        }
      });

      // in array dependency, hide jobid field if unneeded
      document.getElementById('dependency').addEventListener('change', function() {
        if (
          document.getElementById('dependency').value === 'none' ||
          document.getElementById('dependency').value === 'singleton'
        ) {
          document.getElementById('jobid').style.cssText = 'display:none !important';
        } else {
          document.getElementById('jobid').style.cssText = 'display:inline !important';
        }
      });

      document.getElementById('generate-button').addEventListener('click', validateAllFields);

      // event listeners for showing info text on focused input field
      for (const [key, value] of Object.entries(info)) {
        document.getElementById(key).addEventListener('focus', function () {fillInfoPanel(key)});
      }

      // initialize webpage

      // set up the collapsible fields
      var toggleContent = function() {
        this.classList.toggle('active');
        let content = this.nextElementSibling;
        if (content.style.display === 'block') {
          content.style.display = 'none';
        } else {
          content.style.display = 'block';
        }
      }

      // regular content
      let colls = Array.prototype.slice.call(document.getElementsByClassName('collapsible'),1);
      [].forEach.call(colls, function (coll) {
        // add event listeners
        coll.addEventListener('click', toggleContent);

        // extended at beginning
        let content = coll.nextElementSibling;
        content.style.display = 'block';
        coll.classList.toggle('active');
      })

      // header: delete md heading 'Slurm Job File Generator'
      document.getElementById('slurm-job-file-generator').style.display = 'none';
      document.getElementsByClassName('md-content__button')[0].style.display = 'none';
      document.getElementById('header').addEventListener('click', function() {
        this.classList.toggle('active-header');
        colls = Array.prototype.slice.call(document.getElementsByTagName('p'),5,9);
        [].forEach.call(colls, function (coll) {
          if (coll.style.display !== 'none') {
            coll.style.display = 'none';
          } else {
            coll.style.display = 'block';
          }
        });
      })
      document.getElementById('header').classList.toggle('active-header');

      // hide mail user initially
      document.getElementById('mail-user-info').style.display = 'none';

      // set up partition options
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

      document.getElementById('partition').style.width = '193px';
      document.getElementById('mem').style.width = '135px';

      // set up of output options
      document.getElementById('one-output').checked = true;
      document.getElementById('error-file-info').style.display = 'none';

      // set up of workspace options
      select = document.getElementById('filesystem');

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

      // set up tooltip texts
      for (const [key, value] of Object.entries(info)) {
        document.getElementById(key + '-info').title = value['text'];
      }

      // initialize UI
      toggleAdvanced();
      partitionLimitChange();
      fillPartitionInfo();
      fillTooltips();
      fillTooltipsWorkspace();
    </script>
  </body>
</html>