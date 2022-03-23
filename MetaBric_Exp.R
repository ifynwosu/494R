library(tidyverse)
library(janitor)

#variables to be used later
match_1 <- c()
match_2 <- c()

#read hgnc symbol table from this url
HGNC_symbol_conv <- read_tsv("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt")
  selected <- select(HGNC_symbol_conv, symbol, ensembl_gene_id)

#read expression file from this URL
metaBric_exp <- read_tsv("https://media.githubusercontent.com/media/cBioPortal/datahub/master/public/brca_metabric/data_mrna_agilent_microarray_zscores_ref_diploid_samples.txt")

#remove rows with greater than or equal to 25% NA values, rename initial column to a more descriptive title
for(i in 1:nrow(metaBric_exp)) {
  if((sum(is.na(metaBric_exp[i,]))/ncol(metaBric_exp)) >= 0.25) {
    metaBric_exp[i,] <- list(NA)
  }
}
metaBric_exp <- remove_empty(metaBric_exp, "rows") %>%
  rename("hgnc_symbol" = "Hugo_Symbol") %>%
  arrange(hgnc_symbol)

#create a universal copy of dataset to be manipulated
filename <- metaBric_exp

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
metaBric_exp <- filename