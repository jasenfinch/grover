#' @importFrom fs file_exists file_info

hostGetFile <- function(auth,instrument,directory,file){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  } 
  
  f <- stringr::str_c(host_repository,instrument,directory,file,sep = '/')
  if (fs::file_exists(f)) {
    con <- file(f,'rb')
    f <- readBin(con,
                 'raw',
                 n = fs::file_info(f)$size) 
    close(con)
  } else {
    stop('File not found!')
  }
  
  return(f)
}
