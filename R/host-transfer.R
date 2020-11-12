#' @importFrom fs file_exists file_info

hostGetFile <- function(auth,instrument,directory,file){

  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  if (auth == host_auth) {
    f <- str_c(host_repository,instrument,directory,file,sep = '/')
    if (file_exists(f)) {
      con <- file(f,'rb')
      f <- readBin(con,
                   'raw',
                   n = file_info(f)$size) 
      close(con)
    } else {
      stop('File not found!')
    }
  } else {
    stop('Incorrect authentication key')
  }
  return(f)
}
