#' @importFrom readr
#' @export

readGrover <- function(path){
  details <- readr::read_lines(path)
  grover(details[[1]],details[[2]],details[[3]])
}

#' grover
#' @export

grover <- function(host,port,auth){
new('Grover',
    host = host,
    port = port,
    auth = auth)
}

#' host
#' @export

host <- function(grove){
  grove@host
}

#' port
#' @export

port <- function(grove){
  grove@port
}

#' auth
#' @export

auth <- function(grove){
  grove@auth
}

#' checkGrover
#' @export

checkGrover <- function(grove){
  cmd <- str_c(host(grove),':',port(grove),'/extant?','auth=',auth(grove))
  answer <- try({cmd %>%
      GET() %>%
      content() %>%
      unlist()},silent = T)
  if (answer != "I'm still here!") {
    answer <- 'grover is MIA!'
  }
  return(answer)
}