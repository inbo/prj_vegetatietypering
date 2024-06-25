library(readxl)
library(dplyr)

vn_path <- file.path("data", "q_synoptische_tabellen_2005.xlsx")
vn_sheets <- readxl::excel_sheets(vn_path)

vn_sheets

vn <- read_excel(
  vn_path,
  sheet = vn_sheets
) %>%
  janitor::clean_names()


vn %>%
  count(syntaxoncode, wetenschappelijk_syntaxonnaam, nederlandse_syntaxonnaam,
        name = "aantal_soorten")

vn_soorten <- vn %>%
  distinct(soortnummer, soortnaam)

any(is.na(vn_soorten)) #OK

# de soortnamen bevatten niet de auteursnaam, maar wellicht kunnen we hiermee
# wel verder. Bv via koppeling met de GBIF taxonomic backbone.

# onderstaande code niet meer nodig omdat nieuwe excel tabel de soortnamen bevat
################################################################################

# bron = https://www.verspreidingsatlas.nl/soortenlijst/vaatplanten
standaardlijst_nl <- readr::read_csv2(
  file.path("data/soortenlijst-14-06-2024-14-09-25.csv")
) %>%
  janitor::clean_names()

# bron = export uit turboveg
floralijst_nl_turboveg <- read_excel(
  file.path("data", "floralijst_nederland.xlsx")
) %>%
  janitor::clean_names()

floralijst_nl_turboveg_unieke <- floralijst_nl_turboveg %>%
  filter(!is.na(lettercode),
         !(is.na(nativename) & lettercode == "RANU-SP"))


# test koppeling met standaardlijst
###################################
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


# test koppeling met floralijst van turboveg
############################################
vn_soorten_turboveg <- vn_soortnummers %>%
  inner_join(
    floralijst_nl_turboveg_unieke,
    by = join_by(soortnummer == species_nr))

vn_soortnummers_zonder_match_turboveg <- vn_soortnummers %>%
  anti_join(
    floralijst_nl_turboveg_unieke,
    by = join_by(soortnummer == species_nr))

readr::write_csv2(
  vn_soortnummers_zonder_match_turboveg,
  file.path("data", "vn_soortnummers_zonder_match_turboveg.csv")
)






