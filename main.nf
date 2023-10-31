#!/usr/bin/env nextflow

// Define Channels from input
    Channel
.fromPath(params.reference)
    .ifEmpty { exit 1, "Cannot find input file : ${params.reference}" }
    .set { ch_reference }

    Channel
.fromPath(params.bamlist)
    .ifEmpty { exit 1, "Cannot find input file : ${params.bamlist}" }
    .splitCsv(skip:1)
    .map {sample_name, bam_path, bai_path -> [ sample_name, file(bam_path), file(bai_path) ] }
    .set { ch_bam }

    // Index reference
process index_ref {
        tag "Index reference"

            input:
            file(ref_path) from ch_reference

            output:
            file "${ref_path.baseName}*" includeInputs true into ch_index

            script:
            """
            bwa index -p $ref_path.baseName $ref_path
            """
    }

// Process bam files
//process find_SV {
//    tag "$sample_name"
//        publishDir "${params.outdir}", mode: 'copy'
//
//        input:
//        set val(sample_name), file(bam_path), file(bai_path) from ch_bam
//        each file("*") from ch_index
//
//        output:
//        file "*.vcf"
//
//        script:
//        """
//        find_sv.py -b $bam_path -o . -g ${params.build}
//    """
//}
