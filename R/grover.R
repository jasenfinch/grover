#' @importFrom readr read_lines
#' @export

readGrover <- function(path = '~/grover.txt'){
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

setMethod('host',signature = 'Grover',
          function(grove){
            grove@host
          }
)

#' port
#' @export

setMethod('port',signature = 'Grover',
          function(grove){
            grove@port
          }
)

#' auth
#' @export

setMethod('auth',signature = 'Grover',
          function(grove){
            grove@auth
          }
)

#' checkGrover
#' @importFrom stringr str_c
#' @export

checkGrover <- function(grove){
  cmd <- str_c(host(grove),':',port(grove),'/extant?','authKey=',auth(grove))
  answer <- try({cmd %>%
      GET() %>%
      content() %>%
      unlist()},silent = T)
  if (answer != "I'm still here!") {
    answer <- 'grover is MIA!'
  }
  return(answer)
}