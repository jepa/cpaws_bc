#!/bin/bash                                                                     
#SBATCH --job-name=ADRD_R                                                       
#SBATCH --account=def-wailung                                                   
#SBATCH --nodes=1 # number of node MUST be 1                                    
#SBATCH --ntasks=1                                                              
#SBATCH --cpus-per-task=6        # number of processes                          
#SBATCH --mem=8G                                                                
#SBATCH -t 00-01:00:00                                                         
#SBATCH --mail-user=j.palacios@oceans.ubc.ca                                    
#SBATCH --mail-type=ALL                                                         
#SBATCH --output=/home/jepa/projects/def-wailung/jepa/cpaws_bc/protocols/run_dbem/slurm_out/conver_slurm_%j.out # Specify the full path with the desired file name prefix
#SBATCH --error=/home/jepa/projects/def-wailung/jepa/cpaws_bc/protocols/run_dbem/slurm_out/conver_slurm_%j.err # Specify the full path with the desired file name prefix


# ---------------------------------------------------------------------         
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
# ---------------------------------------------------------------------         


module load StdEnv/2023 gcc/12.3 r/4.3.1
export R_LIBS=~/local/R_libs/
Rscript conversion_protocol.R Settings.R$SLURM_ARRAY_TASK_ID
