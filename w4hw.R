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

gender_global <- read_csv("HDR21-22_Statistical_Annex_GII_Table.csv",
                   locale = locale(encoding = "latin1"),
                   na = "NULL")
world<- st_read(("World_Countries_(Generalized)/World_Countries__Generalized_.shp"))

#CLEANING
gender_global_clean <- gender_global %>% 
  clean_names() %>% 
  rename(., hdi_index = back,
         country = table_5_gender_inequality_index,
         gender_inequality_index=x3,
         rank_2021 = x5) %>% 
  select(hdi_index, country, gender_inequality_index, rank_2021) %>% 
  filter(hdi_index != "",
         gender_inequality_index != "",
         gender_inequality_index!= "..") %>% 
  add_column(diff1019 = '')

dfgender_global <- as.data.frame(gender_global_clean)

#ADD ISO
gender_globolcode_clean <- countrycode(dfgender_global$country, origin ='country.name', destination ='iso2c',nomatch = NULL)
dfgender_global$iso2 <-c(gender_globolcode_clean)

tbgender_global <- as_tibble(dfgender_global)

#Join
gender_inequal_map<- world %>% 
  clean_names() %>% 
  right_join(., 
            tbgender_global,
            by = c("iso" = "iso2")) %>% 
  distinct(.,iso,
           .keep_all = TRUE)

