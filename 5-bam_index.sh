#!/bin/bash

#SBATCH --job-name=bam_index # you can give your job a name
#SBATCH --ntasks=24 # the number of processors or tasks
#SBATCH --account=itcga # our account
#SBATCH --reservation=ITCGA2025 # this gives us special access during the workshop
#SBATCH --time=10:00:00 # the maximum time for the job
#SBATCH --mem=32gb # the amount of RAM
#SBATCH --mail-type=END
#SBATCH --mail-user=sean.hernon002@umb.edu
#SBATCH --partition=itcga # the specific server in chimera we are using
#SBATCH --error=logs/%x-%A.err   # a filename to save error messages into
#SBATCH --output=logs/%x-%A.out  # a filename to save any printed output into

module load samtools-1.10-gcc-9.3.0-flukja5

# Define the input directory and output directory
input_dir=$1

# Loop through each sorted BAM file in the input directory
for file in "$input_dir"/*_sorted.bam; do
  echo "Indexing file: $file"

  # Index the BAM file
  samtools index "$file"
done

echo "Finish Run"
echo "End time: $(date)"
