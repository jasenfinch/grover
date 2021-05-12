#' @importFrom readr read_file
#' @importFrom msconverteR convert_files

hostConvertFile <- function(auth,instrument,directory,file,args = NULL){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  host_temp <- grover_host$temp
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  if (length(host_temp) == 0) {
    host_temp <- tempdir() 
  }
  
  msconverteR::convert_files(files = stringr::str_c(host_repository,
                                                    instrument,
                                                    directory,
                                                    file,
                                                    sep = '/'),
                             outpath = host_temp,
                             msconvert_args = args,
                             docker_args = '--privileged')
  
  out_file <- stringr::str_c(host_temp,
                             stringr::str_c(tools::file_path_sans_ext(file),
                                            '.mzML'),
                             sep = '/')
  
  out_file <- readr::read_file(out_file)
  
  return(out_file)
  
}
