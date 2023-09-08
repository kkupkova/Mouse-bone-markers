rm(list = ls())


library(tidyverse)
library(qusage)


# load all databases

# 1) cell Marker mouse
CM_mouse = read.csv("CellMarker2_0/Cell_marker_Mouse.csv") %>% 
  dplyr::filter(tissue_class %in% c("Bone", "Bone marrow")) %>% 
  dplyr::select(tissue_class, cell_name, marker, Symbol) %>% 
  mutate(Symbol = ifelse(Symbol == "", str_to_title(marker), Symbol)) %>% 
  mutate(database = "CellMarker2_mouse") %>% 
  dplyr::rename(tissue = tissue_class) %>% 
  dplyr::rename(cellType = cell_name) %>% 
  dplyr::rename(gene = Symbol) %>% 
  mutate(type = "mature") %>% 
  dplyr::select(tissue, cellType, type, gene, database)

# 2) cell Marker single cell
CM_sc = read.csv("CellMarker2_0/Cell_marker_Seq.csv") %>% 
  filter(species == "Mouse") %>% 
  dplyr::filter(tissue_class %in% c("Bone", "Bone marrow")) %>% 
  dplyr::select(tissue_class, cell_name, marker, Symbol) %>% 
  mutate(Symbol = ifelse(Symbol == "", str_to_title(marker), Symbol)) %>% 
  mutate(database = "CellMarker2_mouse_sc")%>% 
  dplyr::rename(tissue = tissue_class) %>% 
  dplyr::rename(cellType = cell_name) %>% 
  dplyr::rename(gene = Symbol)%>% 
  mutate(type = "mature") %>% 
  dplyr::select(tissue, cellType, type, gene, database)

# 3) MSigDB
Msig = reshape2::melt(read.gmt("MSigDB/m8.all.v2023.1.Mm.symbols.gmt")) %>% 
  dplyr::rename(gene = value) %>% 
  dplyr::filter(grepl('MURIS_SENIS_MARROW_|ORGANOGENESIS_CHONDROCYTE|ORGANOGENESIS_OSTEOBLASTS', L1)) %>% 
  mutate(type = ifelse(grepl('ORGANOGENESIS', L1), "organogenesis", "mature")) %>% 
  separate(L1, into = c("toss", "toss2","keep"), sep = "_", extra = "merge") %>%
  mutate_at("keep", str_replace, "SENIS_", "") %>% 
  dplyr::select(-c(toss, toss2)) %>% 
  mutate(tissue = ifelse(startsWith(keep, "MARROW"), "Bone marrow", 
                         ifelse(keep == "CHONDROCYTE_PROGENITORS", "Chondrocyte",
                                ifelse(keep == "CHONDROCYTES_AND_OSTEOBLASTS", "Bone or Chondrocyte", "Bone")))) %>% 
  mutate_at("keep", str_replace, "MARROW_", "") %>% 
  mutate_at("keep", str_replace, "_AGEING", "")%>%
  mutate(cellType = str_to_title(keep)) %>% 
  dplyr::select(-keep) %>% 
  mutate(database = "MSigDB") %>% 
  dplyr::select(tissue, cellType, type, gene, database)

# 4) PanglaoDB
Panglao = read.delim("PanglaoDB/PanglaoDB_markers_27_Mar_2020.tsv", sep = "\t") %>% 
  dplyr::filter(species %in% c("Mm Hs", "Mm")) %>% 
  dplyr::filter(organ == "Bone") %>% 
  mutate(tissue = ifelse(organ == "Hematopoietic stem cells", "Bone marrow", "Bone")) %>% 
  mutate(database = "PanglaoDB") %>% 
  mutate(type = "mature") %>% 
  dplyr::select(tissue, cellType, type, gene, database)
  

# 5) TISSUES
tissuesKnowledge = read.delim("TISSUES/mouse_tissue_knowledge_full.tsv", header = FALSE)
tissueExperiment = read.delim("TISSUES/mouse_tissue_experiments_full.tsv", header = FALSE)

tissues = rbind(tissuesKnowledge, tissueExperiment) %>% 
  dplyr::filter(V4 %in% c("Hematopoietic system", "Bone marrow", "Bone", 
                          "Marrow cell", "Osteoblast", "Osteogenic cell", 
                          "Bone marrow stromal cell", "Osteoclast",
                          "Mesenchymal stem cell", "Bone marrow-derived macrophage")) %>% 
  mutate(tissue = ifelse(V4 %in% c("Bone", "Osteoblast", "Osteogenic cell", 
                                    "Osteoclast"), "Bone", "Bone marrow")) %>% 
  dplyr::rename(gene = V2) %>% 
  dplyr::rename(cellType = V4) %>% 
  mutate(type = "mature") %>% 
  mutate(database = "TISSUES")%>% 
  dplyr::select(tissue, cellType, type, gene, database)

# merge all curated databases into one final one
DATABASE = rbind(CM_mouse, CM_sc, Msig, Panglao, tissues) %>% 
  distinct()


write.table(DATABASE, "BONE_DATABASE.tsv", sep = "\t", quote = F, row.names = FALSE)

