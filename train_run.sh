#!/bin.bash
#$ -cwd                 # workingDirectory
#$ -j y
#$ -N Treno
#$ -S /bin/bash
#$ -q all.q@n0003                  # queueName
#$ -pe mpi 1        # cpuNumber
#$ -l h_rt=00:02:00



chmod +x Allrun_cluster
time ./Allrun_cluster > /home/meccanica/abrunelli/Train_2/output.txt