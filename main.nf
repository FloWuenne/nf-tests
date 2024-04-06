
process NOTHING {
  debug true

  input:
    val id

  script:
  """
  # Nothing by ${id}
  """
}

workflow {
  def ch_processes = Channel.of(1..10)
  NOTHING(ch_processes)
}
