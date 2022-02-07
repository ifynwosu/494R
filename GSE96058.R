library(GEOquery)
library(tidyverse)

gseID <- getGEO("GSE96058")

df <- gseID[[1]]

mdata <- pData(df)

mdata_refined <- mdata
mdata_refined[c(45:50, 70:78, 80:92, 94)] <- list(NULL)