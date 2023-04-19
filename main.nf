process generator {
  input:
    val x
  output:
    path 'data*'
  """
  echo 'line ${x}' > data${x}.txt
  """
}

process collector {
  input: 
    path '*.txt'
  output:
    path 'output.out'
  """
  find . -name "*.txt" -exec cat {} \\; > output.out
  """
}

workflow {
  channel.of(1..params.files) | generator
  generator.out.collect() | collector
}
