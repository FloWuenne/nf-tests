process CREATE {

    output:
    path "data.txt"

    script:
    """
    echo HELLO > data.txt
    """
}

process FORWARD {

    input:
    path "data.txt"

    output:
    path "data.txt"

    script:
    """
    echo AND
    """
}

process PUBLISH {
    publishDir "s3://nextflow-ci/work/ci-test/fusion-symlink"

    input:
    path "data.txt"

    output:
    path "data.txt"

    script:
    """
    echo BYE
    """
}

workflow {
    CREATE | FORWARD | PUBLISH
}
