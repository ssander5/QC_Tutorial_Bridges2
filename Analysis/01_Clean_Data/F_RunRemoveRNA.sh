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
if [ -f ../Reference/smr_v4.3_default_db.fasta ]; then
    echo "rRNA database exists"
else
    wget https://github.com/sortmerna/sortmerna/releases/download/v4.3.3/database.tar.gz
    mv database.tar.gz ../Reference/
    tar -xvf ../Reference/database.tar.gz
fi

echo "Removing rRNA contamination using SortMeRNA database in bbduk"

for f in ./bbmap/*trimclean.sickleclean.spikeclean.hostclean.fq; do
    #bbduk is easier to install, faster to run, and has similar output to sortmerna

    base=${f%trim*}

    bbduk.sh \
    in=${base}trimclean.sickleclean.spikeclean.hostclean.fq \
    ref=../Reference/smr_v4.3_default_db.fasta \
    out=${base}final.clean.fq \
    outm=${base}reads_that_match_rRNA.fq 2>&1 > /dev/null | \
    awk '{print "rRNA CONTAMINATION SEQUENCES PAIRED "$0}' | \
    tee -a ./${base}stats.txt

done

echo "DONE Removing rRNA contamination using SortMeRNA database in bbduk!"
