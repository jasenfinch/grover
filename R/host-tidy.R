
hostTidy <- function(auth,file){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  
  checkAuth(auth,host_auth)
  
  tmp_dir <- tempdir()
  
  file_delete(str_c(tmp_dir,file,sep = '/')) %>%
    path_file()
  
}
