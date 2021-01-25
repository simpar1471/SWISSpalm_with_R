# SWISSpalm_with_R
## Overview
A simple script based on RSelenium meant to streamline SWISSpalm use. Requires <b>Java</b> (available from [Oracle](https://www.java.com/en/download/)), the R package <b>glue</b> (available from the CRAN [alone](https://cran.r-project.org/web/packages/glue) or as part of the [tidyverse](https://cran.r-project.org/web/packages/tidyverse/)), and <b>RSelenium</b> (also on the [CRAN](https://cran.r-project.org/web/packages/RSelenium)).<br/><br/>Credit for the SWISSpalm database: [SwissPalm: Protein Palmitoylation database.](http://f1000research.com/articles/4-261/v1) Mathieu Blanc*, Fabrice P.A. David*, Laurence Abrami, Daniel Migliozzi, Florence Armand, Jérôme Burgi and F. Gisou van der Goot. F1000Research.
## Usage
### <b>Step 1:</b> 
Install prerequisite packages and Java. R packages can be installed using `install.packages()`:
```R
install.packages("glue")
install.packages("RSelenium")
```
Java must be installed from the [Oracle website](https://www.java.com/en/download/).
### <b>Step 2:</b> 
Run the `SWISSpalm_with_R.R` script in your instance of R to load its functions into your environment.
### <b>Step 3:</b>
Now you are ready to use the `getSWISSPalmData()` command. This will take longer the first time you use it, as RSelenium downloads new versions of chromedriver and the Selenium Server. as needs be. Subsequent calls should take less time, but are limited by the calls to `Sys.sleep()` which allow webpages to load/downloads to occur. The syntax is as follows:
```R
getSWISSPalmData(input.path, output.directory, dataset.value = 1, species.value = 2, output.type = "download_text")
```
Where:<br>
<b>input.path</b> = The file path of the text file you're submitting to SWISSpalm. This is best set in R using `file.path()`. The input .txt file must follow these [formatting guidelines](https://swisspalm.org/file_formats). I would advise not including a header. Each line must have one identifier of the following types given below:
  <details>  
    <summary>List of valid identifiers</summary><p>
  
    UniProt AC
    UniProt secondary AC
    UniProt ID
    UniProt gene name
    Ensembl protein
    Ensembl gene
    Refseq protein ID
    IPI ID
    UniGene ID
    PomBase ID
    MGI ID
    RGD ID
    TAIR protein ID
    EuPathDb ID
  
  </p></details>
  
<b>output.directory</b> = The directory for SWISSpalm to send its outputs to. This is best set in R using `file.path()`</br>
<b>dataset.value </b> = The dataset you want to search. This can be an integer from 1 to 7.
  <details>  
    <summary>List of values and their meanings</summary><p>
  
    Dataset 1: All proteins
    Dataset 2: Proteins predicted to be palmitoylated
    Dataset 3: Palmitoylation validated or found in at least 1 palmitoyl-proteome (SwissPalm annotated)
    Dataset 4: Palmitoylation validated proteins
    Dataset 5: Palmitoylation validated proteins or found in palmitoyl-proteomes using 2 independent methods
    Dataset 6: Found in palmitoyl-proteomes using 2 independent methods
    Dataset 7: Dataset 6 grouped by gene
  
  </p></details>
  
<b>species.value</b> = The species you want to filter your results by. This can be an integer from 1 to 87, though some values are skipped (e.g. 5 doesn't map onto a species)<br>
  <details>  
    <summary> List of values and their species</summary>
  
    1 = Homo sapiens
    2 = Mus musculus
    3 = Rattus norvegicus
    4 = Arabidopsis thaliana
    6 = Saccharomyces cerevisiae
    7 = Cricetulus griseus
    8 = Plasmodium falciparum
    9 = Chlorocebus aethiops
    10 = Bos taurus
    11 = Schizosaccharomyces pombe
    12 = Canis familiaris
    13 = Drosophila melanogaster
    14 = Danio rerio
    15 = HIV1 isolate HXB2
    16 = Spodoptera frugiperda
    17 = Gallus gallus
    18 = Human herpesvirus 1
    19 = Semliki forest virus
    20 = Sindbis virus (the [first recorded palmitoylated biological agent](https://dx.doi.org/10.1073/pnas.76.4.1687))
    21 = Oryctolagus cuniculus
    22 = Sus scrofa
    23 = Toxoplasma gondii
    24 = Torpedo californica
    25 = Nicotiana benthamiana
    26 = Landoltia punctata
    27 = Influenza A virus (A/udorn/1972(H3N2))
    28 = Giardia intestinalis
    29 = Ecc15
    30 = Influenza A virus (strain A/Duck/Ukraine/1/1963 H3N8)
    31 = Escherichia coli BL21-DE3
    32 = Salmonella typhimurium
    33 = Medicago truncatula
    34 = Influenza C virus (strain C/Johannesburg/1/1966)
    35 = Simian immunodeficiency virus
    36 = Cryptococcus neoformans
    38 = Trypanosoma brucei brucei
    39 = Mesocricetus auratus
    40 = HIV-1 NY5
    41 = HIV-1 BH10
    42 = Xenopus laevis
    43 = Fr-MuLV
    44 = Human adenovirus 5
    45 = Leishmania major
    46 = RRV (strain T48)
    47 = Caenorhabditis elegans
    48 = HHV-4
    49 = Ki-MuSV
    50 = Ha-MuSV
    51 = Escherichia coli K12
    53 = VACV
    54 = Influenza A virus H7N1
    55 = VSV
    56 = Macaca mulata
    57 = Solanum lycopersicum
    58 = Aspergillus fumigatus
    60 = Trypanosoma brucei brucei (927/4 GUTat10.1)
    61 = Equus caballus
    62 = MCF-MuLV
    63 = MoMuLV (ts1-92b)
    64 = MoMLV
    65 = Neosartorya fumigata
    66 = Toxoplasma gondii Me49
    67 = HCMV
    68 = MHV-A59
    69 = Medicago falcata
    70 = Oryza sativa
    71 = RSV-PrC
    72 = HHV-8
    73 = Mallard duck
    74 = AcMNPV
    75 = Dictyostelium discoideum
    76 = HCV
    77 = SARS-CoV
    78 = Lithobates catesbeiana
    79 = Trichomonas vaginalis
    82 = BCTV
    83 = HEV-3
    84 = HEV-1
    85 = Mungbean yellow mosaic virus-Vigna
    87 = CHIKV-S27
    
</details>

<b>output.type</b> = The type of output file you desire. Set this to one of three values: `"download_text"`,`"download_xlsx"` or `"download_fasta"`."<br>
### <b>Step 4:</b>
To use the files you've received, you need to know what each file contains.
* `not_in_database.txt` contains each gene ID not found in the SWISSpalm database.
* `not_in_dataset.txt` contains each gene ID not found in the SWISSpalm database.
* `query_results.txt` contains palmitoylation data of your genes that SWISSpalm analysed. 
## Example
```R
# Extract dataframe of gene IDs (in MGI ID format) from existing dataframe.
# Using distinct() from dplyr means I have no repeated gene IDs.
gene_list <- dplyr::distinct(my_gene_table, mgi_id) 
# Write this list of genes out to a text file with no header
write.table(gene_list, 
            file.path("data","SWISSpalm_inputs","gene_list.txt"), 
            append = FALSE, dec = ".", quote = FALSE, 
            row.names = FALSE, col.names = FALSE)
input <- file.path("data","SWISSpalm_inputs","gene_list.txt")
output <- file.path("data","SWISSpalm_outputs")
getSWISSpalmData(input, output, dataset.value = 1, species.value = 2, output.type = "download_text")
# Import query_results.txt 
results <- read.table(file.path("data","SWISSpalm_outputs","query_result.txt"),
                      quote = "", fill = TRUE,
                      sep = "\t",
                      header = TRUE) 
```
