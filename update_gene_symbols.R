update_gene_symbols <- function(filename){

library(tidyverse)

#variables to be used later
match_1 <- c()
match_2 <- c()

#read hgnc symbol table from this url
HGNC_symbol_conv <- read_tsv("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt")
selected <- select(HGNC_symbol_conv, symbol, entrez_id)

#if it is an affymetrix dataset, append hgnc symbols to the table
if(grep("Gene", colnames(filename)) == 1){
  
  #pull entrez id from file to vector
  symbol_v <- c(pull(filename[grep("Gene", colnames(filename))]))
  
  #modify vector to delete "_at" suffix
  for(i in 1:length(symbol_v)){
    symbol_v[i] <- str_sub(symbol_v[i], 1, nchar(symbol_v[i])-3)
    }
  
  #add modified vector to table
  filename$temp <- symbol_v 
  
  #merge selected columns from hgnc symbol file and current table to acquire hgnc symbol by entrez id, removing redundant id column
  filename <- merge(selected, filename, by.x = "entrez_id", by.y = "temp", all.y = T) %>%
    select(-entrez_id)
  }

#create a vector of the file's current hgnc ids
symbol_v <- c(pull(filename[grep("symbol", colnames(filename))]))

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

#apply entrez ids for hgnc symbols that have them, for datasets that did not start with entrez ids
if(any(colnames(filename == "entrez_id"))) {
} else {
filename <- merge(selected, filename, by = "symbol", all.y = T) %>%
  rename("hgnc_gene_symbol" = "symbol") %>%
  arrange(entrez_id)
  }

#remove the redundant entrez id column
if(any(colnames(filename) == "Gene")) {
  filename <- select(filename, -entrez_id)
  }
}
