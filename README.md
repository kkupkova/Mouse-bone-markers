# Mouse bone markers

Creating a databse of bone biomarkers for mouse by combining multiple sources. 

### 1. Download markers from sources

#### [CellMarker 2.0](http://bio-bigdata.hrbmu.edu.cn/CellMarker/index.html)
> Download [mouse cell markers](http://bio-bigdata.hrbmu.edu.cn/CellMarker/CellMarker_download_files/file/Cell_marker_Mouse.xlsx), save as csv to `/CellMarker2_0/Cell_marker_Mouse.csv`

> Download [single-cell markers](http://bio-bigdata.hrbmu.edu.cn/CellMarker/CellMarker_download_files/file/Cell_marker_Seq.xlsx), save as csv to `/CellMarker2_0/Cell_marker_Seq.csv`

#### [MSigDB](https://www.gsea-msigdb.org/gsea/msigdb/index.jsp)
> Download [M8: cell type signature set](https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2023.1.Mm/m8.all.v2023.1.Mm.symbols.gmt) and save it as `/MSigDB/m8.all.v2023.1.Mm.symbols.gmt`


#### [PanglaoDB](https://panglaodb.se/index.html)
> Download [PanglaoDB for all cell types](https://panglaodb.se/markers/PanglaoDB_markers_27_Mar_2020.tsv.gz) unzip, and save it as `/PanglaoDB/PanglaoDB_markers_27_Mar_2020.tsv`

#### [TISSUES](https://tissues.jensenlab.org/Search)
> Download [mouse Knowledge channel](https://download.jensenlab.org/mouse_tissue_knowledge_full.tsv) and save as `/TISSUES/mouse_tissue_knowledge_full.tsv`
> Download [mouse Experiment channel](https://download.jensenlab.org/mouse_tissue_experiments_full.tsv) and save as `/TISSUES/mouse_tissue_experiments_full`

### 2. Create database
Using [/R_scripts/process_databases.R](https://github.com/kkupkova/Mouse-bone-markers/blob/main/R_scripts/process_databases.R) script  extract bone-relevant features from all downloaded datasets and create bone-relavant marker database (or just get the processed TSV file [here](BONE_DATABASE.tsv)).

R script [/R_scripts/make_database_as_lists.R](https://github.com/kkupkova/Mouse-bone-markers/blob/main/R_scripts/make_database_as_lists.R) takes the full database and reshapes it into lists (used in enrichment analysis of ranked lists by for example [fgsea](https://bioconductor.org/packages/release/bioc/html/fgsea.html)). The final lists are following:

- list with markers for individual cell types: [/BONE_DATABASE_lists/bone_cellType.Rdata](https://github.com/kkupkova/Mouse-bone-markers/blob/main/BONE_DATABASE_lists/bone_cellType.Rdata)
- list with markers for individual cell types separated by source database: [/BONE_DATABASE_lists/bone_cellType_and_sourceDB.Rdata](https://github.com/kkupkova/Mouse-bone-markers/blob/main/BONE_DATABASE_lists/bone_cellType_and_sourceDB.Rdata)
- list with markers for individual tissues: [/BONE_DATABASE_lists/bone_tissue.Rdata](https://github.com/kkupkova/Mouse-bone-markers/blob/main/BONE_DATABASE_lists/bone_tissue.Rdata)
- list with markers for individual tissues separated by source database: [/BONE_DATABASE_lists/bone_tissue_and_sourceDB.Rdata](https://github.com/kkupkova/Mouse-bone-markers/blob/main/BONE_DATABASE_lists/bone_tissue_and_sourceDB.Rdata)
