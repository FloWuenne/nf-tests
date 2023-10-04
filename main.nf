nextflow.enable.dsl=2

process DF {
    debug true

    script:
    '''
    df -h
    '''
}

workflow {
    DF()
}
