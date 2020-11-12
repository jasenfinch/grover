
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
