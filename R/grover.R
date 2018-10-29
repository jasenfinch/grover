#' @importFrom readr
#' @export

readGrover <- function(path){
  details <- readr::read_lines(path)
  grover(details[[1]],details[[2]],details[[3]])
}

#' @export

grover <- function(host,port,auth){
new('Grover',
    host = host,
    port = port,
    auth = auth)
}

#' @export

host <- function(grove){
  grove@host
}

#' @export

port <- function(grove){
  grove@port
}

#' @export

auth <- function(grove){
  grove@auth
}