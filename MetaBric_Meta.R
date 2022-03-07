library(tidyverse)

#download the patient data from this URL
metaBric <- read_tsv("https://media.githubusercontent.com/media/cBioPortal/datahub/master/public/brca_metabric/data_clinical_patient.txt", comment"#")
