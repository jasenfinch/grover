#' @importFrom fs file_delete

writeGrover <- function(host,
                        port,
                        auth,
                        repository,
                        out = 'grover_host.yml',
                        env = parent.frame()){
  
  e <- new.env(parent = env)
  e$host <- host
  e$port <- port
  e$auth <- auth
  e$repository <- repository
  e$out <- out
  
  evalq(
    writeLines(c(
      stringr::str_c('host: ',host),
      stringr::str_c('port: ',port),
      stringr::str_c('auth: ',auth),
      stringr::str_c('repository: ',repository)
    ),
    out),
    e)
}

groverHostTemp <- function(){
  stringr::str_c(tempdir(),'grover_host.yml',sep = '/')
}

checkAuth <- function(auth,host_auth){
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
}

host_preroute <-  function(req) {
  tictoc::tic()
}

host_postroute <- function(req, res) {
  
  convert_empty <- function(string) {
    if (string == "") {
      "-"
    } else {
      string
    }
  }
  
  end <- tictoc::toc(quiet = TRUE)
  
  print (req)
  
  logger::log_info(stringr::str_c(
    convert_empty(req$REQUEST_METHOD),
    convert_empty(req$PATH_INFO),
    stringr::str_c({req$args},collapse = ";"),
    convert_empty(res$status),
    round(end$toc - end$tic, digits = getOption("digits", 5)),
    sep = ' '
  ))
}
