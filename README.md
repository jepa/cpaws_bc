# CPAWS project for BC Protected Areas

This repository is intended to support the CPAWS project on the BC coast

**Authors**: Colette Wabnitz^1,2^, Juliano Palacios-Abrantes^2^, William W.L. Cheung^2^

1. Center for Ocean Solutions, Stanford
2. The Institute for the Oceans and Fisheries, University of British Columbia, Canada

# Files and Folder Organizations

## Folders

- **Scripts**
  - `initial_analysis_nb.Rmd`, script with the analysis
  - run_dbem, folder with scripts needed to run the DBEM on CC
  - slurm_out, folder with CC slurm run outputs

# Data
*Note: all data is located in the OneDrive*

- **Spatial**
  - draft_mpan, folder with mpa shapefiles for BC (CW)
  - `mpa_cpaw.csv`, MPA grid for the DBEM (JPA)
  - `mpa_cpaw.txt`, MPA grid for the DBEM (JPA)
  - worldsq_ea, folder with shapefiles of the world equidistant area for estimating size of MPA in each grid cell (JPA)
- **Species**
  - `CpawSppList10.txt`, species list to run the DBEM (JPA)
  - `NSB_species list_priorities.xlsx`, species information for project (CW)
  - `updated_species.csv`, updated taxon name of species according to WORMS (CW)

# Relevant references

