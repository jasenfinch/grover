#' @importFrom plumber plumber
#' @export
 
groverAPI <- function(grove,repository,tmp){
  api <- plumber$new()
  
  api$handle('GET','/extant',extant)
  
  # api$handle('GET','/repository',repository)
  
  api$run(port = port(grove),host = host(grove))
}
