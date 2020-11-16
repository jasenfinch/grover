#' Grover API
#' @description Run the grover REST API for file conversion.
#' @param grover_host S4 object of class Grover
#' @param background Run as a background process.
#' @param log_dir directory path for API logs
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

groverAPI <- function(grover_host,
                      background = FALSE,
                      log_dir = '~/.grover/logs'){
  
  if (isFALSE(background)) {
    API(host(grover_host),
        port(grover_host),
        auth(grover_host),
        repository(grover_host),
        log_dir = log_dir)
  } else {
    
    env <- 'package:grover' %>%
      as.environment() %>%
      as.list()
    
    env$host <- host(grover_host)
    env$port <- port(grover_host)
    env$auth <- auth(grover_host)
    env$repository <- repository(grover_host)
    env$log_dir <- log_dir
    
    
    env_path <- paste0(tempdir(),'/environment.rds')
    
    saveRDS(env,env_path)
    
    api_bg <- r_bg(function(env_path){
      
      e <- readRDS(env_path)
      e <- list2env(e)
      
      evalq(API(host,port,auth,repository,log_dir),e)
      
      print('helloworld')
    },
    args = list(env_path))
    
    return(api_bg)
  }
  
}

#' @importFrom fs dir_exists
#' @importFrom logger log_appender appender_tee log_info
#' @importFrom tictoc tic toc
#' @importFrom plumber pr_hook

API <- function(host,
                port,
                auth,
                repository,
                log_dir = '~/.grover/logs',
                env = parent.frame()){
  
  e <- new.env(parent = env)
  e$host <- host
  e$port <- port
  e$auth <- auth
  e$repository <- repository
  e$log_dir <- log_dir
  
  evalq({
    msconverteR::get_pwiz_container()
    
    writeGrover(host,port,auth,repository,groverHostTemp())
    
    if (!dir_exists(log_dir)) dir_create(log_dir)
    
    message('API logs can be found at ~/.grover/logs')
    
    log_appender(appender_tee(tempfile("plumber_", log_dir, ".log")))
    
    api <- pr()
    
    api <- pr_hook(api,'preroute',host_preroute)
    api <- pr_hook(api,'postroute',host_postroute)
    
    api <- pr_get(api,
                  '/convert',
                  hostConvertFile,
                  serializer = serializer_content_type('application/xml'))
    api <- pr_get(api,'/extant',hostExtant)
    api <- pr_get(
      api,
      '/getFile',
      hostGetFile,
      serializer = serializer_content_type('application/octet-stream'))
    api <- pr_get(api,'/listFiles',hostListFiles)
    api <- pr_get(api,'/listRawFiles',hostListRawFiles)
    api <- pr_get(api,'/listDirectories',hostListDirectories)
    api <- pr_get(api,'/listInstruments',hostListInstruments)
    api <- pr_get(api,'/sampleInfo',hostSampleInfo)
    api <- pr_get(api,'/runInfo',hostRunInfo)
    api <- pr_put(api,'/tidy',hostTidy)
    
    api <- pr_get(api,'/fileInfo',hostFileInfo)
    api <- pr_get(api,'/directoryFileInfo',hostDirectoryFileInfo)
    api <- pr_get(api,'/instrumentFileInfo',hostInsturmentFileInfo)
    api <- pr_get(api,'/repositoryFileInfo',hostRepositoryFileInfo)
    
    pr_run(api,
           host = host,
           port = port)  
  },e)
    
}
