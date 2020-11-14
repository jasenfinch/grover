#' @importFrom fs path_ext

hostFileInfo <- function(auth,instrument,directory,file){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  str_c(
    host_repository,
    instrument,
    directory,
    file,
    sep = '/'
  ) %>%
    file_info() %>%
    mutate(instrument = instrument,
           directory = directory,
           file = file,
           extension = path_ext(path)) %>%
    select(instrument,
           directory,
           file,
           extension,
           size,
           birth_time) %>%
    toJSON()
}

hostDirectoryFileInfo <- function(auth,instrument,directory){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  str_c(host_repository,
        instrument,
        directory,
        sep = '/') %>%
    dir_ls(recurse = TRUE) %>%
    file_info() %>%
    filter(type == 'file') %>%
    mutate(instrument = instrument,
           directory = directory,
           file = path_file(path),
           extension = path_ext(path)) %>%
    select(instrument,
           directory,
           file,
           extension,
           size,
           birth_time) %>%
    toJSON()
}

#' @importFrom dplyr filter
#' @importFrom fs path_dir

hostInsturmentFileInfo <- function(auth,instrument){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  str_c(host_repository,
        instrument,
        sep = '/') %>%
    dir_ls(recurse = TRUE) %>%
    file_info() %>%
    filter(type == 'file') %>%
    mutate(instrument = path %>%
             path_dir() %>%
             path_dir() %>%
             path_file(),
           directory = path %>%
             path_dir() %>%
             path_file(),
           file = path_file(path),
           extension = path_ext(path)) %>%
    select(instrument,
           directory,
           file,
           extension,
           size,
           birth_time) %>%
    toJSON()
}

hostRepositoryFileInfo <- function(auth){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  str_c(host_repository,
        sep = '/') %>%
    dir_ls(recurse = TRUE) %>%
    file_info() %>%
    filter(type == 'file') %>%
    mutate(instrument = path %>%
             path_dir() %>%
             path_dir() %>%
             path_file(),
           directory = path %>%
             path_dir() %>%
             path_file(),
           file = path_file(path),
           extension = path_ext(path)) %>%
    select(instrument,
           directory,
           file,
           extension,
           size,
           birth_time) %>%
    toJSON()
}
