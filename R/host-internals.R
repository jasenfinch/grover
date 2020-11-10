
hostTidy <- function(auth,instrument,directory){
  
  tmp_dir <- tempdir()
  tmp_path <- str_c(tmp_dir,instrument,directory,sep = '/')
  
  if (auth == host_auth){
    unlink(tmp_path,
           recursive = TRUE)
  } else {
    stop('Incorrect authentication key')
  }
}