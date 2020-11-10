
hostListFiles <- function(auth,instrument,directory){
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

#' @importFrom stringr str_detect

hostListRawFiles <- function(auth,instrument,directory){
  if (auth == host_auth) {
    files <- list.files(str_c(host_repository,
                              instrument,
                              directory,
                              sep = '/'),
                        recursive = FALSE,
                        full.names = FALSE)
    if (instrument == 'TSQ'){
      return(files[str_detect(files,coll('.RAW'))])
    } else {
      return(files[str_detect(files,coll('.raw'))])
    }
  } else {
    stop('Incorrect authentication key')
  }
}

hostListDirectories <- function(auth,instrument){
  if (auth == host_auth) {
    dir(str_c(host_repository,instrument,sep = '/'))
  } else {
    stop('Incorrect authentication key')
  }
}

hostListInstruments <- function(auth){
  if (auth == host_auth){
    dir(host_repository)
  } else {
    stop('Incorrect authentication key')
  }
}
