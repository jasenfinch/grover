#' @importFrom fs file_delete

setMethod('writeGrover',signature = 'GroverHost',
          function(grover_host,out = 'grover_host.yml'){
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

checkAuth <- function(auth,host_auth){
  if (auth != host_auth){
    stop('Incorrect authentication key',call. = FALSE)
  }
}

convert_empty <- function(string) {
  if (string == "") {
    "-"
  } else {
    string
  }
}

host_preroute <-  function(req) {
  tic()
}

host_postroute <- function(req, res) {
  end <- toc(quiet = TRUE)
  
  print (req)
  
  log_info(str_c(
    convert_empty(req$REQUEST_METHOD),
    convert_empty(req$PATH_INFO),
    str_c({req$args},collapse = ";"),
    convert_empty(res$status),
    round(end$toc - end$tic, digits = getOption("digits", 5)),
    sep = ' '
  ))
}
