#!/usr/bin/bash
#SBATCH --job-name=C_eu_cee5
#SBATCH --partition=short
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --qos=student
#SBATCH --output=/home/barbariczara/output/C_eu_cee5.out

module load GCC/7.3.0
module load GCCcore/7.3.0

source /home/barbariczara/root/root_install/bin/thisroot.sh
source ~/.bashrc

#Commands:
echo "starting C_eu pp_cee"
date

bash ~/2026/code/mg5_ceu_c_log5.sh

echo "ending C_eu pp_cee"
date

