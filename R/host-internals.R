
setMethod('writeGrover',signature = 'GroverHost',function(grover_host,out = 'grover_host.yml'){
  writeLines(c(
    str_c('host: ',host(grover_host)),
    str_c('port: ',port(grover_host)),
    str_c('auth: ',auth(grover_host)),
    str_c('repository: ',repository(grover_host))
  ),
  out)
})

groverHostTemp <- function(){
  str_c(tempdir(),'grover_host.yml',sep = '/')
}

hostTidy <- function(auth,file){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  
  tmp_dir <- tempdir()
  
  if (auth == host_auth){
    unlink(str_c(tmp_dir,file,sep = '/'),
           recursive = TRUE)
  } else {
    stop('Incorrect authentication key')
  }
}