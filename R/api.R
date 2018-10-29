#' @importFrom plumber plumb

groverAPI <- function(grove){
  apiScript <- system.file('api/api.R')
  r <- plumb('api.R')
  
  r$run(port = port(grove),host = host(grove))
}
