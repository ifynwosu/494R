library(GEOquery)
library(tidyverse)
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 3)

gseID <- getGEO("GSE62944")

df <- gseID[[1]]

suppFile1 <- getGEOSuppFiles("GSE62944", filter_regex = "GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz")

CancerType <- read_tsv("GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz", col_names = F)
colnames(CancerType) <- c("Sampleid", "cancertype")

suppFile2 <- getGEOSuppFiles("GSE62944", filter_regex = "GSE62944_06_01_15_TCGA_24_548_Clinical_Variables_9264_Samples.txt.gz")

Clinical_Variables <- read_tsv("GSE62944_06_01_15_TCGA_24_548_Clinical_Variables_9264_Samples.txt.gz", col_names = F)
Clinical_Variables <- select(Clinical_Variables, -(X2:X3))

Transposed_df <- as.data.frame(t(Clinical_Variables), stringsAsFactors = FALSE)
Transposed_df[1,1] <- "Sampleid"
Header <- Transposed_df[1,]
colnames(Transposed_df) <- Header
Transposed_df <- Transposed_df[-c(1),]

Merged_df <- inner_join(Transposed_df, CancerType, by = "Sampleid")

Merged_df <- mutate_all(Merged_df, funs(replace(., .=="[Unknown]", NA)))
Merged_df <- mutate_all(Merged_df, funs(replace(., .=="[Not Available]", NA)))
Merged_df <- mutate_all(Merged_df, funs(replace(., .=="[Not Evaluated]", NA)))

#filter to BC, janitor package for relevant columns

bc_df <- filter(Merged_df, tumor_tissue_site=="Breast") %>%
          filter(bcr_patient_uuid!="NA")
bc_df[c(14:26, 28:34, 36:58, 63:69, 71:79, 81, 83:110, 112, 114:126, 128, 130:141, 164:549)] <- list(NULL)