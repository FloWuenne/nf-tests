params.workdir = "${workDir.toUri()}"
params.workflowid = "${params.workdir.tokenize('/').last()}"
params.input_tsv = null  // Default to null

// Create a channel based on whether input_tsv is provided or not
def input_channel

if (params.input_tsv) {
    // If input_tsv is provided, create a channel from the TSV file
    input_channel = Channel
        .fromPath(params.input_tsv)
        .splitCsv(header: true, sep: '\t')
        .map { row -> tuple(row.workdir, row.workflowid) }
} else {
    // If input_tsv is not provided, use the single workdir and workflowid
    input_channel = Channel.of(tuple(params.workdir, params.workflowid))
    
    // Print the original message
    println "WorkDir: ${params.workdir} -- Workflow ID: ${params.workflowid}"
}

process DISKUSAGE {

    input:
    tuple env(WORKDIR), env(WORKFLOWID)

    script:
    '''
    FUSIONDIR=$(echo "$WORKDIR" | sed -e 's|s3:///|/fusion/s3/|' | sed -e 's|az:///|/fusion/az/|' -e 's|gs:///|/fusion/gs/|' | sed -e 's|s3://|/fusion/s3/|' -e 's|az://|/fusion/az/|' -e 's|gs://|/fusion/gs/|' )
    LOGFILE="$FUSIONDIR/nf-$WORKFLOWID.log"
    echo >> $LOGFILE
    echo "--- DISK USAGE START ---" >> $LOGFILE 
    find "$FUSIONDIR" -mindepth 2 -maxdepth 2 -type d | grep -E "$FUSIONDIR/[0-9a-f]{2}/[0-9a-f]{30}$" | while read folder; do
      size=$(du -bs "$folder" | cut -f1)
      echo -e "$(echo $folder | sed "s|$FUSIONDIR/||")\t$size" >> $LOGFILE
    done
    echo "--- DISK USAGE END ---" >> $LOGFILE
    '''
}

workflow {
    DISKUSAGE(input_channel)
}
