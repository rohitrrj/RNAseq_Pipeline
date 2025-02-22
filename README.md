# RNA-seq Analysis Pipeline
![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)
![NGS](https://img.shields.io/badge/NGS-RNA--seq-blue.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A comprehensive pipeline for processing RNA sequencing data using STAR aligner and generating gene expression counts. This pipeline automates the entire workflow from raw FastQ files to gene count matrix generation.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Pipeline Steps](#pipeline-steps)
- [Output Structure](#output-structure)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)

## Features
- Automated processing of paired-end RNA-seq data
- Quality control using FastQC
- Efficient read alignment using STAR
- Gene-level quantification using featureCounts
- Support for multiple samples
- Parallel processing capabilities
- Comprehensive logging and error reporting

## Prerequisites
- Python
- FastQC (v0.11.2+)
- STAR (v2.5.3a+)
- Subread/featureCounts (v1.6.0+)
- Samtools (v1.3+)
- R (v3.2.2+)
- Reference genome and annotation files
- Sufficient computational resources (recommended: 32GB+ RAM)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/rohitrrj/RNAseq_Pipeline.git
cd RNAseq_Pipeline
```

2. Ensure all required modules are available:
```bash
module load python fastqc/0.11.2 STAR/2.5.3a subread/1.6.0
module load samtools/1.3 r/3.2.2
```

3. Configure your project:
```bash
cp conf.txt.example conf.txt
# Edit conf.txt with your project-specific paths
```

## Usage

1. Prepare your input data:
- Place paired-end FastQ files in the data directory
- Naming convention: `sample_R1_001.fastq.gz` and `sample_R2_001.fastq.gz`

2. Set up configuration (`conf.txt`):
```bash
myDATADIR="/path/to/fastq/files"
myGenomeDIR="/path/to/reference/genome"
myGenomeGTF="/path/to/annotation.gtf"
N_CPUS=8  # Number of CPU cores to use
```

3. Run the pipeline:
```bash
./RNA_seq_pipeline_STAR.sh
```

## Pipeline Steps

1. **Quality Control** (FastQC)
   - Raw read quality assessment
   - Adapter content analysis
   - Quality metrics visualization
   
2. **Read Alignment** (STAR)
   - Genome loading
   - Splice-aware alignment
   - BAM file generation
   
3. **Expression Quantification** (featureCounts)
   - Gene-level count generation
   - Multi-threaded processing
   - Comprehensive counting statistics

## Output Structure
```
project_directory/
├── fastQC_output/           # Quality control reports
│   ├── *_fastqc.html
│   └── *_fastqc.zip
├── star_output/            # STAR alignment results
│   ├── *Aligned.out.bam
│   ├── *Log.final.out
│   └── *SJ.out.tab
└── featureCount_output/    # Gene count matrices
    ├── *.count.txt
    └── *.count.txt.summary
```

## Configuration
Edit `conf.txt` to specify:

```bash
# Required paths
myDATADIR="/path/to/data"              # FastQ files location
myGenomeDIR="/path/to/genome"          # Reference genome directory
myGenomeGTF="/path/to/annotation.gtf"  # Gene annotation file
STAR_HG19_GENOME="/path/to/star/index" # STAR genome index
N_CPUS=8                              # Number of CPU cores

# Optional parameters
h_vmem="10G"                          # Memory per core
h_rt="24:00:00"                       # Maximum runtime
```

## STAR Alignment Parameters

Key alignment parameters used:
```bash
--outSAMstrandField intronMotif       # Include strand field
--outFilterIntronMotifs RemoveNoncanonical  # Filter non-canonical junctions
--outSAMtype BAM Unsorted             # Output unsorted BAM
--outReadsUnmapped Fastx              # Save unmapped reads
```

## featureCounts Parameters

Gene quantification settings:
```bash
-t exon           # Feature type
-g gene_id        # Attribute type
-T $N_CPUS        # Number of threads
```

## Troubleshooting

### Common Issues

1. **Memory Issues**
   - Increase h_vmem in script header
   - Reduce number of parallel processes
   - Consider using smaller chunks of data

2. **STAR Alignment Errors**
   - Verify genome index
   - Check disk space
   - Validate input FastQ format

3. **featureCounts Problems**
   - Verify GTF file format
   - Check BAM file integrity
   - Ensure sufficient file permissions

### Error Messages

- `STAR: command not found` - Module not loaded correctly
- `ERROR: can't open GTF file` - Check file path and permissions
- `ERROR: no input files specified` - Verify FastQ file naming

## Performance Optimization

1. **Resource Allocation**
   - Adjust N_CPUS based on system
   - Balance memory per core
   - Monitor disk I/O

2. **File Management**
   - Use SSD for temporary files
   - Clean up intermediate files
   - Implement staged processing

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Applications
This pipeline has been used in the following publications:

1. "PD-1 combination therapy with IL-2 modifies CD8+ T cell exhaustion program"
   - *Nature*. 2022 Oct;610(7933):737-743
   - DOI: [10.1038/s41586-022-05257-0](https://doi.org/10.1038/s41586-022-05257-0)
   - PMID: [36215562](https://pubmed.ncbi.nlm.nih.gov/36215562)
   - PMCID: [PMC9927214](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9927214/)
   - Used for transcriptome analysis of exhausted T cells

2. "Loss of T cell progenitor reprogramming potential in aging bone marrow niches"
   - *JCI Insight*. 2020 Apr 9;5(7):e134356
   - DOI: [10.1172/jci.insight.134356](https://doi.org/10.1172/jci.insight.134356)
   - PMID: [32191644](https://pubmed.ncbi.nlm.nih.gov/32191644/)
   - PMCID: [PMC7101137](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7101137/)
   - Used for analyzing bone marrow T cell progenitor transcriptome

Code availability:
⭐ [rohitrrj/RNAseq_Pipeline](https://github.com/rohitrrj/RNAseq_Pipeline) - High-throughput RNA sequencing analysis pipeline

## Contributing
Contributions are welcome! Please read the contributing guidelines before submitting pull requests.

## Acknowledgments
- STAR aligner development team
- Subread/featureCounts developers
- Supporting institutions and funding
