#!/bin.bash
#$ -cwd                 # workingDirectory
#$ -j y
#$ -N Treno
#$ -S /bin/bash
#$ -q all.q                 # queueName
#$ -pe mpi 16        # cpuNumber
#$ -l h_rt=03:00:00



chmod +x Allrun_cluster
time ./Allrun_cluster > /home/meccanica/abrunelli/Train_2/output.txt