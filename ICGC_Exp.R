library(tidyverse)
library(janitor)
source("functions/update_gene_symbols.R")

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#download expression file from this URL
#download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/exp_seq.BRCA-KR.tsv.gz", destfile = "dataDir")
ICGC_exp <- read_tsv("dataDir/exp_seq.BRCA-KR.tsv.gz") %>%
  rename("symbol" = "gene_id") %>%
  select(icgc_donor_id, symbol, normalized_read_count) %>%
  mutate(normalized_read_count = log2(normalized_read_count + 1)) %>%
  pivot_wider(names_from = icgc_donor_id, values_from = normalized_read_count)
  
ICGC_exp <- update_gene_symbols(ICGC_exp)