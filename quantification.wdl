
INPUTS
OUTPUTS
version 1.0

workflow SQuIRE_Quantification {
    input {
        String build
        File fastqRead1
        File? fastqRead2
        Int read_length
        File? non_reference
        String basename
        Int? pthreads
        Int? strandedness
        String? EM
        File squire_fetch
        File squire_clean
        File? squire_map
          }
    call Mapping {
        input:
            build = build,
            pthreads = 1,
            fastqRead1 = fastqRead1,
            fastqRead2 = fastqRead2,
            read_length = read_length,
            basename = basename,
            non_reference = non_reference,
            squire_fetch = squire_fetch
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
            squire_map = Mapping.squire_map
          }          
    output{
    File squire_map = Mapping.squire_map
    File squire_count = Count.squire_count
    }
}

task Mapping {
    input {
        String build
        File fastqRead1
        File? fastqRead2
        Int read_length
        File? non_reference
        String basename
        Int? pthreads
        File squire_fetch
          }
    command {
        tar -xvf ~{squire_fetch}

        # Run SQuIRE Map

        echo 'Running Map'
        
        if [ -z ~{fastqRead2} ]
        then
            if [ -z ~{non_reference} ]; then
                if squire Map --read1 ~{fastqRead1} --map_folder squire_map --read_length ~{read_length} --fetch_folder squire_fetch --pthreads ~{pthreads} --build ~{build} --name ~{basename} --verbosity
                then
                    echo ~{basename} >> success_map_~{basename}.txt
                else
                    echo ~{basename} >> fail_map_~{basename}.txt
                fi
            else
                if squire Map --read1 ~{fastqRead1} --map_folder squire_map --read_length ~{read_length} --fetch_folder squire_fetch --extra ~{non_reference} --pthreads ~{pthreads} --build ~{build} --name ~{basename} --verbosity
                then
                    echo ~{basename} >> success_map_~{basename}.txt
                else
                    echo ~{basename} >> fail_map_~{basename}.txt
                fi
            fi
            
        else
            if [ -z ~{non_reference} ]; then
                if squire Map --read1 ~{fastqRead1} --read2 ~{fastqRead2} --map_folder squire_map --read_length ~{read_length} --fetch_folder squire_fetch --pthreads ~{pthreads} --build ~{build} --name ~{basename} --verbosity
                then
                    echo ~{basename} >> success_map_~{basename}.txt
                else
                    echo ~{basename} >> fail_map_~{basename}.txt
                fi
            else
                if squire Map --read1 ~{fastqRead1} --read2 ~{fastqRead2} --map_folder squire_map --read_length ~{read_length} --fetch_folder squire_fetch --extra ~{non_reference} --pthreads ~{pthreads} --build ~{build} --name ~{basename} --verbosity
                then
                    echo ~{basename} >> success_map_~{basename}.txt
                else
                    echo ~{basename} >> fail_map_~{basename}.txt
                fi
            fi
        fi
        echo 'Map Complete on' `date`
        tar -zcvf ~{basename}squire_map.tar.gz squire_map
          }
    output {
        File squire_map = basename+"squire_map.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: 50 + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
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
        File? squire_map
          }
    command {
        tar -xvf ~{squire_fetch}
        tar -xvf ~{squire_clean}
        tar -xvf ~{squire_map}
        
        squire Count --map_folder squire_map --clean_folder squire_clean --count_folder squire_count --fetch_folder squire_fetch --temp_folder temp_count --read_length ~{read_length} --name ~{basename} --build ~{build} --pthreads ~{pthreads} --strandedness ~{strandedness} --EM ~{EM} --verbosity
        
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
