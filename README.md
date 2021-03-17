# bwt2map
A snakemake workflow to do alignment with bowtie2, and some down-stream analysis

## Usage

You can edit the path to `input_dir` and `results_dir` in the `config.yaml`, and start snakemake workflow in the console.

    snakemake -p --use-conda -j 8

Or pass the arguments in the console.

    snakemake -p --use-conda -j 8 --config input_dir=/path/to/input_dir results_dir=/path/to/results_dir threads_taxa=8
