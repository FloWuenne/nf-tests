nextflow.enable.dsl=2

process MOVE {
    cpus 12
    memory 72.GB
    time 16.h

    container "nfcore/bcl2fastq:2.20.0.422"

    input:
    path tar_file

    script:
    untar_dir = tar_file.toString() - '.tar.gz'
    """
    tar -xzvf $tar_file
    mv $untar_dir output
    """
}

workflow {
    MOVE ( params.input )
}
