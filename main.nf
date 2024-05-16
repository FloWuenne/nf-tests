process BIGFILE {

    output:
      path "folder"


    script:
    '''
    mkdir folder
    dd if=/dev/zero of=folder/big.file bs=1G count=6
    '''
}

process MOVE {

    input:
      path "folder"

    output:
      path "out.file"

    script:
    '''
    mv folder/big.file out.file
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
