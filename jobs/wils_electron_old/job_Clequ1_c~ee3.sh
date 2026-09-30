#!/usr/bin/bash
#SBATCH --job-name=C_lequ1_c~ee3
#SBATCH --partition=short
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --qos=student
#SBATCH --output=/home/barbariczara/output/C_lequ1_c~ee3.out

module load GCC/7.3.0
module load GCCcore/7.3.0

source /home/barbariczara/root/root_install/bin/thisroot.sh
source ~/.bashrc

#Commands:
echo "starting C_lequ1 pp_c~ee"
date

bash ~/2026/code/mg5_clequ1_c~_log3.sh

echo "ending C_lequ1 pp_c~ee"
date

