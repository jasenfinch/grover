
hostListFiles <- function(auth,instrument,directory){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  if (auth == host_auth) {
    files <- list.files(str_c(host_repository,
                              instrument,
                              directory,
                              sep = '/'),
                        recursive = FALSE,
                        full.names = FALSE)
  } else {
    stop('Incorrect authentication key')
  }
  return(files)
}

#' @importFrom stringr str_detect regex

hostListRawFiles <- function(auth,instrument,directory){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  if (auth == host_auth) {
    files <- list.files(str_c(host_repository,
                              instrument,
                              directory,
                              sep = '/'),
                        recursive = FALSE,
                        full.names = FALSE)
    
    raw_files <- files[str_detect(files,
                                  regex('[.]raw',ignore_case = TRUE))]
    
    return(raw_files)
  } else {
    stop('Incorrect authentication key')
  }
}

hostListDirectories <- function(auth,instrument){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  if (auth == host_auth) {
    dir(str_c(host_repository,instrument,sep = '/'))
  } else {
    stop('Incorrect authentication key')
  }
}

hostListInstruments <- function(auth){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  if (auth == host_auth){
    dir(host_repository)
  } else {
    stop('Incorrect authentication key')
  }
}
