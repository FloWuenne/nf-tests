params.data = "$baseDir/data/input.gfa.gz"

process SMOOTHXG {
  conda 'smoothxg=0.7.2-0'

  input:
    path 'input.gfa.gz'
  
  script:
  """
  zcat input.gfa.gz > input.gfa

  smoothxg \
    --threads=${task.cpus} \
    --gfa-in=input.gfa \
    --smoothed-out=output.gfa \
    -T 12 -r 8 -V -X 100 -I 0.9 -R 0 -j 0 -e 0 -l 700,900,1100 -O 0.001 -Y 800 -d 0 -D 0
  """
}

workflow {
  SMOOTHXG(params.data)
}
