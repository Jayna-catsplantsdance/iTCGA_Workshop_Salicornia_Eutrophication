#!/bin/bash

#SBATCH --job-name=alignment # you can give your job a name
#SBATCH --ntasks=24 # the number of processors or tasks
#SBATCH --account=itcga # our account
#SBATCH --reservation=ITCGA2025 # this gives us special access during the workshop
#SBATCH --time=24:00:00 # the maximum time for the job
#SBATCH --mem=32gb # the amount of RAM
#SBATCH --partition=itcga # the specific server in chimera we are using
#SBATCH --mail-type=END
#SBATCH --mail-user=sean.hernon002@umb.edu
#SBATCH --error=logs/%x-%A.err   # a filename to save error messages into
#SBATCH --output=logs/%x-%A.out  # a filename to save any printed output into

module load gcc-10.2.0-gcc-9.3.0-f3oaqv7
module load python-3.8.12-gcc-10.2.0-oe4tgov
module load hisat2-2.1.0-gcc-9.3.0-u7zbyow

# Define variables
index_dir=$1 # where my genome index is stored, needs to end with the genome index name (sdep1)
input_dir=$2 # where my filtered/trimmed fastq files are
output_dir=$3 # where I want to put the sam files

# Loop through R1 files in the input directory
for file in "$input_dir"/*_R1_001_trim.fastq; do
  # Extract the base name without the suffix (e.g., "C1_S4_L001")
  base=$(basename "$file" _R1_001_trim.fastq)

  hisat2 -p 24 \
  -x "$index_dir" \
  -1 "$input_dir/${base}_R1_001_trim.fastq" \
  -2 "$input_dir/${base}_R2_001_trim.fastq" \
  -S "$output_dir/${base}.sam"

done

echo "Finish Run"
echo "End time: $(date)"

