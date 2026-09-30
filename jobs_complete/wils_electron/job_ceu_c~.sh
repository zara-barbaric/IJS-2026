#!/usr/bin/bash
#SBATCH --job-name=wils_electron/C_eu_c~ee
#SBATCH --partition=day
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --qos=student
#SBATCH --output=/home/barbariczara/2026/output_complete/wils_electron/C_eu_c~ee.out

module load GCC/7.3.0
module load GCCcore/7.3.0

source /home/barbariczara/root/root_install/bin/thisroot.sh
source ~/.bashrc

#Commands:
echo "Start: $(date)"
bash ~/2026/code_complete/wils_electron/mg5_ceu_c~.sh
echo "End: $(date)"
