# Function to create percentage change maps with and without MPA runs. 
# NOTE: CURRENTLY ONLY WORKING FOR GFDL126. PATHS NEED TO BE CHANGED

pr_chg_fx <- function(paths, mpa = T){
  
  # Wrap the entire function in a tryCatch block
  result <- tryCatch({
    
    load(paths)  
    
    #Global variables
    esm = str_sub(paths,58,61)
    ssp = ifelse(str_sub(paths,62,63) == 26,"ssp126","ssp585")
    scen = ifelse(str_sub(paths,71,72) == 10,"0",paste0(str_sub(paths,71,72)))
    
    # Load Abd or MCP data
    
    if(mpa == T){
      data <- as.data.frame(data) %>% 
        rowid_to_column("index")
      colnames(data) <- c("index",(seq(1851,2100,1)))
      if(str_detect(paths,"Abd") == T){
        variable <- "abd"
      }else{
        variable <- "mcp"
      }
      
      data <- data %>% 
        select(index,`1951`:`2100`) 
      
      
    }else{
      if(exists("sppabdfnl") == T){
        data <- as.data.frame(sppabdfnl)
        colnames(data) <- seq(1951,2100,1)
        rm(sppabdfnl)
        variable <- "abd"
      }else{
        data <- as.data.frame(sppMCPfnl)
        colnames(data) <- seq(1951,2100,1)
        rm(sppMCPfnl)
        variable <- "mcp"
      } 
      
    }
    
    # Get information
    if(mpa == T){
      
      info <- taxon_list %>% 
        filter(taxon_key %in% str_sub(paths,75,80)) 
      
      title <- unique(paste0("Percentage Change"," (",variable,") for ",info$common_name," (",info$taxon_name,") under ",scen," protection (",esm,ssp,")"))
      
      extra = paste0("per_change_",esm,"_",ssp,"_",scen)
      
      plot_name <- my_path("R",extra_path = extra,paste0(unique(info$common_name),"_",variable,"_mpa.png")) 
      
    }else{
      
      info <- taxon_list %>% 
        filter(taxon_key %in% str_sub(paths,75,80)) 
      
      title <- unique(paste0("Percentage Change"," (",variable,") for ",info$common_name," (",info$taxon_name,")"))
      
      plot_name <- my_path("R",extra_path = "per_change_gfdl_585",paste0(unique(info$common_name),"_",variable,".png")) 
      
    }
    
    
    # Make data plot
    bc_data <-
      data %>%
      # Select years to analyze
      select(`1995`:`2014`,`2040`:`2059`,`2081`:`2100`) %>% 
      # filter BC
      bind_cols(
        my_data("dbem_coords")
      ) %>% 
      right_join(
        my_data("sau_index") %>% filter(eez_name == "Canada (Pacific)"),
        by ="index"
      ) %>% 
      # Wrangling data
      gather("year","value",`1995`:`2100`) %>% 
      select(-eez_name,-eez_id,-index) %>% 
      # Determine time periods
      mutate(
        time_period = ifelse(year <= 2014, "2014_hist",
                             ifelse(year >= 2040 & year <= 2059, "2050_mid","2100_end")
        )
      ) %>% 
      # Average decades for natural variabliity 
      group_by(time_period,lon,lat) %>% 
      summarise(mean_nat = mean(value, na.rm = T),
                .groups = "keep") %>% 
      spread(time_period,mean_nat) %>% 
      ungroup() %>% 
      mutate(per_chng_2050_mid = my_chng(`2014_hist`,`2050_mid`,limit = 100),
             per_chng_2100_end = my_chng(`2014_hist`,`2100_end`,limit = 100)
      ) %>% 
      select(lon,lat,per_chng_2050_mid,per_chng_2100_end) %>% 
      gather("period","change",per_chng_2050_mid,per_chng_2100_end) %>% 
      ggplot() +
      geom_tile(
        aes(
          x = lon,
          y = lat,
          fill = change,
          color = change
        )
      ) +
      scale_fill_gradient2("Change (%)",na.value = "white") +
      scale_color_gradient2("Change (%)", na.value = "white") +
      # extra maps
      geom_sf(data = bs_sf, aes(), color = "black", fill = "transparent") +
      geom_sf(data = bc_eez, aes(), color = "grey50", fill = "transparent") +
      MyFunctions::my_land_map() +
      labs(
        x = "Longitude",
        y = "Latitude"
      ) +
      coord_sf(
        xlim = c(-120,-140),
        ylim = c(46,56)
      ) +
      theme_classic()+
      ggtitle(title)+
      facet_wrap(~period, ncol = 2)
    
    
    ggsave(plot = bc_data,
           filename = str_to_lower(gsub(" ","_",plot_name)),
           height = 5,
           width = 9)
    
    print(plot_name)
    # Return a success message or result if needed
    return("Function completed successfully.")
    
  }, error = function(e) {
    # Error handling
    message("Error occurred in main_fx:", e$message)
    # Return a message or value to indicate failure
    return("Function encountered an error but continued execution.")
  })
  
}
