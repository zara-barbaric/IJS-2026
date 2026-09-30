#!/usr/bin/bash
#SBATCH --job-name=pt_photon/SM
#SBATCH --partition=day
#SBATCH --time=13:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --qos=student
#SBATCH --output=/home/barbariczara/2026/output_complete/pt_photon/SM.out

module load GCC/7.3.0
module load GCCcore/7.3.0

source /home/barbariczara/root/root_install/bin/thisroot.sh
source ~/.bashrc

#Commands:
echo "Start: $(date)"
bash ~/2026/code_complete/pt_photon/mg5_SM.sh
echo "End: $(date)"
