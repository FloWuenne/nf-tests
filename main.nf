
process DEEPCELL_MESMER {
  debug true
  container "docker.io/vanvalenlab/deepcell-applications:0.4.1"  
  
  script:
  '''
  python /usr/src/app/run_app.py -h
  '''
}

workflow {
  DEEPCELL_MESMER()
}
