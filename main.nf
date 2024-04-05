params.data = "$baseDir/data/input.gfa.gz"
params.total = 2
params.cpus = 12

process SMOOTHXG {
  conda 'smoothxg=0.7.2-0'

  input:
    val id
    path 'input.gfa.gz'
  
  script:
  """
  zcat input.gfa.gz > input.gfa

  smoothxg \
    --threads=${params.cpus} \
    --gfa-in=input.gfa \
    --smoothed-out=output.gfa \
    -T 12 -r 8 -V -X 100 -I 0.9 -R 0 -j 0 -e 0 -l 700,900,1100 -O 0.001 -Y 800 -d 0 -D 0
  """
}

workflow {
  def ch_processes = Channel.of(1..params.total)
  SMOOTHXG(ch_processes, params.data)
}
