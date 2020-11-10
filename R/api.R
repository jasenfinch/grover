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
#' @importFrom plumber pr pr_get pr_run serializer_content_type
#' @importFrom magrittr %>%
#' @importFrom msconverteR get_pwiz_container
#' @export
 
groverAPI <- function(grover_host){
  
  get_pwiz_container()
  
  host_auth <<- auth(grover_host) 
  host_repository <<- repository(grover_host)
  
  api <- pr(envir = new.env(parent = environment()))
  
  api <- pr_get(api,
                '/convert',
                hostConvertFile,
                serializer = serializer_content_type('application/xml'))
  api <- pr_get(api,'/extant',hostExtant)
  api <- pr_get(api,
                '/getFile',
                hostGetFile)
  api <- pr_get(api,'/listFiles',hostListFiles)
  api <- pr_get(api,'/listRawFiles',hostListRawFiles)
  api <- pr_get(api,'/listDirectories',hostListDirectories)
  api <- pr_get(api,'/listInsturments',hostListInstruments)
  
  pr_run(api,
         host = host(grover_host),
         port = port(grover_host))
}
