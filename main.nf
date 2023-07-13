nextflow.enable.dsl=2

process TMP {
    container "jordeu/ubuntu:nonroot"

    script:
    '''
    echo "hola" > $TMPDIR
    '''
}

workflow {
    TMP()
}
