#' @importFrom fs dir_ls

hostListFiles <- function(auth,instrument,directory){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  files <- fs::dir_ls(stringr::str_c(host_repository,
                                     instrument,
                                     directory,
                                     sep = '/'),
                      type = 'file',
                      recurse = FALSE)
  files <- fs::path_file(files)
  
  return(files)
}

#' @importFrom stringr str_detect regex

hostListRawFiles <- function(auth,instrument,directory){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  files <- fs::dir_ls(stringr::str_c(host_repository,
                                     instrument,
                                     directory,
                                     sep = '/'),
                      type = 'file',
                      recurse = FALSE)
  files <- fs::path_file(files)
  
  raw_files <- files[stringr::str_detect(files,
                                         stringr::regex('[.]raw',ignore_case = TRUE))]
  
  return(raw_files)
  
}

#' @importFrom fs path_file

hostListDirectories <- function(auth,instrument){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  directories <- fs::dir_ls(stringr::str_c(host_repository,instrument,sep = '/'),
             type = 'directory')
  directories <- fs::path_file(directories)
  
  return(directories)
}

hostListInstruments <- function(auth){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  instruments <- fs::dir_ls(host_repository,
                            type = 'directory')
  instruments <- fs::path_file(instruments)
  
  return(instruments)
}
