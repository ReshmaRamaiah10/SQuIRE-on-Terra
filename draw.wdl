version 1.0

workflow SQuIRE_Draw {
    input {
        String build
        String basename
        File squire_fetch
        File squire_map
        Int? pthreads
        Int? strandedness
        Boolean? normlib
          }
    call Draw {
        input:
            build = build,
            basename = basename,
            pthreads = 1,
            strandedness = 1,
            normlib = false,
            squire_fetch = squire_fetch,
            squire_map = squire_map
          }
          
    output {
        File squire_Draw = Draw.squire_draw
        }
}

task Draw {
    input {
    String build
    String basename
    File squire_fetch
    File squire_map
    Int? pthreads
    Int? strandedness
    Boolean? normlib
          }
    command {
        tar -xvf ~{squire_fetch}
        tar -xvf ~{squire_map}
        
        squire Draw --map_folder squire_map --fetch_folder squire_fetch --draw_folder squire_draw --name ~{basename} --normlib ~{normlib} --build ~{build} --pthreads ~{pthreads} --strandedness ~{strandedness} --verbosity

        echo 'Draw Complete on' `date`
        
        tar -zcvf ~{basename}squire_draw.tar.gz squire_draw
          }
    output {
        File squire_draw = basename+"squire_draw.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: 50 + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
          }
}
