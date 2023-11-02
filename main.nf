
process PUBLISH {
  publishDir "${params.outdir}", mode: 'copy'

  output:
    path 'output/**/*.txt'  

  script:
  '''
  mkdir output
  seq 1 100 | awk '{system("mkdir output/"$0"; echo "$0" > output/"$0"/"$0".txt")}'
  ''' 
}

workflow {
  PUBLISH()
}
