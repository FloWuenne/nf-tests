nextflow.enable.dsl=2

process OOM {
    memory '3 GB'

    script:
    '''
    #!/usr/bin/env python

    with open("output.txt", "wt") as fd:
        a = ""
        for i in range(1, 6000):
            b = "A" * 1024 * 1024
            fd.write(b + "\\n")
            a = a + b
    '''
}

workflow {
    OOM()
}
