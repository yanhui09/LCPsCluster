# LCPsCluster
The LCPsCluster module for the [On-rep-seq](https://github.com/lauramilena3/On-rep-seq).

## Usage

You can edit the path to `input_dir` and `results_dir` in the `config.yaml`, and start snakemake workflow in the console.

    snakemake -p --use-conda -j 8

Or pass the arguments in the console.

    snakemake -p --use-conda -j 8 --config input_dir=/path/to/input_dir results_dir=/path/to/results_dir
