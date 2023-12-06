# Creates a squire environment on Miniconda3
# has STAR, Bedtools, Samtools, Stringtie, git

MAINTAINER Reshma Ramaiah <reshma_ramaiah@dfci.harvard.edu

RUN apt-get - update -qq

FROM continuumio/miniconda3

RUN conda create --name squire --override-channels -c iuc -c bioconda -c conda-forge -c defaults -c r python=2.7.13 bioconductor-deseq2=1.16.1 r-base=3.4.1 r-pheatmap bioconductor-vsn bioconductor-biocparallel=1.12.0 r-ggrepel star=2.5.3a bedtools=2.25.0 samtools=1.1 stringtie=1.3.3 igvtools=2.3.93 ucsc-genepredtobed ucsc-gtftogenepred ucsc-genepredtogtf ucsc-bedgraphtobigwig r-hexbin

SHELL ["conda", "run", "-n", "squire", "/bin/bash", "-c"]

RUN conda install --override-channels -c iuc -c bioconda -c conda-forge -c defaults git=2.11.1

RUN git clone https://github.com/wyang17/SQuIRE; cd SQuIRE; pip install -e
