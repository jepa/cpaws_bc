
# Function to estimate the total abundance at the whole EEZ for both MPA and no-MPA runs
agg_per_spp_abd <- function(dbem_paths, grid = F){

  # Wrap the entire function in a tryCatch block
  result <- tryCatch({
    
  for(i in 1:nrow(dbem_paths)){
    
    #Global variables
    esm = str_sub(dbem_paths$dbem_mpa_path[i],58,61)
    ssp = ifelse(str_sub(dbem_paths$dbem_mpa_path[i],62,63) == 26,"ssp126","ssp585")
    scen = ifelse(str_sub(dbem_paths$dbem_mpa_path[i],71,72) == 10,"0",paste0(str_sub(dbem_paths$dbem_mpa_path[i],71,72)))
    
    # Load MPA run
    load(dbem_paths$dbem_mpa_path[i])
    mpa_data <- as.data.frame(data) %>% 
      rowid_to_column("index") %>% 
      filter(index %in% bc_grid) 
    
    colnames(mpa_data) <- c("index",seq(1851,2100,1))
    rm(data)
    
    mpa_data <- mpa_data %>% 
      select(index,`1951`:`2100`) %>%
      mutate(run = "mpa",
             variable = variable,
             esm=esm,
             ssp = ssp,
             scenario = scen)
      
    # Load no-MPA run
    load(dbem_paths$dbem_no_mpa_path[i])
    no_mpa_data <- as.data.frame(sppabdfnl) %>% 
      rowid_to_column("index") %>% 
      filter(index %in% bc_grid)
    
    colnames(no_mpa_data) <- c("index",seq(1951,2100,1))
    rm(sppabdfnl)
    
    no_mpa_data <- no_mpa_data %>% 
      mutate(run = "no_mpa",
             variable = variable,
             esm=esm,
             ssp = ssp,
             scenario = scen
             )
    
    # combine both data
    if(grid == T){
      partial_grids <-  mpa_data %>% 
        bind_rows(no_mpa_data) %>% 
        gather("year","value",`1951`:`2100`) %>% 
        mutate(
          time_frame = ifelse(year > 1995 & year < 2014, "historic",
                              ifelse(year > 2041 & year < 2060, "early_2050",
                                     ifelse(year > 2081 & year < 2100, "end_2100",NA)
                              )
          )
        ) %>% 
        filter(!is.na(time_frame)) %>% 
        left_join(status_grid,
                  by = "index") %>% 
        group_by(run,variable,status,time_frame) %>% 
        summarise(
          mean = mean(value,na.rm = T),
          sum = sum(value,na.rm = T),
          .groups = "drop"
        ) %>% 
        mutate(taxon_key = dbem_paths$taxon_key[i])
    }else{
      
      partial_grids <- mpa_data %>% 
        bind_rows(no_mpa_data) %>% 
        gather("year","value",`1951`:`2100`) %>% 
        group_by(run,variable,year, scenario, esm, ssp) %>% 
        summarise(
          mean = mean(value,na.rm = T),
          sum = sum(value,na.rm = T),
          .groups = "drop"
        ) %>% 
        mutate(taxon_key = dbem_paths$taxon_key[i])
    }
    
    if(i == 1){
      final_data <- partial_grids
    }else{
      final_data <- bind_rows(final_data,partial_grids)
    }
    
  }
  
  return(final_data)
    
  }, error = function(e) {
    # Error handling
    message("Error occurred in main_fx:", e$message)
    # Return a message or value to indicate failure
    return("Function encountered an error but continued execution.")
  })
}
