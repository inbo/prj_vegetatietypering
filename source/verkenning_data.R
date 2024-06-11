library(readxl)
library(dplyr)

vn_path <- file.path("data", "VegetatieVanNederland.xlsx")
vn_sheets <- readxl::excel_sheets(vn_path)

vn_sheets

vn <- read_excel(
  vn_path
) %>%
  janitor::clean_names()


vn %>%
  count(syntaxoncode, wetenschappelijk_syntaxonnaam, nederlandse_syntaxonnaam,
        name = "aantal_soorten")
