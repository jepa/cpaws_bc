# Settings file for converting DBEM
# .txt files to .Rdata files
# Juliano Palacios

# Load required functions


library(here)
library(tidyverse)
library(doParallel)

# path to save R data
r_path <- "~/scratch/Results/R/"#output_path

# Path for reading the data
in_path <- "~/scratch/Results" #input_path

# Load required functions
source("~/projects/def-wailung/jepa/dbem/support_fx/txt_to_rdata_fx.R")

# Determine the start and end year you want to include
year_one <- 1851
year_end <- 2100

# Scenario to call (Note this will determine the results directory)
scenarios <- c("c6gfdl85f1cpaws75","c6gfdl85f1cpaws10")

# Variables to be converted (Abundace or Catch)
category <- c("Catch","Abd")

for(i in 1:length(scenarios)){
  
  scenario <- scenarios[i]
  
  # Include here the path of your DBEM raw outputs BEFORE the scenario
  taxon_list <- list.files(paste0("~/scratch/Results/",scenario,"/"),full.names = F)
  
  # Call function for scenarios in Settings file using parallel computation
  
  # Use the environment variable SLURM_CPUS_PER_TASK to set the number of cores.
  # This is for SLURM. Replace SLURM_CPUS_PER_TASK by the proper variable for your system.
  # Avoid manually setting a number of cores.
  ncores = Sys.getenv("SLURM_CPUS_PER_TASK")
  
  registerDoParallel(cores=ncores)# Shows the number of Parallel Workers to be used
  print(ncores) # this how many cores are available, and how many you have requested.
  getDoParWorkers()# you can compare with the number of actual workers
  
  # be careful! foreach() and %dopar% must be on the same line!
  foreach(tkey = taxon_list, .combine="c") %dopar% {txt_to_rdata(tkey, stryr = year_one, endyr = year_end, scenario = scenario, output_path = r_path, category = category)}
  
}