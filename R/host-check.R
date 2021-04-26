
hostExtant <- function(auth){
  
  grover_host <- yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  return("I'm still here!")
}

#' @importFrom utils packageVersion

hostVersion <- function(auth){
  grover_host <- yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  grover_version <- as.character(packageVersion('grover'))
  
  return(grover_version)
}