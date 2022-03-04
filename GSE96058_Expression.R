library(GEOquery)
library(tidyverse)

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#pull expression file from GEO, sort into table excluding replicates
exp_file <- getGEOSuppFiles(GEO = "GSE96058", makeDirectory = F, baseDir = "dataDir", filter_regex = "GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz")
exp_file_table <- read_csv("dataDir/GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz") %>%
  select(-contains("repl")) %>%
  rename("gene" = "...1")
