update_gene_symbols <- function(filename){

library(tidyverse)

#variables to be used later
match_1 <- c()
match_2 <- c()

#read hgnc symbol table from this url
HGNC_symbol_conv <- read_tsv("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt")
  selected <- select(HGNC_symbol_conv, symbol, ensembl_gene_id)

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
}