#!/bin/bash

#SBATCH -J RunQC_D
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

if [ -d ./bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

echo "SKIPPING Removing phix adaptors and sequencing artifacts using BBMAP"

for g in ./sickle/*trimclean.sickleclean.fq ; do
    o=${g#./sickle/}

    cp ${g%trim*}trimclean.sickleclean.fq ./bbmap/${o%trim*}trimclean.sickleclean.spikeclean.fq
done



