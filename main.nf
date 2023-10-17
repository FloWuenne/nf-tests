nextflow.enable.dsl = 2

process MD5 {
  debug true
  input:
    path 'input.txt'

  """
  echo MD5
  md5sum input.txt
  """
}

process SHA1 {
  debug true
  input: 
    path 'input.txt'

  """
  echo SHA1
  sha1sum input.txt
  """
}

process SHA256 {
  debug true
  input:
    path 'input.txt'  

  """
  echo SHA256
  sha256sum input.txt
  """
}

workflow {
  input1 = file('https://raw.githubusercontent.com/jordeu/nf-tests/checksum/hello.md5', checksum: '8ddd8be4b179a529afa5f2ffae4b9859')
  input2 = file('https://raw.githubusercontent.com/jordeu/nf-tests/checksum/hello.sha1', checksum: 'sha1::a0b65939670bc2c010f4d5d6a0b3e4e4590fb92b')
  input3 = file('https://raw.githubusercontent.com/jordeu/nf-tests/checksum/hello.sha256', checksum: 'sha256::03ba204e50d126e4674c005e04d82e84c21366780af1f43bd54a37816b6ab340')
  
  MD5(Channel.of(input1))
  SHA1(Channel.of(input2))
  SHA256(Channel.of(input3))
}

