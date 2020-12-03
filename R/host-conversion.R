#' @importFrom msconverteR convert_files

hostConvertFile <- function(auth,instrument,directory,file,args = ''){
  
  grover_host <-  yaml::read_yaml(
    stringr::str_c(tempdir(),
                   'grover_host.yml',
                   sep = '/'))
  host_auth <- grover_host$auth
  host_repository <- grover_host$repository
  
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
  
  tmp_dir <- tempdir()
  
  msconverteR::convert_files(files = stringr::str_c(host_repository,
                              instrument,
                              directory,
                              file,
                              sep = '/'),
                outpath = tmp_dir,
                args = args)
  
  out_file <- stringr::str_c(tmp_dir,
                    stringr::str_c(tools::file_path_sans_ext(file),
                          '.mzML'),
                    sep = '/')
  
out_file <- readr::read_file(out_file)
  
  return(out_file)
  
}
