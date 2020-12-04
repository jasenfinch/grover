
globalVariables(
  c('host_auth','host_repository','Sample row number','Sample type',
    'RAW file','Sample id','Instrument method','Sample vial',
    'Sample injection volume','Sample dilution factor',
    'Sample comment','User text 0','User text 1','User text 2',
    'User text 3','User text 4','Creation date','Instrument name',
    'Instrument model','Serial number','Software version','.','Sample volume',
    'type','path','extension','size','birth_time','instrument','directory'),
)

#' Parse a grover configuration file
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

#' GroverClient and GroverHost class constructor
#' @description Create a GroverClient or GroverHost class object containing 
#' API host information.
#' @param host host address
#' @param port port on which the API is hosted
#' @param auth authentication key
#' @param repository data repository directory path
#' @param temp optional directory path for grover hosts where temporary converted files can be saved
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

#' GroverClient get and set methods
#' @rdname GroverClient-accessors
#' @description Retrieve or set host information for a GroverClient objects.
#' @param grover_client S4 object of class GroverClient
#' @param value new host value to set
#' @export

setMethod('host',signature = 'GroverClient',
          function(grover_client){
            grover_client@host
          }
)

#' @rdname GroverClient-accessors
#' @export

setMethod('host<-',signature = 'GroverClient',
          function(grover_client,value){
            grover_client@host <- value
            return(grover_client)
          }
)


#' @rdname GroverClient-accessors
#' @export

setMethod('port',signature = 'GroverClient',
          function(grover_client){
            grover_client@port
          }
)

#' @rdname GroverClient-accessors
#' @export

setMethod('port<-',signature = 'GroverClient',
          function(grover_client, value){
            grover_client@port <- value
            return(grover_client)
          }
)

#' @rdname GroverClient-accessors
#' @export

setMethod('auth',signature = 'GroverClient',
          function(grover_client){
            grover_client@auth
          }
)

#' @rdname GroverClient-accessors
#' @export

setMethod('auth<-',signature = 'GroverClient',
          function(grover_client,value){
            grover_client@auth <- value
            return(grover_client)
          }
)

#' GroverHost get and set methods
#' @rdname GroverHost-accessors
#' @description Retrieve or set host information for GroverHost objects.
#' @param grover_host S4 object of class GroverHost
#' @param value new host value to set
#' @export

setMethod('repository',signature = 'GroverHost',
          function(grover_host){
            grover_host@repository
          }
)

#' @rdname GroverHost-accessors
#' @export

setMethod('repository<-',signature = 'GroverHost',
          function(grover_host,value){
            grover_host@repository <- value
            return(grover_host)
          }
)

#' @importFrom stringr str_c

setMethod('hostURL',signature = 'GroverClient',
          function(grover_client){
            if (port(grover_client) != 80) {
              url <- str_c('http://',host(grover_client),':',port(grover_client)) 
            } else {
              url <- str_c('http://',host(grover_client))
            }
            return(url)          
          }
)
