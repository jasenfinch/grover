
hostTidy <- function(auth,file){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  tmp_dir <- tempdir()
  
  fd <- fs::file_delete(stringr::str_c(tmp_dir,file,sep = '/'))
  fd <-  fs::path_file(fd)
  
  return(fd)
}
