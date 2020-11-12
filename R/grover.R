
globalVariables(
  c('host_auth','host_repository','Sample row number','Sample type',
    'RAW file','Sample id','Instrument method','Sample vial',
    'Sample injection volume','Sample dilution factor',
    'Sample comment','User text 0','User text 1','User text 2',
    'User text 3','User text 4','Creation date','Instrument name',
    'Instrument model','Serial number','Software version','.','Sample volume'),
)

#' readGrover
#' @description Read grover API host information from a text file.
#' @param path file path to text file containing host information
#' @details The text file should contain 3 lines, the first the host address, 
#' the second the port on which it is hosted and lastly the authentication
#'  key needed
#' @examples 
#' ## Grover client
#' grover_client <- system.file('grover_client.yml',
#'                               package = 'grover')
#' grover_client <- readGrover(grover_client)
#' 
#' ## Grover host
#' grover_host <- system.file('grover_host.yml',
#'                               package = 'grover')
#' grover_host <- readGrover(grover_host)
#' @importFrom yaml read_yaml
#' @export

readGrover <- function(path = 'grover.yml'){
  details <- read_yaml(path)
  grover(details$host,
         details$port,
         as.character(details$auth),
         details$repository)
}

#' grover
#' @description Create a GroverClient or GroverHost object containing 
#' API host information.
#' @param host host address
#' @param port port on which the API is hosted
#' @param auth authentication key
#' @param repository data repository directory path
#' @importFrom methods new
#' @examples
#' ## Grover client 
#' grover_client <- grover(host = "127.0.0.1",
#'                      port = 8000,
#'                      auth = "1234")
#' 
#' ## Grover host
#' grover_host <- grover(host = "127.0.0.1",
#'                      port = 8000,
#'                      auth = "1234",
#'                      repository = system.file('repository',
#'                                                package = 'grover'))
#' @export

grover <- function(host,port,auth,repository = NULL){
  
  if (is.null(repository)) {
    grove <- new('GroverClient',
                 host = host,
                 port = port,
                 auth = auth)  
  } else {
    grove <- new('GroverHost',
                 host = host,
                 port = port,
                 auth = auth,
                 repository = repository
    )
  }
  return(grove)
}

#' host
#' @rdname host
#' @description Retrieve host information from a Grover object.
#' @param grove S4 object of class GroverClient
#' @param value new host value to set
#' @export

setMethod('host',signature = 'GroverClient',
          function(grove){
            grove@host
          }
)

#' @rdname host

setMethod('host<-',signature = 'GroverClient',
          function(grove,value){
            grove@host <- value
            return(grove)
          }
)

#' port
#' @rdname port
#' @description Retrieve port information from a Grover object.
#' @param grove S4 object of class GroverClient
#' @param value new port value to set
#' @export

setMethod('port',signature = 'GroverClient',
          function(grove){
            grove@port
          }
)

#' @rdname port

setMethod('port<-',signature = 'GroverClient',
          function(grove, value){
            grove@port <- value
            return(grove)
          }
)

#' auth
#' @rdname auth
#' @description Retrieve authentication key from a Grover object.
#' @param grove S4 object of class GroverClient
#' @param value new auth value to set
#' @export

setMethod('auth',signature = 'GroverClient',
          function(grove){
            grove@auth
          }
)

#' @rdname auth

setMethod('auth<-',signature = 'GroverClient',
          function(grove,value){
            grove@auth <- value
            return(grove)
          }
)

#' repository
#' @rdname repository
#' @description Retrieve data repository directory path key 
#' from a GroverHost.
#' @param grove S4 object of class GroverHost
#' @param value new repository value to set
#' @export

setMethod('repository',signature = 'GroverHost',
          function(grove){
            grove@repository
          }
)

#' @rdname repository

setMethod('repository<-',signature = 'GroverHost',
          function(grove,value){
            grove@repository <- value
            return(grove)
          }
)

#' @importFrom stringr str_c

setMethod('hostURL',signature = 'GroverClient',
          function(grove){
            if (port(grove) != 80) {
              url <- str_c('http://',host(grove),':',port(grove)) 
            } else {
              url <- str_c('http://',host(grove))
            }
            return(url)          
          }
)
