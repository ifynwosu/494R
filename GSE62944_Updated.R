library(GEOquery)
library(tidyverse)
library(janitor)
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072*3)

#create Directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#save supplementary files to Directory and read into separate data frames
cancerTypeSamples <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = data_Dir, filter_regex = "GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz")

CancerType <- read_tsv("dataDir/GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz", col_names = F)
colnames(CancerType) <- c("Sampleid", "cancertype")

clinicalVariables <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = data_Dir, filter_regex = "GSE62944_06_01_15_TCGA_24_548_Clinical_Variables_9264_Samples.txt.gz")

Clinical_Variables <- read_tsv("dataDir/GSE62944_06_01_15_TCGA_24_548_Clinical_Variables_9264_Samples.txt.gz", col_names = F)
Clinical_Variables <- select(Clinical_Variables, -(X2:X3))

#manipulate Clinical_Variables for ease in merging
Transposed_df <- as.data.frame(t(Clinical_Variables), stringsAsFactors = F)
Transposed_df[1,1] <- "Sampleid"
Header <- Transposed_df[1,]
colnames(Transposed_df) <- Header
Transposed_df <- Transposed_df[-c(1),]

#merge the data frames by Sampleid
Merged_df <- inner_join(Transposed_df, CancerType, by = "Sampleid")

#replace the unique negative variables in the merged table with NA
Merged_df <- mutate_all(Merged_df, funs(replace(., .=="[Unknown]", NA)))
Merged_df <- mutate_all(Merged_df, funs(replace(., .=="[Not Available]", NA)))
Merged_df <- mutate_all(Merged_df, funs(replace(., .=="[Not Evaluated]", NA)))

#filter for breast cancer samples only
bc_df <- filter(Merged_df, tumor_tissue_site=="Breast") %>% 
  filter(bcr_patient_uuid!="NA") %>% 
  remove_empty("cols")

#find the percentage of filled:missing variables from each column & remove columns with a percentage-filled value of less than 0.500
for(i in 1:ncol(bc_df)){
    if((nrow(bc_df) - sum(is.na(bc_df[i])))/nrow(bc_df) < 0.500){
      bc_df[i] <- list(NA)
    }
}

bc_df <- remove_empty(bc_df, "cols")