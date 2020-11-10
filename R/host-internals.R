
hostTidy <- function(auth,file){
  
  tmp_dir <- tempdir()
  
  if (auth == host_auth){
    unlink(str_c(tmp_dir,file,sep = '/'),
           recursive = TRUE)
  } else {
    stop('Incorrect authentication key')
  }
}