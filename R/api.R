#' Grover API
#' @description Run the grover REST API for file conversion.
#' @param grover_host S4 object of class Grover
#' @param background Run as a background process.
#' @param log_dir directory path for API logs
#' @param temp_dir temporary directory for converted files
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
                      log_dir = '~/.grover/logs',
                      temp_dir = '~/.grover/temp'){
  
  if (isFALSE(background)) {
    API(host(grover_host),
        port(grover_host),
        auth(grover_host),
        repository(grover_host),
        log_dir = log_dir,
        temp_dir = temp_dir)
  } else {
    
    env <- 'package:grover' %>%
      as.environment() %>%
      as.list()
    
    env$host <- host(grover_host)
    env$port <- port(grover_host)
    env$auth <- auth(grover_host)
    env$repository <- repository(grover_host)
    env$log_dir <- log_dir
    env$temp_dir <- temp_dir
    
    env$API <- API
    env$writeGrover <- writeGrover
    
    env$host_preroute <- host_preroute
    env$host_postroute <- host_postroute
    
    env$hostConvertFile <- hostConvertFile
    env$hostExtant <- hostExtant
    env$hostGetFile <- hostGetFile
    env$hostListFiles <- hostListFiles
    env$hostListRawFiles <- hostListRawFiles
    env$hostListDirectories <- hostListDirectories
    env$hostListInstruments <- hostListInstruments
    env$hostSampleInfo <- hostSampleInfo
    env$hostRunInfo <- hostRunInfo
    env$hostTidy <- hostTidy
    env$hostFileInfo <- hostFileInfo
    env$hostDirectoryFileInfo <- hostDirectoryFileInfo
    env$hostInsturmentFileInfo <- hostInsturmentFileInfo
    env$hostRepositoryFileInfo <- hostRepositoryFileInfo
    
    env_path <- paste0(tempdir(),'/environment.rds')
    
    saveRDS(env,env_path)
    
    api_bg <- r_bg(function(env_path){
      
      e <- readRDS(env_path)
      e <- list2env(e)
      
      evalq(API(host,port,auth,repository,log_dir,temp_dir),e)
      
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
                temp_dir = '~/.grover/temp',
                env = parent.frame()){
  
  e <- new.env(parent = env)
  e$host <- host
  e$port <- port
  e$auth <- auth
  e$repository <- repository
  e$log_dir <- log_dir
  e$temp_dir <- temp_dir
  
  evalq({
    msconverteR::get_pwiz_container()
    
    writeGrover(host,
                port,
                auth,
                repository,
                temp_dir,
                stringr::str_c(tempdir(),'grover_host.yml',sep = '/'))
    
    if (!fs::dir_exists(log_dir)) fs::dir_create(log_dir)
    
    message(stringr::str_c('API logs can be found at ',log_dir))
    
    logger::log_appender(logger::appender_tee(tempfile("plumber_", log_dir, ".log")))
    
    api <- plumber::pr()
    
    api <- plumber::pr_hook(api,'preroute',host_preroute)
    api <- plumber::pr_hook(api,'postroute',host_postroute)
    
    api <- plumber::pr_get(api,
                  '/convert',
                  hostConvertFile,
                  serializer = plumber::serializer_content_type('application/xml'))
    api <- plumber::pr_get(api,'/extant',hostExtant)
    api <- plumber::pr_get(
      api,
      '/getFile',
      hostGetFile,
      serializer = plumber::serializer_content_type('application/octet-stream'))
    api <- plumber::pr_get(api,'/listFiles',hostListFiles)
    api <- plumber::pr_get(api,'/listRawFiles',hostListRawFiles)
    api <- plumber::pr_get(api,'/listDirectories',hostListDirectories)
    api <- plumber::pr_get(api,'/listInstruments',hostListInstruments)
    api <- plumber::pr_get(api,'/sampleInfo',hostSampleInfo)
    api <- plumber::pr_get(api,'/runInfo',hostRunInfo)
    api <- plumber::pr_put(api,'/tidy',hostTidy)
    
    api <- plumber::pr_get(api,'/fileInfo',hostFileInfo)
    api <- plumber::pr_get(api,'/directoryFileInfo',hostDirectoryFileInfo)
    api <- plumber::pr_get(api,'/instrumentFileInfo',hostInsturmentFileInfo)
    api <- plumber::pr_get(api,'/repositoryFileInfo',hostRepositoryFileInfo)
    
    plumber::pr_run(api,
           host = host,
           port = port)  
  },e)
    
}
