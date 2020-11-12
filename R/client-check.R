#' extant
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
           
             if (answer != "I'm still here!") {
              answer <- 'grover is MIA!'
             }
            
            return(answer)
          }
)
