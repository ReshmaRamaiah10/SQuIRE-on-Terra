# SQuIRE-on-Terra
Create a sharable workspace for SQuIRE, a Bioinformatics tool for quantifying Interspersed Repeat Expressions on the Terra cloud platform.

## INTRODUCTION
Transposable elements (TEs) are interspersed repeat sequences that make up much of the human genome. Their expression has been implicated in development and disease. However, TE-derived RNA-seq reads are difficult to quantify. Past approaches have excluded these reads or aggregated RNA expression to subfamilies shared by similar TE copies, sacrificing quantitative accuracy or the genomic context necessary to understand the basis of TE transcription. As a result, the effects of TEs on gene expression and associated phenotypes are not well understood.
Software for Quantifying Interspersed Repeat Expression (SQuIRE),  is the first RNA-seq analysis pipeline that provides a quantitative and locus-specific picture of TE expression (https://github.com/wyang17/SQuIRE). It was developed by Dr. Kathleen H Burns, Dr. Wan R Yang, Dr. Daniel Ardeljan, Dr. Clarissa N Pacyna, and Dr. Lindsay M Payer from Department of Pathology, Johns Hopkins University School of Medicine, Baltimore, MD 21205, USA. SQuIRE is an accurate and user-friendly tool that can be used for a variety of species. 

## OBJECTIVE
SQuIRE was developed for UNIX environments, which can be difficult for new users to use. Therefore, this project aims to provide a simple and easy-to-use UNIX-based interface for SQuIRE.
Create a sharable workspace for SQuIRE on a cloud platform such as Terra.
Avoid installation and data storage on the local computer.
Be able to easily access the workflows without having to follow up with bash scripts.

## RESULTS
Created a Terra workspace that allows you to keep everything for your study together in one place - data, metadata and analysis tools, as well as documentation and a record of all workflow submissions. 
Developed a docker image that includes everything needed to run the software SQuIRE: code, runtime, system tools, system libraries and settings. The docker container consists of a miniconda environment that installs SQuIRE through github. The docker was uploaded on docker hub by a member in the lab and has had 292 downloads so far (https://hub.docker.com/r/elizabethfcohen/squire).
Developed 9 pipelines on Terra workspace using WDL script and bash that allows the user to perform different stages of analysis of SQuIRE. The following 7 individual workflows were developed:
1. Preparation Stage
- Fetch: Downloads input files from RefGene and generates STAR index Only needs to be done once initially to acquire genomic input files or if a new build is desired.
- Clean: Filters Repeatmasker file for Repeats of interest, collapses overlapping repeats, and returns as BED file.
2. Quantification Stage
- Map: Aligns RNAseq data
- Count: Quantifies RNAseq reads aligning to TEs
3. Analysis Stage
- Call: Compiles and outputs differential expression from multiple alignments
4. Follow-up Stage
- Draw: Creates BEDgraphs from RNAseq data
- Seek: Reports individual transposable element sequences
2 wrapper workflows were developed for the preparation stage and quantification stage respectively.
