library(tidyverse)
library(janitor)
source("functions/update_gene_symbols.R")

#read expression file from this URL
metaBric_exp <- read_tsv("https://media.githubusercontent.com/media/cBioPortal/datahub/master/public/brca_metabric/data_mrna_agilent_microarray_zscores_ref_diploid_samples.txt")

#remove rows with greater than or equal to 25% NA values, rename initial column to a more descriptive title
#update gene symbols using custom function
for(i in 1:nrow(metaBric_exp)) {
  if((sum(is.na(metaBric_exp[i,]))/ncol(metaBric_exp)) >= 0.25) {
    metaBric_exp[i,] <- list(NA)
  }
}
metaBric_exp <- remove_empty(metaBric_exp, "rows") %>%
  select(-contains("Entrez")) %>%
  rename("symbol" = "Hugo_Symbol")

metaBric_exp <- update_gene_symbols(metaBric_exp)