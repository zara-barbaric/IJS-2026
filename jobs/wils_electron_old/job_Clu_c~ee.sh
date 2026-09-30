#!/usr/bin/bash
#SBATCH --job-name=C_lu_c~ee
#SBATCH --partition=short
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --qos=student
#SBATCH --output=/home/barbariczara/output/C_lu_c~ee.out

module load GCC/7.3.0
module load GCCcore/7.3.0

source /home/barbariczara/root/root_install/bin/thisroot.sh
source ~/.bashrc

#Commands:
echo "starting C_lu pp_c~ee"
date

bash ~/2026/code/sym_c~ee.sh

echo "ending C_lu pp_c~ee"
date

