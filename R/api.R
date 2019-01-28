#' Grover API
#' @description Run the grover REST API for file conversion.
#' @param grove S4 object of class Grover
#' @examples 
#' \dontrun{
#' groverAPI(readGrover())
#' }
#' @importFrom plumber plumb
#' @export
 
groverAPI <- function(grove){
  # api <- plumber$new()
  # 
  # api$handle('GET','/extant',extant)
  
  # api$handle('GET','/repository',repository)
  
  api <- plumb(system.file('api/api.R',package = 'grover'))
  
  api$run(port = port(grove),host = host(grove))
}
