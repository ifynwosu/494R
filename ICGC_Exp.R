library(tidyverse)
source("functions/removeColsWithOnlyOneValue.R")

#create or utilize directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#download expression file from this URL
download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/exp_seq.BRCA-KR.tsv.gz", destfile = "dataDir")
exp_seq <- read_tsv("dataDir/exp_seq.BRCA-KR.tsv.gz") %>%
  removeColsWithOnlyOneValue()