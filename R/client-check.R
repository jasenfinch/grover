#' extant
#' @rdname extant
#' @description Check grover API is still extistant.
#' @param grove S4 object of class GroverGlient
#' @importFrom stringr str_c
#' @export

setMethod('extant',signature = 'GroverClient', 
          function(grove){
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
)
          