library(tidyverse)

#zip files downloaded from these url's and read into respective tables
download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/donor.BRCA-KR.tsv.gz", destfile = "~")
icgcDonor <- read_tsv(gzfile("donor.BRCA-KR.tsv.gz"))

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/specimen.BRCA-KR.tsv.gz", destfile = "~")
icgcSpecimen <- read_tsv(gzfile("specimen.BRCA-KR.tsv.gz"))
