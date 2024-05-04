#!/bin/bash -l
#SBATCH --cpus-per-task=12
#SBATCH -o job1-%a.out

#SBATCH --time=1-23:25:00 --mem-per-cpu=3500


module load matlab


cd '/triton/ics/project/imagedb/anwerr1/matconvnet-1.0-beta18/examples/ucf_sports/'

matlab -r "cnn_ucf_slurm"
