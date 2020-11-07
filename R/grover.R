
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
  grover(details$host,details$port,as.character(details$auth),details$repository)
}

#' grover
#' @description Create a GroverClient or GroverHost object containing API host information.
#' @param host host address
#' @param port port on which the API is hosted
#' @param auth authentication key
#' @param repository data repository directory path
#' @importFrom methods new
#' @examples 
#' grove <- grover('localhost',8000,'1234')
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
#' @description Retrieve data repository directory path key from a GroverHost.
#' @param grove S4 object of class GroverHost
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
