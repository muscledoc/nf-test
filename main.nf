nextflow.enable.dsl=2

process UNZIPGTF {
    tag "unzip GTF"

    input:
    path(gtf) 

    output:
    path "*.gtf"

    script:
    """
    gunzip $gtf 
    """
    // gunzip -c $gtf > genes.gtf
}

process INDEX {
    tag "generate BAI"

    input:
    path(bam)

    output:
    path "*.bai"

    script:
    """
    samtools index ${bam}
    """
}


// ref_ch = channel.of('/illumina-isi07/scratch/iKnow/refs/GRCh38.d1.vd1.fa')
// gtf_ch = channel.of('/illumina-isi07/scratch/iKnow/refs/gencode.v41.annotation.gtf')


//params.input = "input_file_list.txt"

workflow {

    input_ch = Channel
        .fromPath(params.input)
    
    INDEX(input_ch)
    INDEX.out.view()
}

