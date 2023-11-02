
process PUBLISH {
  publishDir "${params.outdir}", mode: 'copy'

  output:
    path '*.txt'  

  script:
  '''
  seq 1 100 | awk '{system("echo "$0" > "$0".txt")}'
  ''' 
}

workflow {
  PUBLISH()
}
