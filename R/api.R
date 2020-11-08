#' Grover API
#' @description Run the grover REST API for file conversion.
#' @param grove S4 object of class Grover
#' @examples 
#' \dontrun{
#' grover_host <- grover(host = "127.0.0.1",
#'                      port = 8000,
#'                      auth = "1234",
#'                      repository = system.file('repository',
#'                                                package = 'grover'))
#' groverAPI(grover_host) 
#' }
#' @importFrom plumber pr pr_get pr_run
#' @export
 
groverAPI <- function(grover_host){
  host_auth <- auth(grover_host)
  
  api <- pr(envir = new.env(parent = environment()))
  
  api <- pr_get(api,'/extant',hostExtant)
  
  pr_run(api,
         host = host(grover_host),
         port = port(grover_host))
}
