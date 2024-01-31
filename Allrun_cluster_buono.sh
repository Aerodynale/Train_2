#!/bin.bash
#$ -cwd                 # workingDirectory
#$ -j y
#$ -N Treno
#$ -S /bin/bash
#$ -q all.q                 # queueName
#$ -pe mpi 32        # cpuNumber
#$ -l h_rt=10:00:00

module use /software/spack/spack/share/spack/modules/linux-rocky8-sandybridge/
module load openfoam

#!/bin/sh
cd "${0%/*}" || exit                                # Run from this directory
. ${WM_PROJECT_DIR:?}/bin/tools/RunFunctions        # Tutorial run functions
#------------------------------------------------------------------------------
# Alternative decomposeParDict name:
#decompDict="-decomposeParDict system/decomposeParDict.6"
## Standard decomposeParDict name:
# unset decompDict

# Define the local directory where the simulation is run
localDir='/home/meccanica/abrunelli/Train_2'

#Create the results directory if it does not exist
mkdir -p "$localDir"/simulation/results

runApplication surfaceFeatureExtract

runApplication blockMesh

runApplication $decompDict decomposePar

# Using distributedTriSurfaceMesh?
if foamDictionary -entry geometry -value system/snappyHexMeshDict | \
   grep -q distributedTriSurfaceMesh
then
    echo "surfaceRedistributePar does not need to be run anymore"
    echo " - distributedTriSurfaceMesh will do on-the-fly redistribution"
fi

runParallel $decompDict snappyHexMesh -overwrite

runParallel $decompDict topoSet

runParallel $decompDict createPatch -overwrite

#- For non-parallel running: - set the initial fields
# restore0Dir

#- For parallel running: set the initial fields
restore0Dir -processor

runParallel $decompDict patchSummary

runParallel $decompDict potentialFoam -writephi

runParallel $decompDict checkMesh -writeFields '(nonOrthoAngle)' -constant

runParallel $decompDict $(getApplication)

runApplication reconstructParMesh -constant

runApplication reconstructPar # -latestTime

#Generate the train.foam file
touch "$localDir"/simulation/train.foam

# Move all the log files to the results directory
mv "$localDir"/simulation/log.* "$localDir"/simulation/results


#------------------------------------------------------------------------------
