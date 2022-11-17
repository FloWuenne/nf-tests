nextflow.enable.dsl=2

process WriteAndRead {
    memory '1G'

    input:
    val(i)

    output:
    path("*.dat")

    script:
    def filesize = new MemoryUnit(params.size)
    """
    dd if=/dev/zero bs=1M count=${filesize.toMega()} of=out.${i}.dat
    cat out.${i}.dat | md5sum -
    """
}

workflow {
    Channel.of(1..params.count)
    | WriteAndRead
}
