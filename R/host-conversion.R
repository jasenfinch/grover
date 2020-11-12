#' @importFrom msconverteR convert_files

hostConvertFile <- function(auth,instrument,directory,file,args = ''){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  tmp_dir <- tempdir()
  
  convert_files(files = str_c(host_repository,
                              instrument,
                              directory,
                              file,
                              sep = '/'),
                outpath = tmp_dir,
                args = args)
  
  out_file <- str_c(tmp_dir,
                    str_c(tools::file_path_sans_ext(file),
                          '.mzML'),
                    sep = '/')
  
  return(out_file)
  
}
