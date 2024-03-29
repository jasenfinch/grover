#' @importFrom fs file_delete

writeGrover <- function(host,
                        port,
                        auth,
                        repository,
                        temp,
                        out = 'grover_host.yml',
                        env = parent.frame()){
  
  e <- new.env(parent = env)
  e$host <- host
  e$port <- port
  e$auth <- auth
  e$repository <- repository
  e$temp <- temp
  e$out <- out
  
  evalq(
    writeLines(c(
      stringr::str_c('host: ',host),
      stringr::str_c('port: ',port),
      stringr::str_c('auth: ',auth),
      stringr::str_c('repository: ',repository),
      stringr::str_c('temp: ',temp)
    ),
    out),
    e)
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
  
  logger::log_info(stringr::str_c(
    convert_empty(req$REQUEST_METHOD),
    convert_empty(req$PATH_INFO),
    stringr::str_c({req$args},collapse = ";"),
    convert_empty(res$status),
    round(end$toc - end$tic, digits = getOption("digits", 5)),
    sep = ' '
  ))
}
