
hostTidy <- function(auth,file){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  host_temp <- grover_host$temp
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  if (length(host_temp) == 0) {
    host_temp <- tempdir() 
  }
  
  fd <- fs::file_delete(stringr::str_c(host_temp,file,sep = '/'))
  fd <-  fs::path_file(fd)
  
  return(fd)
}
