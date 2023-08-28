nextflow.enable.dsl=2

process CURL {
    debug true

    script:
    """
    curl https://wave.seqera.io/service-info
    """
}

workflow {
    CURL()
}
