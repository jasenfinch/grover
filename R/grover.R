#' @importFrom readr read_lines
#' @export

readGrover <- function(path){
  details <- readr::read_lines(path)
  grover(details[[1]],details[[2]] %>% as.numeric(),details[[3]])
}

#' grover
#' @examples 
#' grove <- grover('127.0.0.1',8000,'1234')
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
#' @importFrom stringr str_c
#' @export

checkGrover <- function(grove){
  cmd <- str_c(host(grove),':',port(grove),'/extant?','auth=',auth(grove))
  answer <- try({cmd %>%
      GET() %>%
      content() %>%
      unlist()},silent = T)
  if (answer != "I'm here!") {
    answer <- 'grover is MIA!'
  }
  return(answer)
}