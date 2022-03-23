library(GEOquery)
library(tidyverse)
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072*3)

#variables to be used later
match_1 <- c()
match_2 <- c()

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#read hgnc symbol table from this url
HGNC_symbol_conv <- read_tsv("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt")
  selected <- select(HGNC_symbol_conv, symbol, ensembl_gene_id)

#fetch RAW file from GEO and store in dataDir
getGEOSuppFiles(GEO = "GSE62944", makeDirectory = F, baseDir = "dataDir", filter_regex = "GSE62944_RAW.tar")

#unzip the tar file for access to internal files
untar("dataDir/GSE62944_RAW.tar", exdir = "dataDir")

#read tumor and normal gene expression data from untarred RAW file, rename initial column to a more descriptive title
GSE62944_tumor_exp <- read_tsv("dataDir/GSM1536837_01_27_15_TCGA_20.Illumina.tumor_Rsubread_TPM.txt.gz") %>%
  rename("hgnc_symbol" = "...1") %>%
  arrange(hgnc_symbol)

GSE62944_normal_exp <- read_tsv("dataDir/GSM1697009_06_01_15_TCGA_24.normal_Rsubread_TPM.txt.gz") %>%
  rename("hgnc_symbol" = "...1") %>%
  arrange(hgnc_symbol)

#create a universal copy of dataset to be manipulated
filename <- GSE62944_tumor_exp
filename2 <- GSE62944_normal_exp

#create a vector of the file's current hgnc ids
symbol_v <- c(pull(filename[1]))

#fill vectors with the positions of out-of-date ids
for(i in 1:length(symbol_v)) {
  match_1 <- c(which(symbol_v %in% HGNC_symbol_conv$alias_symbol))
  match_2 <- c(which(symbol_v %in% HGNC_symbol_conv$prev_symbol))
}

#replace out-of-date ids
for(i in 1:length(match_1)) {
  filtered <- filter(HGNC_symbol_conv, alias_symbol == symbol_v[match_1[i]])
  filename[match_1[i], 1] <- filtered[1, 2]
}
for(i in 1:length(match_2)) {
  filtered <- filter(HGNC_symbol_conv, prev_symbol == symbol_v[match_2[i]])
  filename[match_2[i], 1] <- filtered[1, 2]
}

symbol_v_2 <- c(pull(filename2[1]))

for(i in 1:length(symbol_v_2)) {
  match_1 <- c(which(symbol_v_2 %in% HGNC_symbol_conv$alias_symbol))
  match_2 <- c(which(symbol_v_2 %in% HGNC_symbol_conv$prev_symbol))
}
for(i in 1:length(match_1)) {
  filtered <- filter(HGNC_symbol_conv, alias_symbol == symbol_v_2[match_1[i]])
  filename2[match_1[i], 1] <- filtered[1, 2]
}
for(i in 1:length(match_2)) {
  filtered <- filter(HGNC_symbol_conv, prev_symbol == symbol_v_2[match_2[i]])
  filename2[match_2[i], 1] <- filtered[1, 2]
}

#apply ensembl ids for hgnc symbols that have them
filename <- merge(selected, filename, by.x = "symbol", by.y = "hgnc_symbol", all.y = T)
filename2 <- merge(selected, filename2, by.x = "symbol", by.y = "hgnc_symbol", all.y = T)

#make the titled table the updated version
GSE62944_tumor_exp <- filename
GSE62944_normal_exp <- filename2