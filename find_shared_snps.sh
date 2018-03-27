#!/bin/sh
# Find shared SNPs between Microarray Chips from different providers. 
# Assume CSV file format as input files. No common identifier between but use SNP position.
# Author : Hernán Morales Durand <hernan.morales@gmail.com>

# Input files
gseq65k="Geneseq_65K.csv"
illu55k="Illumina_55K.csv"
affy670k="Axiom_MNEc670_Annotation.r1.csv"

# Intermediate files
gseq="GSQ.1.txt"
ill="ILLU.1.txt"
affy="AFFY.1.txt"

# Output files
shared_gseq_affy="Shared_GeneSeq_65k-Affymetrix_670k.txt"
shared_ill_gseq="Shared_Illumina_55k-GeneSeq_65k.txt"
shared_ill_affy="Shared_Illumina_55k-Affymetrix670k.txt"

# Extract chr and position from GeneSeq 65k CSV
tail -n +2 $gseq65k | \
	cut -f 5,6 | \
	sort -k1,1n -k2,10n -t $'\t' -o $gseq

# Extract chr and position from Illumina 55K CSV
tail -n +2 $illu55k | \
	cut -d , -f 11,12 | \
	sort -k1,1n -k2,10n -t , | 
	sed 's/,/\t/' > $ill

# Extract chr and position from Affymetrix 670k CSV
tail -n +20 $affy670k | \
	cut -d , -f 4,5 | \
	sed 's/"//g;s/,/\t/' | \
	sort -k1,1n -k2,10n -t $'\t' | \
	grep -v ^Un > $affy

# Find shared SNPs between Illumina and GeneSeq
grep -F -f $ill $gseq > $shared_ill_gseq
# Count shared SNPs
wc -l $shared_ill_gseq
wc -l $gseq

# Find shared SNPs between GeneSeq and Affymetrix
grep -F -f $gseq $affy > $shared_gseq_affy
# Count shared SNPs
wc -l $shared_gseq_affy
wc -l $affy

# Extract
grep -F -f $ill $affy > $shared_ill_affy
# Count shared SNPs
wc -l $shared_ill_affy
