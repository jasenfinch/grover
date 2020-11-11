#' Grover API
#' @description Run the grover REST API for file conversion.
#' @param grover_host S4 object of class Grover
#' @param background Run as a background process.
#' @examples 
#' \dontrun{
#' grover_host <- grover(host = "127.0.0.1",
#'                      port = 8000,
#'                      auth = "1234",
#'                      repository = system.file('repository',
#'                                                package = 'grover'))
#' groverAPI(grover_host) 
#' }
#' @importFrom plumber pr pr_get pr_put  pr_run serializer_content_type
#' @importFrom magrittr %>%
#' @importFrom msconverteR get_pwiz_container
#' @importFrom callr r_bg
#' @export

groverAPI <- function(grover_host,background = FALSE){
  
  if (isFALSE(background)) {
    API(grover_host)
  } else {
    api_bg <- r_bg(function(grover_host,API){
      requireNamespace('grover',quietly = TRUE)
      API(grover_host)
    },
    args = list(grover_host = grover_host,API = API))
    
    return(api_bg)
  }
  
}

API <- function(grover_host){
  get_pwiz_container()
  
  writeGrover(grover_host,groverHostTemp())
  
  api <- pr()
  
  api <- pr_get(api,
                '/convert',
                hostConvertFile,
                serializer = serializer_content_type('application/xml'))
  api <- pr_get(api,'/extant',hostExtant)
  api <- pr_get(api,
                '/getFile',
                hostGetFile,
                serializer = serializer_content_type('application/octet-stream'))
  api <- pr_get(api,'/listFiles',hostListFiles)
  api <- pr_get(api,'/listRawFiles',hostListRawFiles)
  api <- pr_get(api,'/listDirectories',hostListDirectories)
  api <- pr_get(api,'/listInstruments',hostListInstruments)
  api <- pr_get(api,'/sampleInfo',hostSampleInfo)
  api <- pr_put(api,'/tidy',hostTidy)
  
  pr_run(api,
         host = host(grover_host),
         port = port(grover_host))  
}