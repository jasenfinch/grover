#' @importFrom rawR readFileHeader readIndex
#' @importFrom dplyr slice mutate select
#' @importFrom rjson toJSON
#' @importFrom tibble as_tibble

hostSampleInfo <- function(auth,instrument,directory,file){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  if (auth == host_auth) {
    path <- str_c(host_repository,instrument,directory,file,sep = '/')
    
    sample_info <- readFileHeader(path) %>%
      as_tibble() %>%
      slice(1) %>%
      mutate(directory = directory) %>%
      select(`fileOrder` = `Sample row number`,
             sample_type = `Sample type`,
             fileName = `RAW file`,
             sample_id = `Sample id`,
             directory,
             instrument_method = `Instrument method`,
             position = `Sample vial`,
             inj_vol = `Sample injection volume`,
             sample_vol = `Sample volume`,
             dilution = `Sample dilution factor`,
             comment = `Sample comment`,
             batch = `User text 0`,
             block = `User text 1`,
             name = `User text 2`,
             class = `User text 3`,
             injOrder = `User text 4`,
             creation_date = `Creation date`,
             instrument_name = `Instrument name`,
             instrument_model = `Instrument model`,
             instrument_serial = `Serial number`,
             software_version = `Software version`,
      )
    
    scan_filters <- readIndex(path) %>%
      .$scanType %>%
      unique() %>%
      str_c(collapse = ';;;')
    
    sample_info <- sample_info %>%
      mutate(scan_filters = scan_filters) %>%
      split(seq_len(nrow(.))) %>%
      unname() %>%
      toJSON()
    
    return(sample_info)
  } else {
    stop('Incorrect authentication key')
  }
}
