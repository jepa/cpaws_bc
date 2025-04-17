#!/bin/bash
#SBATCH --job-name=ADRDisp
#SBATCH --account=def-wailung
#SBATCH -N 1 	#Nodes
#SBATCH -N 1	#CPU count
#SBATCH --mem-per-cpu=1500M
#SBATCH -t 00-10:00:00
#SBATCH --mail-user=jepa88@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --array=10-10
#SBATCH --output=/home/jepa/projects/def-wailung/jepa/cpaws_bc/protocols/run_dbem/slurm_out/Array-%A-%a.out
#SBATCH --error=/home/jepa/projects/def-wailung/jepa/cpaws_bc/protocols/run_dbem/slurm_out/Array-%A-%a.err


Model=GFDL
SSP=85
# Extract necessary data into TempSlurm
Root=~/projects/def-wailung/Data/Climate/C6${Model}${SSP}_annual

cd $SLURM_TMPDIR
echo "extracting data"
tar -xf ${Root}/SST_${Model}${SSP}_y.tar.gz
echo "SST complete"
tar -xf ${Root}/bot_temp_${Model}${SSP}_y.tar.gz
echo "bot_temp complete"

tar -xf ${Root}/AdvectionU_${Model}${SSP}_y.tar.gz
echo "AdvectionU complete"
tar -xf ${Root}/AdvectionV_${Model}${SSP}_y.tar.gz
echo "AdvectionV complete"

tar -xf ${Root}/htotal_btm_${Model}${SSP}_y.tar.gz
echo "htotal_btm complete"
tar -xf ${Root}/htotal_surf_${Model}${SSP}_y.tar.gz
echo "htotal_surf complete"

tar -xf ${Root}/O2_btm_${Model}${SSP}_y.tar.gz
echo "O2_btm complete"
tar -xf ${Root}/O2_surf_${Model}${SSP}_y.tar.gz
echo "O2_surf complete"

tar -xf ${Root}/Salinity_btm_${Model}${SSP}_y.tar.gz
echo "Salinity_btm complete"
tar -xf ${Root}/Salinity_surf_${Model}${SSP}_y.tar.gz
echo "Salinity_surf complete"

tar -xf ${Root}/totalphy2_${Model}${SSP}_y.tar.gz
echo "totalphy2 complete"
tar -xf ${Root}/IceExt_${Model}${SSP}_y.tar.gz
echo "IceExt complete"

cd $SLURM_SUBMIT_DIR
echo "Current working directory is `pwd`"
echo "Starting run at:$(date)"
echo “Starting task: $SLURM_ARRAY_TASK_ID”
sleep ${SLURM_ARRAY_TASK_ID}5s

export OMP_NUM_THREADS=1
~/projects/def-wailung/jepa/dbem/dbem_scripts/DBEM_v2_y $SLURM_TMPDIR
echo "Program $SLURM_JOB_NAME finished with exit code $? at: $(date)"
