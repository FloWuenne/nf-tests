nextflow.enable.dsl=2

process OOM {
    memory '400 MB'

    script:
    '''
    A=$(cat /dev/random | base64 -w 0 | head -c 1000000000000000)
    '''
}

workflow {
    OOM()
}
