
#' Check the existance of a grover API
#' @rdname extant
#' @description Check grover API is still extistant.
#' @param grover_client S4 object of class GroverGlient
#' @importFrom httr GET content
#' @export

setMethod('extant',signature = 'GroverClient',
          function(grover_client){
            
            cmd <- str_c(hostURL(grover_client),
                         '/extant?',
                         'auth=',auth(grover_client))
            
            answer <- try({cmd %>%
                GET() %>%
                content() %>%
                unlist()},silent = TRUE)
            
            status <- ifelse(
              answer == "I'm still here!",
              TRUE,
              FALSE
            )
            
            return(status)
          }
)

#' Return the version of a grover API
#' @rdname version
#' @description Return the version number of a grover API.
#' @param grover_client S4 object of class GroverGlient
#' @return The version number of the grover API.
#' @export

setGeneric('version',
           function(grover_client)
             standardGeneric('version'))

#' @rdname version

setMethod('version',signature = 'GroverClient',
          function(grover_client){
            cmd <- str_c(hostURL(grover_client),
                         '/version?',
                         'auth=',auth(grover_client))
            
            grover_version <- try({cmd %>%
                GET() %>%
                content() %>%
                unlist()},silent = TRUE)
            
            return(grover_version)
          })