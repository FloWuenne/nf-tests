params.image = 'https://cloud.seqera.io/assets/seqera-brand.svg'
params.outdir = 'results'

process PUBLISH {
    publishDir params.outdir, mode: 'copy'

    input:
    path "image.svg"

    output:
    path "output/*"

    script:
    '''
    mkdir output
    cp image.svg output/image.svg
    echo "<html><body><img src='image.svg' /><h1>HELLO WORLD</h1></body></html>" > output/output.html 
    '''
}

workflow {
    PUBLISH(params.image)
}
