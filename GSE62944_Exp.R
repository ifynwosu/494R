library(GEOquery)
library(tidyverse)
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072*3)

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#fetch RAW file from GEO and store in dataDir
getGEOSuppFiles(GEO = "GSE62944", makeDirectory = F, baseDir = "dataDir", filter_regex = "GSE62944_RAW.tar")

#unzip the tar file for access to internal files
untar("dataDir/GSE62944_RAW.tar", exdir = "dataDir")

#read tumor and normal gene expression data from untarred RAW file
GSE62944_tumor_expression <- read_tsv("dataDir/GSM1536837_01_27_15_TCGA_20.Illumina.tumor_Rsubread_TPM.txt.gz")
GSE62944_normal_expression <- read_tsv("dataDir/GSM1697009_06_01_15_TCGA_24.normal_Rsubread_TPM.txt.gz")