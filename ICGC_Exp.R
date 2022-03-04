library(tidyverse)
source("functions/removeColsWithOnlyOneValue.R")

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/exp_seq.BRCA-KR.tsv.gz", destfile = "~")
exp_seq <- read_tsv("exp_seq.BRCA-KR.tsv.gz") %>%
  removeColsWithOnlyOneValue()