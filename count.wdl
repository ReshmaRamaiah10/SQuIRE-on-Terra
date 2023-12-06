version 1.0

workflow SQuIRE_Count {
    input {
        String build
        Int read_length
        String basename
        Int? pthreads
        Int? strandedness
        String? EM
        File squire_fetch
        File squire_clean
        File squire_map
          }
    call Count {
        input:
            build = build,
            read_length = read_length,
            basename = basename,
            pthreads = 1,
            strandedness = 0,
            EM = "auto",
            squire_fetch = squire_fetch,
            squire_clean = squire_clean,
            squire_map = squire_map
          }
          
    output {
        File squire_Count = Count.squire_count
        }
}

task Count {
    input {
    String build
    Int read_length
    String basename
    Int? pthreads
    Int? strandedness
    String? EM
    File squire_fetch
    File squire_clean
    File squire_map
          }
    command {
        tar -xvf ~{squire_fetch}
        tar -xvf ~{squire_clean}
        tar -xvf ~{squire_map}
        
        squire Count --map_folder squire_map --clean_folder squire_clean --count_folder squire_count --fetch_folder squire_fetch --read_length ~{read_length} --name ~{basename} --build ~{build} --pthreads ~{pthreads} --strandedness ~{strandedness} --EM ~{EM} --verbosity
        
        echo 'Count Complete on' `date`
        
        tar -zcvf ~{basename}squire_count.tar.gz squire_count
          }
    output {
        File squire_count = basename+"squire_count.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: 50 + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
          }
}
