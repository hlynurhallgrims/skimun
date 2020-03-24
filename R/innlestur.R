library(tidyverse)
library(pdftools)

skjol_slod <- fs::dir_ls("data")

allt <- skjol_slod %>% 
  map(~pdf_text(.)) %>% 
  map(~str_detect(., pattern = "^FMS-EBL-029"))

#Lítil breyting