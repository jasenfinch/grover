
globalVariables(c('grove'))

globalVariables(c('V1','V2','Date','Time','Sample','.','sample_order',
                  'sample_name','inj_order','creation_date','file_name',
                  'instrument_method','path','inj_vol','sample_wt','sample_vol',
                  'dilution','fileName'))

#' readGrover
#' @description Read grover API host information from a text file.
#' @param path file path to text file containing host information
#' @details The text file should contain 3 lines, the first the host address, the second the port on which it is hosted and lastly the authentication key needed
#' @examples 
#' \dontrun{
#' grover_example <- system.file('example_grover.yml',
#'                               package = 'grover')
#' grove <- readGrover(grover_example)
#' }
#' @importFrom yaml read_yaml
#' @export

readGrover <- function(path = 'grover.yml'){
  details <- read_yaml(path)
  grover(details$host,details$port,as.character(details$authKey))
}

#' grover
#' @description Create a Grover object containing API host information.
#' @param host host address
#' @param port port on which the API is hosted
#' @param auth authentication key
#' @importFrom methods new
#' @examples 
#' grove <- grover('localhost',8000,'1234')
#' @export

grover <- function(host,port,auth){
  new('Grover',
      host = host,
      port = port,
      auth = auth)
}

#' host
#' @rdname host
#' @description Retrieve host information from a Grover object.
#' @param grove S4 object of class Grover 
#' @export

setMethod('host',signature = 'Grover',
          function(grove){
            grove@host
          }
)

#' port
#' @rdname port
#' @description Retrieve port information from a Grover object.
#' @param grove S4 object of class Grover
#' @export

setMethod('port',signature = 'Grover',
          function(grove){
            grove@port
          }
)

#' auth
#' @rdname auth
#' @description Retrieve authentication key from a Grover object.
#' @param grove S4 object of class Grover
#' @export

setMethod('auth',signature = 'Grover',
          function(grove){
            grove@auth
          }
)

#' checkGrover
#' @description Check grover API is active.
#' @param grove S4 object of class Grover
#' @importFrom stringr str_c
#' @export

checkGrover <- function(grove){
  cmd <- str_c(hostURL(grove),'/extant?','authKey=',auth(grove))
  answer <- try({cmd %>%
      GET() %>%
      content() %>%
      unlist()},silent = T)
  if (answer != "I'm still here!") {
    answer <- 'grover is MIA!'
  }
  return(answer)
}

hostURL <- function(grove){
  if (port(grove) != 80) {
    url <- str_c('http://',host(grove),':',port(grove)) 
  } else {
    url <- str_c('http://',host(grove))
  }
  return(url)
}