#' @importFrom rawrr readFileHeader readIndex
#' @importFrom dplyr slice mutate select
#' @importFrom rjson toJSON
#' @importFrom tibble as_tibble

hostSampleInfo <- function(auth,instrument,directory,file){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  } 
  
  path <- stringr::str_c(host_repository,instrument,directory,file,sep = '/')
  
  sample_info <- rawrr::readFileHeader(path)
  
  sample_info <- tibble::as_tibble(sample_info)
  sample_info <- dplyr::slice(sample_info,1)
  sample_info$directory <- directory
  
  scan_filters <- rawrr::readIndex(path)$scanType
  scan_filters <- unique(scan_filters)
  scan_filters <- stringr::str_c(scan_filters,collapse = ';;;')
  
  sample_info$`Scan filters` <- scan_filters
  sample_info <- rjson::toJSON(sample_info)
  
  return(sample_info)
}
