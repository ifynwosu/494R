library(GEOquery)
library(tidyverse)

source("functions/removeColsWithOnlyOneValue.R")

#get ExpressionSet from GEO for "this" GEO tag, create data frame of relevant information
gseID <- getGEO("GSE96058")
df <- gseID[[1]]

#pull phenotype data from GEO data frame
mdata <- pData(df)

#remove columns with variables which are all the same
mdata_refined <- removeColsWithOnlyOneValue(mdata)

#remove columns which start with this prefix as they are duplicates of other columns 
mdata_refined <- select(mdata_refined, -starts_with("characteristics_ch1."))