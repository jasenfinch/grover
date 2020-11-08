#' Grover API
#' @description Run the grover REST API for file conversion.
#' @param grove S4 object of class Grover
#' @examples 
#' \dontrun{
#' grove_host <- grover(host = "127.0.0.1",
#'                      port = 8000,
#'                      auth = "1234",
#'                      repository = system.file('repository',
#'                                                package = 'grover'))
#' groverAPI(grove_host) 
#' }
#' @importFrom plumber pr pr_get pr_run
#' @export
 
groverAPI <- function(grove_host){
  
  api <- pr()
  
  api <- pr_get(api,'/extant',hostExtant)
  
  pr_run(api,
         host = host(grove_host),
         port = port(grove_host))
}
