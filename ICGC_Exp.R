library(tidyverse)
library(janitor)
source("functions/removeColsWithOnlyOneValue.R")

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#variables to be used later
match_1 <- c()
match_2 <- c()

# #read hgnc symbol table from this url
HGNC_symbol_conv <- read_tsv("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt")
  selected <- select(HGNC_symbol_conv, symbol, ensembl_gene_id)

#download expression file from this URL
download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/exp_seq.BRCA-KR.tsv.gz", destfile = "dataDir")
ICGC_exp <- read_tsv("dataDir/exp_seq.BRCA-KR.tsv.gz") %>%
  removeColsWithOnlyOneValue() %>%
  rename("hgnc_symbol" = "gene_id") %>%
  arrange(hgnc_symbol)

for(i in 1:ncol(ICGC_exp)){
  if(sum(is.na(ICGC_exp[i]))/nrow(ICGC_exp) > 0.500) {
    ICGC_exp[i] <- list(NA)
  }
}
ICGC_exp <- remove_empty(ICGC_exp, "cols")

#create a universal copy of dataset to be manipulated
filename <- ICGC_exp %>%
  select(6, 1:5, 7:length(ICGC_exp))

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

#apply ensembl ids for hgnc symbols that have them
filename <- merge(selected, filename, by.x = "symbol", by.y = "hgnc_symbol", all.y = T)

#make the titled table the updated version
ICGC_exp <- filename