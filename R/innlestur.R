library(tidyverse)
library(pdftools)
library(unglue)

# Búum til lista yfir allar skjalaslóðir í data möppunni
skjol_slod <- fs::dir_ls("data")

allt_innlesid <- skjol_slod %>% 
  map(~pdf_text(.))

nota <- allt_innlesid %>%
  # Hendum út öllum blaðsíðum sem eru ekki sjálft eyðublaðið
  # og við greinum það út frá frasanum "Tilgangur jafnréttisskimunar"
  map(.x = .,
      ~.x[str_detect(.x, pattern = "Tilgangur jafnréttisskimunar")]) %>% 
  map(~str_remove_all(., pattern = regex("^.*(?=Dagsetning:)", 
                                         dotall = TRUE))) %>% 
  unlist()

rammi <- nota %>% 
  map(~str_remove_all(., "[\r\n]")) %>% #Fjarlægjum öll break
  # Skiptum því næst textanum niður í hólf og gerum hann kassalaga
  # Við notum unglue pakkann til að búa til flókið regex fyrir okkur
  unglue_data("Dagsetning:{dags}Svið:{svid}Unnið af:{unnid_af}Verkefni/tillaga:{verkefni}Þjónustuþáttur:{thjon_thattur}Stofnun/kostn.st.:{stofnun}Fjárhæð:{fjarhaed}Annað:{annad}Hver er tillagan og hvert er markmið hennar?{tillagan}Hefur verið hugað að aðgerðum við undirbúning tillögunnar til þess að stuðla að jafnrétti? Ef já, lýsið.{var_skodad_jafnretti}Hvaða hópa snertir tillagan?{hopar_snertir}Hvernig hefur tillagan áhrif á stöðu kynjanna og jaðarsetta hópa? Rökstyðjið.{ahrif_kyn_jadar}Er talin vera þörf á jafnréttismati á tillögunni?{thorf_a_mati}") %>% 
  as_tibble() %>% 
  mutate_all(str_squish) # Hendum út óþarfa línubilum
