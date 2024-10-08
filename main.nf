params.workdir = "${workDir.toUri()}"
params.workflowid = "${params.workdir.tokenize('/').last()}"

printf "WorkDir: ${params.workdir} -- Workflow ID: ${params.workflowid}" 

process DISKUSAGE {

    input:
    env WORKDIR
    env WORKFLOWID

    script:
    '''
    FUSIONDIR=$(echo "$WORKDIR" | sed -e 's|s3:///|/fusion/s3/|' | sed -e 's|az:///|/fusion/az/|' -e 's|gs:///|/fusion/gs/|' | sed -e 's|s3://|/fusion/s3/|' -e 's|az://|/fusion/az/|' -e 's|gs://|/fusion/gs/|' )
    LOGFILE="$FUSIONDIR/nf-$WORKFLOWID.log"
    echo >> $LOGFILE
    echo "--- DISK USAGE START ---" >> $LOGFILE 
    find "$FUSIONDIR" -mindepth 2 -maxdepth 2 -type d | head -n 5 | grep -E "$FUSIONDIR/[0-9a-f]{2}/[0-9a-f]{30}$" | while read folder; do
      size=$(du -bs "$folder" | cut -f1)
      echo -e "$(echo $folder | sed "s|$FUSIONDIR/||")\t$size" >> $LOGFILE
    done
    echo "--- DISK USAGE END ---" >> $LOGFILE
    '''
}

workflow {
    DISKUSAGE(params.workdir, params.workflowid)
}
