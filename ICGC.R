library(tidyverse)

#zip files downloaded from these url's and read into respective tables
download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/donor.BRCA-KR.tsv.gz", destfile = "~")
icgcDonor <- read_tsv(gzfile("donor.BRCA-KR.tsv.gz"))

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/donor_exposure.BRCA-KR.tsv.gz", destfile = "~")
icgcExposure <- read_tsv(gzfile("donor_exposure.BRCA-KR.tsv.gz"))

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/donor_family.BRCA-KR.tsv.gz", destfile = "~")
icgcFamily <- read_tsv(gzfile("donor_family.BRCA-KR.tsv.gz"))

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-KR/donor_surgery.BRCA-KR.tsv.gz", destfile = "~")
icgcSurgery <- read_tsv(gzfile("donor_surgery.BRCA-KR.tsv.gz"))