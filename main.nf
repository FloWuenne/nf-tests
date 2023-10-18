

def parseVersions(traces) {
  result = ''
  for( t in traces ) {
    v = t.getStore().keySet().findAll{ it.startsWith('custom_version_') }.collect{ "$it: ${t.getStore().get(it)}" }
    if( v ) { 
      result += t.processName + ":\n    " + v.join("\n    ") + "\n"
    }
  } 
  return result
}


process FASTQC {
  conda "bioconda::fastqc=0.11.9"
  customTraces version_fastqc: "fastqc --version | sed -e 's/FastQC v//g'"

  output:
    path 'output.txt'

  """
  echo "FASTQC" > output.txt
  """
}


process BAMTOOLS {
  conda "bioconda::bamtools=2.5.2"
  customTraces version_bamtools: "bamtools --version | grep -e 'bamtools' | sed 's/^.*bamtools //'"

  output:
    path 'output.txt'

  """
  echo "BAMTOOLS" > output.txt
  """
}


process MULTIQC {

  input:
    path 'fastqc.txt'
    path 'bamtools.txt'

  script:
    versions = parseVersions(workflow.traces)
    """
    cat <<-END_VERSIONS > versions.yml
${versions}
END_VERSIONS

    cat fastqc.txt bamtools.txt > result.txt
    """
}

workflow {

  FASTQC()
  BAMTOOLS()

  MULTIQC(FASTQC.out, BAMTOOLS.out)
}

workflow.onComplete {
  println "EXAMPLE VERSIONS YAML:\n${parseVersions(workflow.traces)}"   
}
