rm(list = ls())


library(tidyverse)
library(qusage)


# load all databases

# 1) cell Marker mouse
CM_mouse = read.csv("CellMarker2_0/Cell_marker_Mouse.csv") %>% 
  dplyr::filter(tissue_class %in% c("Bone", "Bone marrow")) %>% 
  dplyr::select(tissue_class, cell_name, marker, Symbol) %>% 
  mutate(database = "CellMarker2_mouse")

# 2) cell Marker single cell
CM_sc = read.csv("CellMarker2_0/Cell_marker_Seq.csv") %>% 
  filter(species == "Mouse") %>% 
  dplyr::filter(tissue_class %in% c("Bone", "Bone marrow")) %>% 
  dplyr::select(tissue_class, cell_name, marker, Symbol) %>% 
  mutate(database = "CellMarker2_mouse_sc")

# 3) MSigDB
Msig = read.gmt("MSigDB/m8.all.v2023.1.Mm.symbols.gmt")
Msig = reshape2::melt(Msig) %>% 
  dply

Msig$DESCARTES_ORGANOGENESIS_NOTOCHORD_CELLS

levels(factor(CM_sc$tissue_class))


