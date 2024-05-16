process BIGFILE {

    output:
      path "big.file"


    script:
    '''
    dd if=/dev/zero of=big.file bs=1G count=6
    '''
}

process MOVE {

    input:
      path "in.file"

    output:
      path "out.file"

    script:
    '''
    mv in.file out.file
    '''
}

process CHECK {

    input:
      path "big.file"

    script:
    '''
    echo "58cf638a733f919007b4287cf5396d0c  big.file" | md5sum --check --quiet
    '''
}
 
workflow {
    BIGFILE()
    MOVE(BIGFILE.out)
    CHECK(MOVE.out)
}
