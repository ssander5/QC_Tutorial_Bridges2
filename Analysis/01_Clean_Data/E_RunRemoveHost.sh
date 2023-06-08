#!/bin/bash

#SBATCH -J RunQC_E
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

echo "Removing host contamination and generating stats using BBMAP"

for f in ./bbmap/*trimclean.sickleclean.spikeclean.fq; do
    base=${f%trim*}

    touch ./${base}stats.txt

    bbwrap.sh \
    threads=16 \
    minid=0.95 \
    maxindel=3 \
    bwr=0.16 \
    bw=12 \
    quickmatch \
    fast \
    minhits=2 \
    qtrim=rl \
    trimq=20 \
    minlength=60 \
    in=$f,${base}trimclean.sickleclean.spikeclean.fq \
    outu1=${base}trimclean.sickleclean.spikeclean.hostclean.fq \
    path=../Reference/human 2>&1 >/dev/null | \
    awk '{print "HOST CONTAMINATION SEQUENCES "$0}' | \
    tee -a ./bbmap/$(basename ${base}stats.txt)
done

echo "DONE Removing host contamination and generating stats using BBMAP!"
