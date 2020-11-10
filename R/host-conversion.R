#' @importFrom msconverteR convert_files

hostConvertFile <- function(auth,instrument,directory,file,args = ''){

  tmp_dir <- tempdir()
  tmp_path <- str_c(tmp_dir,instrument,directory,sep = '/') 
  
  dir.create(tmp_path,recursive = TRUE)
  
  if (auth == host_auth) {
    
    convert_files(files = str_c(host_repository,
                                instrument,
                                directory,
                                file,
                                sep = '/'),
                  outpath = tmp_path,
                  args = args)
    
    out_file <- str_c(tmp_path,
                      str_c(tools::file_path_sans_ext(file),
                      '.mzML'),
                      sep = '/')
    
    return(out_file)
    
  } else {
    stop('Incorrect authentication key')
  }
}
