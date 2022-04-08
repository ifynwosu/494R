library(GEOquery)
library(tidyverse)
source("functions/update_gene_symbols.R")

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#pull expression file from GEO, sort into table excluding replicates, update hgnc symbols and add entrez ids
getGEOSuppFiles(GEO = "GSE96058", makeDirectory = F, baseDir = "dataDir", filter_regex = "GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz")
GSE96058_exp_table <- read_csv("dataDir/GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz") %>%
  select(-contains("repl")) %>%
  rename("symbol" = "...1")

GSE96058_exp_table <- update_gene_symbols(GSE96058_exp_table)
