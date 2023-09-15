nextflow.enable.dsl=2

process CREATE {

    output:
      path "data.txt"


    script:
    """
    echo HELLO > data.txt
    """
}

process PUBLISH {
    publishDir "${params.outdir}"

    input:
      path "data.txt"

    output:
      path "data.txt"

    script:
    '''
    echo BYE >> data.txt
    '''
}

workflow {
    CREATE()
    PUBLISH(CREATE.out)
}
