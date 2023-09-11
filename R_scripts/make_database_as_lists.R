# make the TSV file with the database into lists

rm(list = ls())
library(tidyverse)

database = read.delim("BONE_DATABASE.tsv")

# database only by cell type - from all sources
cellType = database %>% 
  dplyr::select(cellType, gene) %>% 
  distinct()
cellType_list = split(cellType$gene, cellType$cellType)
save(cellType_list, file = "BONE_DATABASE_lists/bone_cellType.Rdata")

# database by source and cell type 
cellTypeSource = database %>% 
  dplyr::select(database, cellType, gene) %>% 
  distinct() %>% 
  mutate(groupName = paste(database, cellType, sep = "__"))
cellTypeSource_list = split(cellTypeSource$gene, cellTypeSource$groupName)
save(cellTypeSource_list, file = "BONE_DATABASE_lists/bone_cellType_and_sourceDB.Rdata")

# database only by tissue - from all sources
tissue = database %>% 
  dplyr::select(tissue, gene) %>% 
  distinct()
tissue_list = split(tissue$gene, tissue$tissue)
save(tissue_list, file = "BONE_DATABASE_lists/bone_tissue.Rdata")

# database by source and cell type 
tissueSource = database %>% 
  dplyr::select(database, tissue, gene) %>% 
  distinct() %>% 
  mutate(groupName = paste(database, tissue, sep = "__"))
tissueSource_list = split(tissueSource$gene, tissueSource$groupName)
save(tissueSource_list, file = "BONE_DATABASE_lists/bone_tissue_and_sourceDB.Rdata")
