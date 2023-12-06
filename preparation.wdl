version 1.0

workflow SQuIRE_Preparation {
    input {
        String build
		File? non_reference
        File? squire_fetch
          }
    call Fetch {
        input:
            build = build
          }
    call Clean {
        input:
            build = build,
			non_reference = non_reference,
            squire_fetch = Fetch.squire_fetch
          }          
    output{
    File squire_fetch = Fetch.squire_fetch
    File squire_clean = Clean.squire_clean
    }
}

task Fetch {
    input {
        String build
          }
    command {
        squire Fetch --build ~{build} --fetch_folder squire_fetch --fasta --rmsk --chrom_info --index --gene --pthreads 8 --verbosity
        tar -zcvf squire_fetch.tar.gz squire_fetch
          }
    output {
        File squire_fetch = "squire_fetch.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: 50 + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
          }
}

task Clean {
    input {
        String build
        File? non_reference
        File? squire_fetch
          }
    command {
        tar -xvf ~{squire_fetch}
        if [ -z ~{non_reference} ]; then
            squire Clean -b ~{build} --fetch_folder squire_fetch --clean_folder squire_clean --verbosity
        else
            squire Clean --build ~{build} --fetch_folder squire_fetch --clean_folder squire_clean --extra ~{non_reference} --verbosity
        fi
        tar -zcvf squire_clean.tar.gz squire_clean
          }
    output {
        File squire_clean = "squire_clean.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: 50 + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
          }
}
