#!/bin/bash -l
 
 
#SBATCH --cpus-per-task=12
#SBATCH -o job22-%a.out

#SBATCH --time=03:59:50 --mem-per-cpu=5000

##SBATCH -t 4-23:59:00
##SBATCH --time=1-23:25:00
##SBATCH --time=03:25:00
##SBATCH --mem=5000
##SBATCH --mem-per-cpu=5000


module load matlab
cd /scratch/cs/imagedb/anwerr1/matconvnet/matconvnet-1.0-beta18/examples/imagenet/

 ##matlab -r "convertpngtojpg_depth"
##matlab -r "convertpngtojpg_opp_depth"
matlab -r "convertpngtojpg_opp"
