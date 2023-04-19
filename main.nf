nextflow.enable.dsl=2

process Dummy {
    debug true

    script:
    """
    TMPDIR=. cat <<-EOF
      HOLA
    EOF
    """
}

workflow {
    Dummy()
}
