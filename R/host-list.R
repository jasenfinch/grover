#' @importFrom fs dir_ls

hostListFiles <- function(auth,instrument,directory){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  files <- dir_ls(str_c(host_repository,
                        instrument,
                        directory,
                        sep = '/'),
                  type = 'file',
                  recurse = FALSE) %>%
    path_file()
  
  return(files)
}

#' @importFrom stringr str_detect regex

hostListRawFiles <- function(auth,instrument,directory){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  files <- dir_ls(str_c(host_repository,
                        instrument,
                        directory,
                        sep = '/'),
                  type = 'file',
                  recurse = FALSE) %>%
    path_file()
  
  raw_files <- files[str_detect(files,
                                regex('[.]raw',ignore_case = TRUE))]
  
  return(raw_files)
  
}

#' @importFrom fs path_file

hostListDirectories <- function(auth,instrument){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  dir_ls(str_c(host_repository,instrument,sep = '/'),
         type = 'directory') %>%
    path_file()
  
}

hostListInstruments <- function(auth){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  dir_ls(host_repository,
         type = 'directory') %>%
    path_file()
}
