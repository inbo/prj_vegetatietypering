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

standaardlijst_nl <- readr::read_csv2(
  file.path("data/soortenlijst-14-06-2024-14-09-25.csv")
) %>%
  janitor::clean_names()


vn_soortnummers <- vn %>%
  distinct(soortnummer)

vn_soorten <- vn_soortnummers %>%
  inner_join(standaardlijst_nl, by = join_by(soortnummer))

vn_soortnummers_zonder_match <- vn_soortnummers %>%
  anti_join(standaardlijst_nl, by = join_by(soortnummer))

readr::write_csv2(
  vn_soortnummers_zonder_match,
  file.path("data", "vn_soortnummers_zonder_match.csv")
  )





