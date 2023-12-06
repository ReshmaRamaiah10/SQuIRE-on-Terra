version 1.0

workflow SQuIRE_Seek {
    input {
        Int mem_gb
        File infile
        File genomefile
          }
    call Seek {
        input:
            mem_gb = mem_gb,
            infile = infile,
            genomefile = genomefile
          }
          
    output {
        File squire_Seek = Seek.squire_seek
        }
}

task Seek {
    input {
        Int mem_gb
        File infile
        File genomefile
          }
    command {
        
        squire Seek --infile ~{infile} --outfile squire_seek --genome ~{genomefile} --verbosity
        
        echo 'Seek Complete on' `date`
        
        tar -zcvf squire_seek.tar.gz squire_seek
          }
    output {
        File squire_seek = "squire_seek.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: mem_gb + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
          }
}
