nextflow.enable.dsl=2

process OOM {
    memory '500 MB'

    script:
    '''
    #!/usr/bin/env python

    a = "asdfsadf".join(map(str, range(1, 1000000000)))
    '''
}

workflow {
    OOM()
}
