library(tidyverse)
library(janitor)

#read expression file from this URL
metaBric_exp <- read_tsv("https://media.githubusercontent.com/media/cBioPortal/datahub/master/public/brca_metabric/data_mrna_agilent_microarray_zscores_ref_diploid_samples.txt")

#remove rows with greater than or equal to 25% NA values
for(i in 1:nrow(metaBric_exp)) {
  if((sum(is.na(metaBric_exp[i,]))/ncol(metaBric_exp)) >= 0.25) {
    metaBric_exp[i,] <- list(NA)
  }
}
metaBric_exp <- remove_empty(metaBric_exp, "rows")