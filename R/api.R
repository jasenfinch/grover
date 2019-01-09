#' Grover API
#' @description Run the grover REST API for file conversion
#' @examples 
#' groverAPI(readGrover())
#' @importFrom plumber plumb
#' @export
 
groverAPI <- function(grove){
  # api <- plumber$new()
  # 
  # api$handle('GET','/extant',extant)
  
  # api$handle('GET','/repository',repository)
  
  api <- plumb(system.file('api/api.r',package = 'grover'))
  
  api$run(port = port(grove),host = host(grove))
}
