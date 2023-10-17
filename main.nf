nextflow.enable.dsl = 2

process MD5 {
  debug true
  input:
    path 'input.txt'

  """
  md5sum input.txt
  """
}

process SHA1 {
  debug true
  input: 
    path 'input.txt'

  """
  sha1sum input.txt
  """
}

process SHA256 {
  debug true
  input:
    path 'input.txt'  

  """
  sha1sum input.txt
  """
}

workflow {
  input1 = file('https://raw.githubusercontent.com/jordeu/nf-tests/checksum/hello.txt', checksum: '8ddd8be4b179a529afa5f2ffae4b9858')
  input2 = file('https://raw.githubusercontent.com/jordeu/nf-tests/checksum/hello.txt', checksum: 'sha1::a0b65939670bc2c010f4d5d6a0b3e4e4590fb92b')
  input3 = file('https://raw.githubusercontent.com/jordeu/nf-tests/checksum/hello.txt', checksum: 'sha256::03ba204e50d126e4674c005e04d82e84c21366780af1f43bd54a37816b6ab340')
  
  MD5(input1)
  SHA1(input2)
  SHA265(input3)
}

