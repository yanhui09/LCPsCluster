#--------------
configfile: "config.yaml"
#--------------
INPUT_DIR = config["input_dir"].rstrip("/")
OUTPUT_DIR = config["results_dir"].rstrip("/")

BARCODES, = glob_wildcards(INPUT_DIR + "/{barcode}.txt")
#BARCODES= ["repBC21A", "repBC52A", "repBC53A"]
#---------------

# Allow users to fix the underlying OS via singularity.
#singularity: "docker://continuumio/miniconda3"

rule all:
    input:
        OUTPUT_DIR + "/02_LCPs/LCP_clustering_heatmaps.html",
        OUTPUT_DIR + "/02_LCPs/LCP_clustering_heatmaps.ipynb"

rule LCPsCluster:
	input:
		expand(INPUT_DIR + "/{barcode}.txt", barcode=BARCODES)
	output:
		ipynb=OUTPUT_DIR + "/02_LCPs/LCP_clustering_heatmaps.ipynb",
		html=OUTPUT_DIR + "/02_LCPs/LCP_clustering_heatmaps.html",
		png1=OUTPUT_DIR + "/02_LCPs/LCP_clustering_heatmap_large.png",
		png2=OUTPUT_DIR + "/02_LCPs/LCP_clustering_heatmap.png",
		fl_pdf=OUTPUT_DIR + "/02_LCPs/LCP_clustering_flowgrams_clustering_order.pdf",
		directory=(directory(OUTPUT_DIR + "/02_LCPs/LCPsClusteringData")),
		directory_data=temp(directory(OUTPUT_DIR+"/02_LCPs/r_saved_images")), 
	params:
		input_directory=INPUT_DIR,
        work_directory=OUTPUT_DIR + "/02_LCPs",
		ipynb="runnable_jupyter_on-rep-seq_flowgrams_clustering_heatmaps.ipynb",
        png1="runnable_jupyter_on-rep-seq_flowgrams_clustering_heatmaps_clustering_heatmap_01.png",
        png2="runnable_jupyter_on-rep-seq_flowgrams_clustering_heatmaps_clustering_heatmap_02.png",
        fl_pdf="runnable_jupyter_on-rep-seq_flowgrams_clustering_heatmaps_flowgrams_clustering_order.pdf",
		min_size=100
	conda:
		"envs/R.yaml"
	shell:
		"""
        cp "{params.input_directory}"/*.txt "{params.work_directory}" 
		mkdir -p "{output.directory}"
		cp "{params.work_directory}"/*.txt "{output.directory}"
		find "{output.directory}" -size -{params.min_size}c -delete
		Rscript -e "IRkernel::installspec()"
        CLUSTSCRIPT="$(realpath ./scripts/LCpCluster.R)"
        ( cd "{params.work_directory}"; "$CLUSTSCRIPT" LCPsClusteringData/ "{params.ipynb}" )
		mv "{params.work_directory}/{params.ipynb}" "{output.ipynb}"
		mv "{params.work_directory}/{params.png1}" "{output.png1}"
		mv "{params.work_directory}/{params.png2}" "{output.png2}"
		mv "{params.work_directory}/{params.fl_pdf}" "{output.fl_pdf}"
		jupyter-nbconvert --to html --template full "{output.ipynb}" 
		"""