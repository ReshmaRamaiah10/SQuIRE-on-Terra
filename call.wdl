version 1.0

workflow SQuIRE_Call {
    input {
        String treatedGroup_groupnames
        String controlGroup_groupnames
        Boolean? subfamily
        Int? pthreads
        String projectname
        String? output_format
        Array[File] squire_count_folders
          }
    call Call {
        input:
            treatedGroup_groupnames = treatedGroup_groupnames,
            controlGroup_groupnames = controlGroup_groupnames,
            subfamily = false,
            pthreads = 1,
            projectname = projectname,
            output_format = "pdf",
            squire_count_folders = squire_count_folders
          }         
    output {
        File squire_Call = Call.squire_call
        }
}

task Call {
    input {
        String treatedGroup_groupnames
        String controlGroup_groupnames
        Boolean? subfamily
        Int? pthreads
        String projectname
        String? output_format
        Array[File] squire_count_folders
          }
    command {
        echo 'Running Call'
        mkdir squire_count_call
        for folders in ~{sep=" " squire_count_folders}; do
            tar -xvf $folders
            cp -r $folders squire_count_call
        done
        
        squire Call --group1 ~{treatedGroup_groupnames} --group2 ~{controlGroup_groupnames} --condition1 treated --condition2 control --projectname ~{projectname} --squire_count squire_count_call --pthreads ~{pthreads} --output_format ~{output_format} --call_folder squire_call --verbosity
        
        echo 'squire Call is complete'
        ls squire_call
        tar -zcvf ~{projectname}squire_call.tar.gz squire_call
          }
    output {
        File squire_call = projectname+"squire_call.tar.gz"
          }
    runtime {
        docker: "elizabethfcohen/squire"
        memory: 50 + "GB"
        disks: "local-disk 500 HDD"
        cpu: 10
          }
}
