nextflow.enable.dsl=2

process CREATE_GZIP {

    input:
      tuple val(name), val(size)

    output:
      tuple path("*.gz"), env(MD5), emit: gzip
      path "stats.txt", emit: stats
    
    script:
    """
    # Function to store execution time and free page cache
    tm() { { >&2 echo -n -e "\$1\t" ; TIMEFORMAT="%E"; time bash -c "\$2" ; } 2>> stats.txt ; }

    # Create random file of ${size}mb
    tm create "dd if=/dev/urandom of=${name}.txt count=${size} bs=1024"

    # Compress using gzip
    tm compress "gzip -c ${name}.txt > ${name}.txt.gz"

    # Calculate md5 and save as variable
    MD5=\$(md5sum ${name}.txt.gz | cut -f 1 -d ' ')
    """

}

process CHECK_AND_UNZIP {

    input:
      tuple path("file.fastq.gz"), val(checksum)

    output:
      path "file.fastq", emit: fastq
      path "stats.txt" , emit: stats

    script:
    """
    # Function to store execution time and free page cache
    tm() { { >&2 echo -n -e "\$1\t" ; TIMEFORMAT="%E"; time bash -c "\$2" ; } 2>> stats.txt ; }

    # Read as fast as possible
    tm read "cat file.fastq.gz > /dev/null"

    # Verify the file MD5 checksum
    tm check "echo ${checksum} file.fastq.gz | md5sum --check --status"

    # Uncompress the file
    tm uncompress "gzip -d -c file.fastq.gz > file.fastq"
    """
}

process ZIP_AND_COMPARE {

    input:
      path "file.fastq"
      tuple path("original.gz"), val(md5)

    output:
      path "stats.txt", emit: stats

    script:
    '''
    # Function to store execution time
    tm() { { >&2 echo -n -e "$1\t" ; TIMEFORMAT="%E"; time bash -c "$2" ; } 2>> stats.txt ; }

    # Compress file
    tm compress "gzip --fast -c file.fastq > file.fastq.gz"

    # Compare with the original compressed file
    tm compare "zcmp file.fastq.gz original.gz"
    '''
}

process REPORT {
    debug true
    publishDir "${params.outdir}"

    input:
      path "*.txt"

    output:
      path "stats.txt"

    script:
    '''
    cat *.txt | tee stats.txt
    '''
}
 
workflow {
  input_ch = Channel.of([params.name, params.size])
    CREATE_GZIP(input_ch)
    CHECK_AND_UNZIP(CREATE_GZIP.out.gzip)
    ZIP_AND_COMPARE(CHECK_AND_UNZIP.out.fastq, CREATE_GZIP.out.gzip)
    reports = Channel.empty().mix(
      CREATE_GZIP.out.stats,
      CHECK_AND_UNZIP.out.stats,
      ZIP_AND_COMPARE.out.stats
    )
    REPORT(reports)
}
