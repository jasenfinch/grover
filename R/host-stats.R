#' @importFrom fs path_ext

hostFileInfo <- function(auth,instrument,directory,file){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  info <- stringr::str_c(
    host_repository,
    instrument,
    directory,
    file,
    sep = '/'
  )
  info <- fs::file_info(info)
  info <- dplyr::mutate(info,
                        instrument = instrument,
                        directory = directory,
                        file = file,
                        extension = fs::path_ext(path))
  info <- dplyr::select(info,
                        instrument,
                        directory,
                        file,
                        extension,
                        size,
                        birth_time)
  info <- rjson::toJSON(info)
  
  return(info)
}

hostDirectoryFileInfo <- function(auth,instrument,directory){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  info <- stringr::str_c(
    host_repository,
    instrument,
    directory,
    sep = '/'
  )
  
  info <- fs::dir_ls(info,recurse = TRUE)
  info <- fs::file_info(info)
  info <- dplyr::filter(info,type == 'file')
  info <- dplyr::mutate(info,
                        instrument = instrument,
                        directory = directory,
                        file = fs::path_file(path),
                        extension = fs::path_ext(path))
  info <- dplyr::select(info,
                        instrument,
                        directory,
                        file,
                        extension,
                        size,
                        birth_time)
  info <- rjson::toJSON(info)
  
  return(info)
}

#' @importFrom dplyr filter
#' @importFrom fs path_dir

hostInsturmentFileInfo <- function(auth,instrument){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  info <- stringr::str_c(
    host_repository,
    instrument,
    sep = '/'
  )
  
  info <- fs::dir_ls(info,recurse = TRUE)
  info <- fs::file_info(info)
  info <- dplyr::filter(info,type == 'file')
  info <- dplyr::mutate(info,instrument = instrument, 
           directory = fs::path_file(fs::path_dir(path)),
           file = fs::path_file(path),
           extension = fs::path_ext(path))
  info <- dplyr::select(info,
                        instrument,
                        directory,
                        file,
                        extension,
                        size,
                        birth_time)
  info <- rjson::toJSON(info)
  
  return(info)
}

hostRepositoryFileInfo <- function(auth){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  info <- stringr::str_c(
    host_repository,
    sep = '/'
  )
  
  info <- fs::dir_ls(info,recurse = TRUE)
  info <- fs::file_info(info)
  info <- dplyr::filter(info,type == 'file')
  info <- dplyr::mutate(info,instrument = fs::path_file(fs::path_dir(fs::path_dir(path))), 
                        directory = fs::path_file(fs::path_dir(path)),
                        file = fs::path_file(path),
                        extension = fs::path_ext(path))
  info <- dplyr::select(info,
                        instrument,
                        directory,
                        file,
                        extension,
                        size,
                        birth_time)
  info <- rjson::toJSON(info)
  
  return(info)
}
