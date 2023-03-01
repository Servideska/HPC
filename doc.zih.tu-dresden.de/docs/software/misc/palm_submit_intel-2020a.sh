#!/bin/bash
#SBATCH --job-name=les_palm
#SBATCH --account=<project>
#SBATCH --partition=haswell
#SBATCH --time=00:10:00
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2540M

#SBATCH --mail-type=BEGIN
#SBATCH --mail-user=<firstname.lastname>@tu-dresden.de

#SBATCH --export=ALL

# modules
module load iimpi/2020a
module load FFTW/3.3.8-intel-2020a
module load netCDF-Fortran/4.5.2-iimpi-2020a
module load Python/3.8.2-GCCcore-9.3.0
export I_MPI_HYDRA_TOPOLIB=ipl

# workspace
export wm=/scratch/ws/0/<user>-palm
export PATH=${wm}/ipalm/bin:${PATH}

source ${wm}/palm/bin/activate

cd ${wm}/ipalm

# execution
echo 'Node configuration:'
echo 'Number of Nodes:' ${SLURM_JOB_NUM_NODES}
echo 'Number of Tasks:' ${SLURM_NTASKS}
echo 'CPUS_PER_TASK:' ${SLURM_CPUS_PER_TASK}
echo 'Number of Threads:' ${OMP_NUM_THREADS:-0}
echo

# select test case, see
#ls ${wm}/palm_model_system/packages/palm/model/tests/cases
case=urban_environment
# and create link if expected folder is not existing
testdir=${wm}/ipalm/JOBS/${case}
[ -d ${testdir} ] || (mkdir -pv ${testdir}; cd ${testdir}; ln -s ../../palm_model_system/packages/palm/model/tests/cases/${case} ${case})

# -O    threads per openMP task     ${OMP_NUM_THREADS}
# -T    tasks per node              ${SLURM_NTASKS_PER_NODE}
# -X    # of processors (on parallel machines)

palmrun -r ${case} -c taurus_intel -a "d3#" -T ${SLURM_NTASKS_PER_NODE} -X ${SLURM_NTASKS} -v -z
