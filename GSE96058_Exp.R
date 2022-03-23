library(GEOquery)
library(tidyverse)

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#variables to be used later
match_1 <- c()
match_2 <- c()

#read hgnc symbol table from this url
HGNC_symbol_conv <- read_tsv("http://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt")
  selected <- select(HGNC_symbol_conv, symbol, ensembl_gene_id)

#pull expression file from GEO, sort into table excluding replicates
GSE96058_exp <- getGEOSuppFiles(GEO = "GSE96058", makeDirectory = F, baseDir = "dataDir", filter_regex = "GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz")
GSE96058_exp_table <- read_csv("dataDir/GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz") %>%
  select(-contains("repl")) %>%
  rename("hgnc_symbol" = "...1") %>%
  arrange(hgnc_symbol)

#create a universal copy of dataset to be manipulated
filename <- GSE96058_exp_table

#create a vector of the file's current hgnc symbols
symbol_v <- c(pull(filename[1]))

#fill vectors with the positions of out-of-date symbols
for(i in 1:length(symbol_v)) {
  match_1 <- c(which(symbol_v %in% HGNC_symbol_conv$alias_symbol))
  match_2 <- c(which(symbol_v %in% HGNC_symbol_conv$prev_symbol))
}

#replace out-of-date symbols
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
GSE96058_exp_table <- filename