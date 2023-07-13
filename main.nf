nextflow.enable.dsl=2

process TMP {
    script:
    '''
    mktemp
    '''
}

workflow {
    TMP()
}
