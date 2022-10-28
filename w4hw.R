getwd()

library(tidyverse)
library(dplyr)
library(rgdal) 
library(sf)
library(readr)
library(stringr)
library(janitor)
library(maptools)
library(here)
library(plotly)
library(dplyr)
library(maptools)
library(janitor)
library(RColorBrewer)
library(classInt)
library(sp)
library(rgeos)
library(tmap)
library(tmaptools)
library(countrycode)

gender_global <- read_csv("HDR21-22_Composite_indices_complete_time_series.csv",
                   locale = locale(encoding = "latin1"),
                   na = " ")
world<- st_read(("World_Countries_(Generalized)/World_Countries__Generalized_.shp"))

#CLEANING
gender_global_clean <- gender_global %>% 
  clean_names() %>% 
  dplyr::select(contains("country"),
                contains("iso3"),
                contains("gii_201")) %>% 
  mutate(diff1019=(gii_2019-gii_2010))

#ADD ISO
dfgender_global <- as.data.frame(gender_global_clean)
gender_globolcode_clean <- countrycode(dfgender_global$iso3, origin ='iso3c', destination ='iso2c',nomatch = NULL)
dfgender_global$iso2 <-c(gender_globolcode_clean)
tbgender_global <- as_tibble(dfgender_global)

#JOIN
gender_inequal_map<- world %>% 
  clean_names() %>% 
  left_join(., 
            tbgender_global,
            by = c("iso" = "iso2")) %>% 
  distinct(.,iso,
           .keep_all = TRUE) %>% 
  filter(gii_2010 != "") %>% 
  dplyr::select(-iso3, -aff_iso, -country.y, -countryaff)

