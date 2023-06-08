#!/bin/bash

#SBATCH -J RunQC_F
#SBATCH -p RM-shared
#SBATCH -o %j.txt
#SBATCH -e %j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sheri.anne.sanders@gmail.com
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

#make output folder

if [ -d bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

#Get Database

echo "SKIPPING Removing rRNA contamination using SortMeRNA database in bbduk"

for g in ./bbmap/*trimclean.sickleclean.spikeclean.hostclean.fq; do

    cp ${g%trim*}trimclean.sickleclean.spikeclean.hostclean.fq ${g%trim*}final.clean.fq

    echo "SKIPPING rRNA CONTAMINATION REMOVAL" >> ./bbmap/$(basename ${g%trim*}stats.txt)
done
