nextflow.enable.dsl=2

process UNTAR {
    cpus 12
    memory 72.GB
    time 16.h

    container "nfcore/bcl2fastq:2.20.0.422"

    input:
    path tar_file

    script:
    """
    tar -xzvf $tar_file
    """
}

workflow {
    UNTAR ( params.input )
}
